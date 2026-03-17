import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

// ──────────────────────────────────────────────────────────────────────
//  Change to your backend LAN IP when testing on a physical device.
//  Android emulator: http://10.0.2.2:3000
// ──────────────────────────────────────────────────────────────────────
const String _baseUrl = 'https://z85tjm9t-3000.inc1.devtunnels.ms';

const String _userKey = 'logged_in_user';
const String _fixedPassword = 'Sairam@123';

class ApiService {
  // ────────────────────────────────────────────────────────────────────
  // LOCAL LOGIN — validates password and SIT/SEC prefix, no API call
  // ────────────────────────────────────────────────────────────────────
  static Future<Map<String, dynamic>> login({
    required String collegeId,
    required String password,
    String? mobile,
    String? department,
    String? year,
    String? section,
    String? mentor,
  }) async {
    final prefix = collegeId.toUpperCase();
    if (!prefix.startsWith('SIT') && !prefix.startsWith('SEC')) {
      return {
        'success': false,
        'message': 'College ID must start with SIT or SEC.',
      };
    }
    if (password != _fixedPassword) {
      return {'success': false, 'message': 'Invalid password.'};
    }

    final user = {
      'college_id': collegeId,
      'mobile': mobile ?? '',
      'department': department ?? '',
      'year': year ?? '',
      'section': section ?? '',
      'mentor': mentor ?? '',
    };

    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_userKey, jsonEncode(user));

    // Save student details to the backend DB
    try {
      await http.post(
        Uri.parse('$_baseUrl/api/students/save'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(user),
      );
    } catch (_) {
      // Best-effort — local login still succeeds even if server is unreachable
    }

    return {'success': true, 'student': user};
  }

  // ────────────────────────────────────────────────────────────────────
  // Session helpers
  // ────────────────────────────────────────────────────────────────────
  static Future<bool> isLoggedIn() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.containsKey(_userKey);
  }

  static Future<Map<String, dynamic>?> getCachedUser() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_userKey);
    if (raw == null) return null;
    return jsonDecode(raw) as Map<String, dynamic>;
  }

  static Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_userKey);
  }

  // ────────────────────────────────────────────────────────────────────
  // POST /api/survey  — sends college_id in body, no token needed
  // ────────────────────────────────────────────────────────────────────
  static Future<Map<String, dynamic>> submitSurvey(
      Map<String, dynamic> payload,
      ) async {
    final user = await getCachedUser();
    payload['college_id'] = user?['college_id'] ?? '';

    final response = await http.post(
      Uri.parse('$_baseUrl/api/survey'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(payload),
    );
    print("STATUS CODE: ${response.statusCode}");
    print("SERVER RESPONSE: ${response.body}");

    final body = response.body.trim();
    if (body.isEmpty) {
      return {
        'success': false,
        'message': 'Server returned an empty response (status ${response.statusCode}).',
      };
    }
    try {
      return jsonDecode(body) as Map<String, dynamic>;
    } catch (_) {
      return {
        'success': false,
        'message': 'Invalid server response (status ${response.statusCode}).',
      };
    }
  }

  // ────────────────────────────────────────────────────────────────────
  // GET /api/survey/my?college_id=...
  // ────────────────────────────────────────────────────────────────────
  static Future<Map<String, dynamic>> getMySurveys() async {
    final user = await getCachedUser();
    final collegeId = user?['college_id'] ?? '';

    final response = await http.get(
      Uri.parse('$_baseUrl/api/survey/my?college_id=$collegeId'),
      headers: {'Content-Type': 'application/json'},
    );

    return jsonDecode(response.body) as Map<String, dynamic>;
  }
}