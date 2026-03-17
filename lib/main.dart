import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:animate_do/animate_do.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:geolocator/geolocator.dart';
import 'services/api_service.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const UBASurveyApp());
}

// ==========================================
// KEEPS PAGE DATA ALIVE WHEN SWIPING
// ==========================================
class KeepAlivePage extends StatefulWidget {
  final Widget child;
  const KeepAlivePage({Key? key, required this.child}) : super(key: key);

  @override
  State<KeepAlivePage> createState() => _KeepAlivePageState();
}

class _KeepAlivePageState extends State<KeepAlivePage>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return widget.child;
  }
}

// ==========================================
// 1. GLOBAL STATE & MODERN THEME
// ==========================================
class UBASurveyApp extends StatefulWidget {
  const UBASurveyApp({Key? key}) : super(key: key);
  static _UBASurveyAppState of(BuildContext context) =>
      context.findAncestorStateOfType<_UBASurveyAppState>()!;
  @override
  State<UBASurveyApp> createState() => _UBASurveyAppState();
}

class _UBASurveyAppState extends State<UBASurveyApp> {
  ThemeMode _themeMode = ThemeMode.light;
  void toggleTheme() => setState(
        () => _themeMode = _themeMode == ThemeMode.light
        ? ThemeMode.dark
        : ThemeMode.light,
  );

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'UBA Survey Pro',
      debugShowCheckedModeBanner: false,
      themeMode: _themeMode,
      theme: ThemeData(
        brightness: Brightness.light,
        primaryColor: const Color(0xFFE58D00),
        scaffoldBackgroundColor: const Color(0xFFF8FAFC),
        cardColor: Colors.white,
        textTheme: GoogleFonts.plusJakartaSansTextTheme(
          ThemeData.light().textTheme,
        ),
        colorScheme: const ColorScheme.light(
          primary: Color(0xFFE58D00),
          secondary: Color(0xFF0F172A),
        ),
      ),
      darkTheme: ThemeData(
        brightness: Brightness.dark,
        primaryColor: const Color(0xFFFBBF24),
        scaffoldBackgroundColor: const Color(0xFF0F172A),
        cardColor: const Color(0xFF1E293B),
        textTheme: GoogleFonts.plusJakartaSansTextTheme(
          ThemeData.dark().textTheme,
        ),
        colorScheme: const ColorScheme.dark(
          primary: Color(0xFFFBBF24),
          secondary: Colors.white,
        ),
      ),
      home: const SplashScreen(),
    );
  }
}

// ==========================================
// 2. PREMIUM UI / UX HELPER COMPONENTS
// ==========================================
class PremiumUI {
  static BoxDecoration cardDecoration(BuildContext context) {
    bool isDark = Theme.of(context).brightness == Brightness.dark;
    return BoxDecoration(
      color: Theme.of(context).cardColor,
      borderRadius: BorderRadius.circular(24),
      boxShadow: isDark
          ? []
          : [
        BoxShadow(
          color: Colors.black.withOpacity(0.02),
          blurRadius: 10,
          offset: const Offset(0, 4),
        ),
        BoxShadow(
          color: Colors.black.withOpacity(0.02),
          blurRadius: 24,
          offset: const Offset(0, 8),
        ),
      ],
      border: Border.all(
        color: isDark
            ? Colors.white.withOpacity(0.05)
            : Colors.black.withOpacity(0.03),
      ),
    );
  }

  static Widget buildGradientButton(
      BuildContext context,
      String text,
      VoidCallback onPressed, {
        IconData? icon,
      }) {
    return Container(
      width: double.infinity,
      height: 60,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Theme.of(context).primaryColor,
            Theme.of(context).primaryColor.withOpacity(0.8),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Theme.of(context).primaryColor.withOpacity(0.3),
            blurRadius: 12,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent,
          shadowColor: Colors.transparent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
        onPressed: onPressed,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              text,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.white,
                letterSpacing: 0.5,
              ),
            ),
            if (icon != null) ...[
              const SizedBox(width: 8),
              Icon(icon, color: Colors.white, size: 20),
            ],
          ],
        ),
      ),
    );
  }

  static InputDecoration inputDecoration(
      BuildContext context,
      String label, {
        IconData? icon,
      }) {
    bool isDark = Theme.of(context).brightness == Brightness.dark;
    return InputDecoration(
      labelText: label,
      labelStyle: TextStyle(
        color: isDark ? Colors.grey.shade400 : Colors.grey.shade600,
        fontSize: 13,
        fontWeight: FontWeight.w500,
      ),
      filled: true,
      fillColor: isDark ? const Color(0xFF0F172A) : const Color(0xFFF1F5F9),
      prefixIcon: icon != null
          ? Icon(icon, color: Theme.of(context).primaryColor, size: 20)
          : null,
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: BorderSide.none,
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: BorderSide(color: Theme.of(context).primaryColor, width: 2),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: const BorderSide(color: Colors.redAccent, width: 1),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: const BorderSide(color: Colors.redAccent, width: 2),
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
    );
  }

  static Widget buildTextField(
      BuildContext context,
      String label, {
        TextInputType? type,
        List<TextInputFormatter>? formatters,
        String? Function(String?)? validator,
        TextEditingController? controller,
        bool readOnly = false,
        bool obscureText = false,
        Widget? suffixIcon,
        IconData? icon,
      }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: TextFormField(
        controller: controller,
        readOnly: readOnly,
        obscureText: obscureText,
        keyboardType: type,
        inputFormatters: formatters,
        validator: validator,
        decoration: inputDecoration(
          context,
          label,
          icon: icon,
        ).copyWith(suffixIcon: suffixIcon),
      ),
    );
  }

  static Widget buildDropdown(
      BuildContext context,
      String label,
      List<String> items, {
        String? value,
        Function(String?)? onChanged,
        String? Function(String?)? validator,
        IconData? icon,
      }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: DropdownButtonFormField<String>(
        value: value,
        decoration: inputDecoration(context, label, icon: icon),
        icon: const Icon(Icons.keyboard_arrow_down_rounded),
        items: items
            .map(
              (e) => DropdownMenuItem(
            value: e,
            child: Text(e, style: const TextStyle(fontSize: 14)),
          ),
        )
            .toList(),
        onChanged: onChanged ?? (v) {},
        validator: validator,
      ),
    );
  }

  static Widget buildModernToggle(
      BuildContext context,
      String label,
      List<String> options,
      String selectedValue,
      Function(String) onChanged,
      ) {
    bool isDark = Theme.of(context).brightness == Brightness.dark;
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (label.isNotEmpty)
            Padding(
              padding: const EdgeInsets.only(bottom: 10, left: 4),
              child: Text(
                label,
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 13,
                  color: isDark ? Colors.grey.shade300 : Colors.grey.shade800,
                ),
              ),
            ),
          Container(
            padding: const EdgeInsets.all(4),
            decoration: BoxDecoration(
              color: isDark ? const Color(0xFF0F172A) : const Color(0xFFF1F5F9),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: isDark ? Colors.grey.shade800 : Colors.transparent,
              ),
            ),
            child: Row(
              children: options.map((option) {
                bool isSel = selectedValue == option;
                return Expanded(
                  child: GestureDetector(
                    onTap: () => onChanged(option),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      curve: Curves.easeInOut,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      decoration: BoxDecoration(
                        color: isSel
                            ? Theme.of(context).primaryColor
                            : Colors.transparent,
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: isSel
                            ? [
                          BoxShadow(
                            color: Theme.of(
                              context,
                            ).primaryColor.withOpacity(0.3),
                            blurRadius: 8,
                            offset: const Offset(0, 2),
                          ),
                        ]
                            : [],
                      ),
                      alignment: Alignment.center,
                      child: Text(
                        option,
                        style: TextStyle(
                          color: isSel
                              ? Colors.white
                              : (isDark
                              ? Colors.grey.shade400
                              : Colors.grey.shade600),
                          fontWeight: FontWeight.bold,
                          fontSize: 13,
                          letterSpacing: 0.5,
                        ),
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }

  static Widget buildDashedAddButton(
      BuildContext context,
      String title,
      VoidCallback onTap,
      ) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 20),
        decoration: BoxDecoration(
          color: Theme.of(context).primaryColor.withOpacity(0.05),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: Theme.of(context).primaryColor.withOpacity(0.2),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.add,
                size: 18,
                color: Theme.of(context).primaryColor,
              ),
            ),
            const SizedBox(width: 12),
            Text(
              title,
              style: TextStyle(
                color: Theme.of(context).primaryColor,
                fontWeight: FontWeight.bold,
                letterSpacing: 0.5,
              ),
            ),
          ],
        ),
      ),
    );
  }

  static Widget buildSectionHeader(
      BuildContext context,
      String title, {
        IconData? icon,
        String? subtitle,
      }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 24, top: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              if (icon != null) ...[
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Theme.of(context).primaryColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(
                    icon,
                    color: Theme.of(context).primaryColor,
                    size: 20,
                  ),
                ),
                const SizedBox(width: 12),
              ],
              Expanded(
                child: Text(
                  title,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w800,
                    color: Theme.of(context).colorScheme.secondary,
                    letterSpacing: -0.5,
                  ),
                ),
              ),
            ],
          ),
          if (subtitle != null)
            Padding(
              padding: const EdgeInsets.only(top: 6),
              child: Text(
                subtitle,
                style: const TextStyle(fontSize: 12, color: Colors.grey),
              ),
            ),
        ],
      ),
    );
  }
}

// ==========================================
// 3. ULTRA-PREMIUM SPLASH SCREEN (UPDATED)
// ==========================================
class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _pulseController;
  late Animation<double> _pulseAnimation;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);
    _pulseAnimation = Tween<double>(begin: 1.0, end: 1.08).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );

    Future.delayed(const Duration(seconds: 3), () async {
      final loggedIn = await ApiService.isLoggedIn();
      if (!mounted) return;
      if (loggedIn) {
        final user = await ApiService.getCachedUser();
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (_) =>
                DashboardScreen(userName: user?['college_id'] ?? 'User'),
          ),
        );
      } else {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const LoginScreen()),
        );
      }
    });
  }

  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF0F1115), Color(0xFF1E2228)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Spacer(),
            FadeInDown(
              duration: const Duration(milliseconds: 1200),
              child: ScaleTransition(
                scale: _pulseAnimation,
                child: Container(
                  padding: const EdgeInsets.all(25),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFFF5A623).withOpacity(0.2),
                        blurRadius: 50,
                        spreadRadius: 20,
                      ),
                      BoxShadow(
                        color: Colors.white.withOpacity(0.1),
                        blurRadius: 20,
                        spreadRadius: -5,
                      ),
                    ],
                  ),
                  child: Image.asset(
                    'assets/UBA_Logo.png',
                    height: 120,
                    width: 120,
                    errorBuilder: (c, e, s) => const Icon(
                      Icons.account_balance,
                      size: 80,
                      color: Color(0xFFF5A623),
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 60),
            FadeInUp(
              duration: const Duration(milliseconds: 1000),
              child: Text(
                'UNNAT BHARAT\nABHIYAN',
                textAlign: TextAlign.center,
                style: GoogleFonts.montserrat(
                  fontSize: 34,
                  fontWeight: FontWeight.w900,
                  color: Colors.white,
                  height: 1.1,
                  letterSpacing: 3,
                ),
              ),
            ),
            const SizedBox(height: 20),
            FadeInUp(
              delay: const Duration(milliseconds: 500),
              duration: const Duration(milliseconds: 1000),
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.05),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: Colors.white.withOpacity(0.1)),
                ),
                child: Text(
                  'Digital Survey Platform',
                  style: GoogleFonts.poppins(
                    color: const Color(0xFFF5A623),
                    fontSize: 14,
                    letterSpacing: 2,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ),
            const Spacer(),
          ],
        ),
      ),
    );
  }
}

// ==========================================
// 4. LOGIN SCREEN (WITH SIT/SEC LOGIC + API)
// ==========================================
class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _collegeIdController = TextEditingController();
  final _passwordController = TextEditingController();
  final _mobileController = TextEditingController();
  final _mentorController = TextEditingController();
  final _deptController = TextEditingController();
  String? _selectedYear;
  String? _selectedSection;
  bool _isLoading = false;
  bool _obscurePassword = true;

  Future<void> _handleLogin() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _isLoading = true);
    try {
      final result = await ApiService.login(
        collegeId: _collegeIdController.text.trim(),
        password: _passwordController.text,
        mobile: _mobileController.text.trim(),
        department: _deptController.text.trim(),
        year: _selectedYear,
        section: _selectedSection,
        mentor: _mentorController.text.trim(),
      );
      if (!mounted) return;
      if (result['success'] == true) {
        Navigator.pushReplacement(
          context,
          PageRouteBuilder(
            pageBuilder: (_, __, ___) =>
                DashboardScreen(userName: _nameController.text.trim()),
            transitionsBuilder: (_, a, __, c) =>
                FadeTransition(opacity: a, child: c),
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              result['message'] ??
                  'Login failed. Please check your credentials.',
            ),
            backgroundColor: Colors.redAccent,
          ),
        );
      }
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Connection error: ${e.toString()}'),
          backgroundColor: Colors.redAccent,
        ),
      );
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _collegeIdController.dispose();
    _passwordController.dispose();
    _mobileController.dispose();
    _mentorController.dispose();
    _deptController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: FadeInUp(
            child: Container(
              padding: const EdgeInsets.all(32),
              decoration: PremiumUI.cardDecoration(context),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                      child: Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Theme.of(
                            context,
                          ).primaryColor.withOpacity(0.1),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          Icons.fingerprint,
                          size: 40,
                          color: Theme.of(context).primaryColor,
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),
                    Center(
                      child: Text(
                        'Welcome Back',
                        style: TextStyle(
                          fontSize: 26,
                          fontWeight: FontWeight.w800,
                          color: Theme.of(context).colorScheme.secondary,
                          letterSpacing: -0.5,
                        ),
                      ),
                    ),
                    const Center(
                      child: Text(
                        'Sign in to UBA Survey System',
                        style: TextStyle(fontSize: 14, color: Colors.grey),
                      ),
                    ),
                    const SizedBox(height: 32),

                    PremiumUI.buildTextField(
                      context,
                      'Schedule Filed By',
                      controller: _nameController,
                      icon: Icons.person_outline,
                      validator: (v) =>
                      v == null || v.isEmpty ? 'Required' : null,
                    ),

                    // COLLEGE ID VALIDATION (SIT OR SEC)
                    PremiumUI.buildTextField(
                      context,
                      'College ID (SIT/SEC)',
                      controller: _collegeIdController,
                      icon: Icons.badge_outlined,
                      validator: (val) {
                        if (val == null || val.isEmpty) return 'Required';
                        if (!val.toUpperCase().startsWith('SIT') &&
                            !val.toUpperCase().startsWith('SEC')) {
                          return 'Must start with SIT or SEC';
                        }
                        return null;
                      },
                    ),

                    // PASSWORD with visibility toggle
                    PremiumUI.buildTextField(
                      context,
                      'Password',
                      controller: _passwordController,
                      icon: Icons.lock_outline,
                      obscureText: _obscurePassword,
                      suffixIcon: IconButton(
                        icon: Icon(
                          _obscurePassword
                              ? Icons.visibility_off_outlined
                              : Icons.visibility_outlined,
                          color: Colors.grey,
                        ),
                        onPressed: () => setState(
                              () => _obscurePassword = !_obscurePassword,
                        ),
                      ),
                      validator: (val) =>
                      (val == null || val.isEmpty) ? 'Required' : null,
                    ),

                    PremiumUI.buildTextField(
                      context,
                      'Mentor',
                      controller: _mentorController,
                      icon: Icons.supervisor_account_outlined,
                    ),

                    // MOBILE VALIDATION
                    PremiumUI.buildTextField(
                      context,
                      'Mobile Number',
                      controller: _mobileController,
                      type: TextInputType.phone,
                      formatters: [
                        FilteringTextInputFormatter.digitsOnly,
                        LengthLimitingTextInputFormatter(10),
                      ],
                      icon: Icons.phone_outlined,
                      validator: (val) => (val != null && val.length == 10)
                          ? null
                          : 'Enter a valid 10-digit number',
                    ),

                    PremiumUI.buildTextField(
                      context,
                      'Department',
                      controller: _deptController,
                      icon: Icons.domain,
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: PremiumUI.buildDropdown(
                            context,
                            'Year',
                            ['I', 'II', 'III', 'IV'],
                            value: _selectedYear,
                            onChanged: (v) => setState(() => _selectedYear = v),
                            icon: Icons.school,
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: PremiumUI.buildDropdown(
                            context,
                            'Section',
                            ['A', 'B', 'C', 'D', 'E', 'F', 'G', 'H'],
                            value: _selectedSection,
                            onChanged: (v) =>
                                setState(() => _selectedSection = v),
                            icon: Icons.class_outlined,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    _isLoading
                        ? const Center(child: CircularProgressIndicator())
                        : PremiumUI.buildGradientButton(
                      context,
                      'Secure Login',
                      _handleLogin,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// ==========================================
// 5. DASHBOARD SCREEN
// ==========================================
class DashboardScreen extends StatelessWidget {
  final String userName;
  const DashboardScreen({Key? key, required this.userName}) : super(key: key);

  void _logout(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Text(
          'Secure Logout',
          style: TextStyle(
            color: Theme.of(context).colorScheme.secondary,
            fontWeight: FontWeight.bold,
          ),
        ),
        content: const Text(
          'Are you sure you want to log out of the UBA session?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'Cancel',
              style: TextStyle(color: Theme.of(context).colorScheme.secondary),
            ),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.redAccent,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            onPressed: () async {
              Navigator.pop(context);
              await ApiService.logout();
              if (context.mounted)
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (_) => const LoginScreen()),
                );
            },
            child: const Text(
              'Logout',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          IconButton(
            icon: Icon(
              Theme.of(context).brightness == Brightness.dark
                  ? Icons.light_mode
                  : Icons.dark_mode,
              color: Theme.of(context).colorScheme.secondary,
            ),
            onPressed: () => UBASurveyApp.of(context).toggleTheme(),
          ),
          IconButton(
            icon: const Icon(Icons.logout_rounded, color: Colors.redAccent),
            onPressed: () => _logout(context),
          ),
        ],
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              FadeInDown(
                child: Container(
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: Theme.of(context).primaryColor.withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.rocket_launch_rounded,
                    size: 60,
                    color: Theme.of(context).primaryColor,
                  ),
                ),
              ),
              const SizedBox(height: 32),
              FadeInUp(
                child: Text(
                  'Hello, $userName',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.w800,
                    color: Theme.of(context).colorScheme.secondary,
                    letterSpacing: -1,
                  ),
                ),
              ),
              const SizedBox(height: 8),
              FadeInUp(
                delay: const Duration(milliseconds: 100),
                child: const Text(
                  'Your workspace is ready. Start collecting data.',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.grey, fontSize: 15),
                ),
              ),
              const SizedBox(height: 48),
              FadeInUp(
                delay: const Duration(milliseconds: 200),
                child: PremiumUI.buildGradientButton(
                  context,
                  'Initialize Survey',
                      () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => SurveyMasterPage(userName: userName),
                    ),
                  ),
                  icon: Icons.arrow_forward_rounded,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ==========================================
// 6. SURVEY MASTER PAGE (10-STEP TRACKER)
// ==========================================
class SurveyMasterPage extends StatefulWidget {
  final String userName;
  const SurveyMasterPage({Key? key, required this.userName}) : super(key: key);
  @override
  _SurveyMasterPageState createState() => _SurveyMasterPageState();
}

class _SurveyMasterPageState extends State<SurveyMasterPage> {
  final PageController _pageController = PageController();
  int _currentPage = 0;
  final List<String> _titles = [
    'Village Details',
    'Respondent Info',
    'Household Data',
    'Family Demographics',
    'Water & Sanitation',
    'Energy Sources',
    'Agriculture',
    'Livestock',
    'State Schemes',
    'Central Schemes',
  ];
  final List<GlobalKey<FormState>> _formKeys = List.generate(
    10,
        (index) => GlobalKey<FormState>(),
  );

  bool _isSubmitting = false;

  Future<void> _nextPage() async {
    if (_formKeys[_currentPage].currentState == null ||
        _formKeys[_currentPage].currentState!.validate()) {
      if (_currentPage < 9) {
        _pageController.nextPage(
          duration: const Duration(milliseconds: 600),
          curve: Curves.fastOutSlowIn,
        );
      } else {
        setState(() => _isSubmitting = true);
        try {
          final user = await ApiService.getCachedUser();
          final payload = SurveyStore.instance.buildPayload(
            scheduleFiledBy: widget.userName,
            collegeId: user?['college_id'] ?? '',
          );
          final result = await ApiService.submitSurvey(payload);
          if (!mounted) return;
          if (result['success'] == true) {
            Navigator.pushReplacement(
              context,
              PageRouteBuilder(
                pageBuilder: (_, __, ___) =>
                    SuccessScreen(userName: widget.userName),
                transitionDuration: const Duration(milliseconds: 600),
                transitionsBuilder: (_, a, __, c) =>
                    FadeTransition(opacity: a, child: c),
              ),
            );
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  result['message'] ?? 'Submission failed. Please retry.',
                ),
                backgroundColor: Colors.redAccent,
              ),
            );
          }
        } catch (e) {
          if (!mounted) return;
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Network error: ${e.toString()}'),
              backgroundColor: Colors.redAccent,
            ),
          );
        } finally {
          if (mounted) setState(() => _isSubmitting = false);
        }
      }
    }
  }

  void _prevPage() {
    if (_currentPage > 0)
      _pageController.previousPage(
        duration: const Duration(milliseconds: 600),
        curve: Curves.fastOutSlowIn,
      );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        elevation: 0,
        titleSpacing: 0,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios_new_rounded,
            size: 20,
            color: Theme.of(context).colorScheme.secondary,
          ),
          onPressed: () => Navigator.pop(context),
        ),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Step ${_currentPage + 1} of 10',
              style: TextStyle(
                fontSize: 12,
                color: Theme.of(context).primaryColor,
                fontWeight: FontWeight.bold,
                letterSpacing: 1,
              ),
            ),
            Text(
              _titles[_currentPage],
              style: TextStyle(
                color: Theme.of(context).colorScheme.secondary,
                fontWeight: FontWeight.w800,
                fontSize: 18,
                letterSpacing: -0.5,
              ),
            ),
          ],
        ),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(24),
          child: Padding(
            padding: const EdgeInsets.only(left: 24, right: 24, bottom: 12),
            child: Row(
              children: List.generate(
                10,
                    (index) => Expanded(
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 400),
                    curve: Curves.easeInOut,
                    margin: const EdgeInsets.symmetric(horizontal: 2),
                    height: 5,
                    decoration: BoxDecoration(
                      color: index <= _currentPage
                          ? Theme.of(context).primaryColor
                          : (Theme.of(context).brightness == Brightness.dark
                          ? Colors.grey.shade800
                          : Colors.grey.shade300),
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
      body: PageView(
        controller: _pageController,
        physics: const BouncingScrollPhysics(),
        onPageChanged: (idx) => setState(() => _currentPage = idx),
        children: [
          KeepAlivePage(
            child: Form(key: _formKeys[0], child: const Page1VillageInfo()),
          ),
          KeepAlivePage(
            child: Form(key: _formKeys[1], child: const Page2RespondentInfo()),
          ),
          KeepAlivePage(
            child: Form(key: _formKeys[2], child: const Page3HouseholdInfo()),
          ),
          KeepAlivePage(
            child: Form(key: _formKeys[3], child: const Page4FamilyMembers()),
          ),
          KeepAlivePage(
            child: Form(key: _formKeys[4], child: const Page5WaterSanitation()),
          ),
          KeepAlivePage(
            child: Form(key: _formKeys[5], child: const Page6Energy()),
          ),
          KeepAlivePage(
            child: Form(key: _formKeys[6], child: const Page7Agri()),
          ),
          KeepAlivePage(
            child: Form(key: _formKeys[7], child: const Page8Livestock()),
          ),
          KeepAlivePage(
            child: Form(key: _formKeys[8], child: const Page9StateSchemes()),
          ),
          KeepAlivePage(
            child: Form(key: _formKeys[9], child: const Page10CentralSchemes()),
          ),
        ],
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.fromLTRB(24, 16, 24, 32),
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(32)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.04),
              blurRadius: 24,
              offset: const Offset(0, -8),
            ),
          ],
        ),
        child: SafeArea(
          child: Row(
            children: [
              if (_currentPage > 0)
                Expanded(
                  child: OutlinedButton(
                    onPressed: _prevPage,
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 20),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      side: BorderSide(
                        color: Theme.of(
                          context,
                        ).colorScheme.secondary.withOpacity(0.1),
                      ),
                    ),
                    child: Text(
                      'Back',
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.secondary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              if (_currentPage > 0) const SizedBox(width: 16),
              Expanded(
                flex: 2,
                child: _isSubmitting
                    ? const Center(
                  child: Padding(
                    padding: EdgeInsets.all(8),
                    child: CircularProgressIndicator(),
                  ),
                )
                    : PremiumUI.buildGradientButton(
                  context,
                  _currentPage == 9 ? 'Finalize & Submit' : 'Continue',
                  _nextPage,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ==========================================
// 7. PREMIUM DATA SYNC SCREEN (OVERFLOW FIXED)
// ==========================================
class SuccessScreen extends StatefulWidget {
  final String userName;
  const SuccessScreen({Key? key, required this.userName}) : super(key: key);

  @override
  State<SuccessScreen> createState() => _SuccessScreenState();
}

class _SuccessScreenState extends State<SuccessScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _spinController;

  @override
  void initState() {
    super.initState();
    _spinController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 4),
    )..forward();

    // Auto-redirect to dashboard after 4.5 seconds
    Future.delayed(const Duration(milliseconds: 4500), () {
      if (mounted) {
        Navigator.pushAndRemoveUntil(
          context,
          PageRouteBuilder(
            pageBuilder: (_, __, ___) =>
                DashboardScreen(userName: widget.userName),
            transitionDuration: const Duration(milliseconds: 800),
            transitionsBuilder: (_, anim, __, child) =>
                FadeTransition(opacity: anim, child: child),
          ),
              (route) => false,
        );
      }
    });
  }

  @override
  void dispose() {
    _spinController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    bool isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark
          ? const Color(0xFF0F172A)
          : const Color(0xFF1E293B), // Always dark premium slate background
      body: Center(
        // Wrap with SingleChildScrollView to prevent widget overflow on smaller devices
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 32.0, vertical: 24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Data Sync Animation Graphic
              SizedBox(
                height: 180,
                width: 180,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    // Outer spinning dashed ring
                    RotationTransition(
                      turns: Tween(
                        begin: 0.0,
                        end: 1.0,
                      ).animate(_spinController),
                      child: Container(
                        height: 160,
                        width: 160,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: Theme.of(
                              context,
                            ).primaryColor.withOpacity(0.3),
                            width: 2,
                            style: BorderStyle.none,
                          ),
                        ),
                        child: CustomPaint(
                          painter: DashedRingPainter(
                            color: Theme.of(context).primaryColor,
                          ),
                        ),
                      ),
                    ),
                    // Inner glowing circle
                    ZoomIn(
                      duration: const Duration(milliseconds: 800),
                      child: Container(
                        height: 100,
                        width: 100,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          gradient: LinearGradient(
                            colors: [
                              Theme.of(context).primaryColor,
                              Theme.of(context).primaryColor.withOpacity(0.6),
                            ],
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Theme.of(
                                context,
                              ).primaryColor.withOpacity(0.4),
                              blurRadius: 30,
                              spreadRadius: 10,
                            ),
                          ],
                        ),
                        child: const Icon(
                          Icons.cloud_sync_rounded,
                          color: Colors.white,
                          size: 48,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 48),

              FadeInUp(
                delay: const Duration(milliseconds: 600),
                child: const Text(
                  'Data Encrypted & Synchronized',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w800,
                    color: Colors.white,
                    letterSpacing: -0.5,
                  ),
                ),
              ),
              const SizedBox(height: 16),

              FadeInUp(
                delay: const Duration(milliseconds: 900),
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 12,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.05),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: Colors.white.withOpacity(0.1)),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.verified_user_rounded,
                        color: Theme.of(context).primaryColor,
                        size: 18,
                      ),
                      const SizedBox(width: 12),
                      const Flexible(
                        child: Text(
                          '10 Modules securely uploaded to UBA Server',
                          style: TextStyle(
                            color: Colors.white70,
                            fontSize: 13,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 60),
              FadeIn(
                delay: const Duration(milliseconds: 1500),
                child: Column(
                  children: [
                    SizedBox(
                      width: 150,
                      child: LinearProgressIndicator(
                        backgroundColor: Colors.white.withOpacity(0.1),
                        color: Theme.of(context).primaryColor,
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      'Initializing Workspace...',
                      style: TextStyle(
                        color: Colors.white54,
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        letterSpacing: 1,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// Custom Painter for the Sync Ring in the Success Screen
class DashedRingPainter extends CustomPainter {
  final Color color;
  DashedRingPainter({required this.color});
  @override
  void paint(Canvas canvas, Size size) {
    double dashWidth = 8, dashSpace = 8, startAngle = 0;
    final paint = Paint()
      ..color = color
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;
    final rect = Rect.fromLTWH(0, 0, size.width, size.height);
    while (startAngle < 360) {
      canvas.drawArc(
        rect,
        startAngle * 3.14159 / 180,
        dashWidth * 3.14159 / 180,
        false,
        paint,
      );
      startAngle += dashWidth + dashSpace;
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

// ==========================================
// FULL PAGES DATA (1 to 10)
// ==========================================

// ==========================================
// SURVEY DATA STORE (singleton — collects all form values across pages 1-5)
// ==========================================
class SurveyStore {
  static final SurveyStore instance = SurveyStore._();
  SurveyStore._();

  // ── Page 1: Village ──────────────────────────────────────
  final locCtrl = TextEditingController();
  final doorNoCtrl = TextEditingController();
  final stateCtrl = TextEditingController(text: 'Tamil Nadu');
  final blockNameCtrl = TextEditingController(text: 'Kundrathur');
  final blockCodeCtrl = TextEditingController(text: '6484');
  String? villageSelected;
  final villageCodeCtrl = TextEditingController();
  final gpNameCtrl = TextEditingController();
  final gpCodeCtrl = TextEditingController();
  String? wardSelected;

  // ── Page 2: Respondent ───────────────────────────────────
  final aadharCtrl = TextEditingController();
  final respNameCtrl = TextEditingController();
  final relationCtrl = TextEditingController();
  final addressCtrl = TextEditingController();
  final pincodeCtrl = TextEditingController();
  final respMobileCtrl = TextEditingController();

  // ── Page 3: Household ────────────────────────────────────
  final headNameCtrl = TextEditingController();
  final famCountCtrl = TextEditingController();
  final maleCtrl = TextEditingController();
  final femaleCtrl = TextEditingController();
  final otherCtrl = TextEditingController();
  String? categorySelected;
  String hasRationCard = 'Yes';
  String cardType = 'PHH';
  final rationCardNoCtrl = TextEditingController();
  String socialStatus = 'APL';
  String? aplCategory;
  String livingIn = 'Own House';
  final rentalFromCtrl = TextEditingController();
  String houseType = 'Kutcha';
  final annualIncomeCtrl = TextEditingController();

  // ── Page 3: Migration ─────────────────────────────────────
  String anyMigrates = 'No';
  final migrantCountCtrl = TextEditingController();
  final migrationYearsCtrl = TextEditingController();
  final migrationFreqCtrl = TextEditingController();
  String familyMigratedOut = 'No';
  final migratedFromCtrl = TextEditingController();

  // ── Page 4: Family Members ────────────────────────────────
  List<Map<String, dynamic>> members = [_newMember()];
  static Map<String, dynamic> _newMember() => {
    'shg': 'Yes',
    'dis': 'No',
    'nameCtrl': TextEditingController(),
    'ageCtrl': TextEditingController(),
    'genderSel': null as String?,
    'maritalSel': null as String?,
    'eduSel': null as String?,
    'aadharCtrl': TextEditingController(),
    'rationSel': null as String?,
    'bankSel': null as String?,
    'mobileCtrl': TextEditingController(),
    'employmentSel': null as String?,
    'skillInterest': 'No',
    'skillTypeCtrl': TextEditingController(),
    'shgNameCtrl': TextEditingController(),
    'shgActivityCtrl': TextEditingController(),
    'disabilityCtrl': TextEditingController(),
    'disabilityIdSel': null as String?,
    'healthSel': null as String?,
  };
  void addMember() => members.add(_newMember());
  void removeMember(int i) {
    if (i > 0) members.removeAt(i);
  }

  // ── Page 5: Water ─────────────────────────────────────────
  String hasPipedWater = 'YES';
  String hasCommunityTap = 'YES';
  String waterSuppliedBy = 'Government';
  String hasHandPump = 'YES';
  String hasOpenWell = 'YES';
  String waterStorageMode = 'Community';

  // ── Page 5: Sanitation ────────────────────────────────────
  String wasteSegregated = 'YES';
  String? wasteCollection;
  String? toiletType;
  String? drainageType;
  String? wasteFreq;
  String? compostPit;
  String? biogasPlant;
  String hasSanitation = 'YES';
  String usesSanitation = 'YES';
  final reasonNotUsingCtrl = TextEditingController();
  final whyNoSanitationCtrl = TextEditingController();
  String? blackWaterDischarge;
  String? systemType;
  final dimensionCtrl = TextEditingController();
  final materialCtrl = TextEditingController();
  final cleaningPeriodCtrl = TextEditingController();
  final systemCostCtrl = TextEditingController();
  String? greyWaterDischarge;

  // ── Page 9 & 10: Scheme awareness ratings ──────────────────────────
  // Stored as 0–5 star ratings for each scheme.
  final List<String> stateSchemes = [
    'கலைஞர் மகளிர் உரிமை தொகை திட்டம்',
    'காலை உணவு திட்டம்',
    'நம்ம ஸ்கூல் திட்டம்',
    'மக்களைத் தேடி மருத்துவம்',
    'அனைத்து கிராம அண்ணா மறுமலர்ச்சி திட்டம்',
    'எண்ணும் எழுத்தும் திட்டம்',
    'மதி சிறகுகள் திட்டம்',
    'சிற்பி திட்டம்',
    'டாக்டர் முத்துலட்சுமி ரெட்டி மகப்பேறு நிதி உதவித் திட்டம்',
    'மகாத்மா காந்தி தேசிய ஊரக வேலை உறுதி திட்டம்',
    'சுய உதவிக் குழு திட்டம்',
    'நான் முதல்வன் திட்டம்',
    'இல்லம் தேடிக் கல்வி திட்டம்',
    '48 மணி நேரம் நம்மை காக்கும் இன்னுயிர் காப்போம் திட்டம்',
    'விடியல் திட்டம்',
    'வாழ்ந்து காட்டுவோம் திட்டம்',
    'நமக்கு நாமே திட்டம்',
    'வானவில் மன்றம் திட்டம்',
    'கலைஞர் அனைத்து கிராம ஒருங்கிணைந்த வளர்ச்சி திட்டம்',
    'தோழி திட்டம்',
  ];

  final List<String> centralSchemes = [
    'National Mission for Financial Inclusion',
    'Child Benefit: Selva Magal / Pon Magan',
    'Mudra: Fund the Unfunded',
    'Jeevan Jyoti: Term Life Insurance',
    'Suraksha: Accidental Insurance',
    'Old Age Pension',
    'PMKVY',
    'Janani Suraksha: Safe Motherhood',
    'Atal Mission for Rejuvenation and Urban Transformation',
    'Affordable Housing',
    'Crop Insurance Policy',
    'Per Drop More Crop',
    'Soil Health Card',
  ];

  final Map<String, int> stateSchemeRatings = {};
  final Map<String, int> centralSchemeRatings = {};

  // ── Build API payload ─────────────────────────────────────
  Map<String, dynamic> buildPayload({
    required String scheduleFiledBy,
    required String collegeId,
  }) {
    return {
      'college_id': collegeId,
      'schedule_filed_by': scheduleFiledBy,
      'location': {
        'location_gps': locCtrl.text,
        'door_no': doorNoCtrl.text,
        'state': stateCtrl.text,
        'block_name': blockNameCtrl.text,
        'block_code': blockCodeCtrl.text,
        'village_name': villageSelected,
        'village_code': villageCodeCtrl.text,
        'gram_panchayat_name': gpNameCtrl.text,
        'gram_panchayat_code': gpCodeCtrl.text,
        'ward_no': wardSelected,
      },
      'respondent': {
        'aadhar_number': aadharCtrl.text,
        'name': respNameCtrl.text,
        'relationship_with_head': relationCtrl.text,
        'address': addressCtrl.text,
        'pincode': pincodeCtrl.text,
        'mobile': respMobileCtrl.text,
      },
      'household': {
        'head_name': headNameCtrl.text,
        'family_members_count': famCountCtrl.text,
        'male_count': maleCtrl.text,
        'female_count': femaleCtrl.text,
        'other_count': otherCtrl.text,
        'category': categorySelected,
        'has_ration_card': hasRationCard,
        'card_type': cardType,
        'ration_card_no': rationCardNoCtrl.text,
        'social_status': socialStatus,
        'apl_category': aplCategory,
        'living_in': livingIn,
        'house_type': houseType,
        'annual_income': annualIncomeCtrl.text,
      },
      'migration': {
        'any_member_migrates': anyMigrates,
        'migrant_count': migrantCountCtrl.text,
        'migration_years': migrationYearsCtrl.text,
        'migration_frequency': migrationFreqCtrl.text,
        'family_migrated_from_outside': familyMigratedOut,
        'migrated_from': migratedFromCtrl.text,
      },
      'family_members': members
          .map(
            (mc) => {
          'name': (mc['nameCtrl'] as TextEditingController).text,
          'age': (mc['ageCtrl'] as TextEditingController).text,
          'gender': mc['genderSel'],
          'marital_status': mc['maritalSel'],
          'education_level': mc['eduSel'],
          'has_aadhar':
          (mc['aadharCtrl'] as TextEditingController).text.isNotEmpty,
          'aadhar_number': (mc['aadharCtrl'] as TextEditingController).text,
          'has_ration_card': mc['rationSel'],
          'has_bank_account': mc['bankSel'],
          'has_mobile':
          (mc['mobileCtrl'] as TextEditingController).text.isNotEmpty,
          'employment_status': mc['employmentSel'],
          'skill_training_interest':
          (mc['employmentSel'] == 'Unemployed' &&
              mc['skillInterest'] == 'Yes'),
          'skill_type': (mc['skillTypeCtrl'] as TextEditingController).text,
          'is_shg_member': mc['shg'],
          'shg_name': (mc['shgNameCtrl'] as TextEditingController).text,
          'shg_activity':
          (mc['shgActivityCtrl'] as TextEditingController).text,
          'is_physically_challenged': mc['dis'],
          'disability_nature':
          (mc['disabilityCtrl'] as TextEditingController).text,
          'has_disability_id_card': mc['disabilityIdSel'],
          'health_insurance': mc['healthSel'],
        },
      )
          .toList(),
      'water': {
        'has_piped_water': hasPipedWater,
        'has_community_tap': hasCommunityTap,
        'water_supplied_by': waterSuppliedBy,
        'has_hand_pump': hasHandPump,
        'has_open_well': hasOpenWell,
        'water_storage_mode': waterStorageMode,
      },
      'sanitation': {
        'water_source_segregated': wasteSegregated,
        'waste_collection': wasteCollection,
        'toilet_type': toiletType,
        'drainage_type': drainageType,
        'waste_collection_frequency': wasteFreq,
        'compost_pit': compostPit,
        'biogas_plant': biogasPlant,
        'has_sanitation_system': hasSanitation,
        'uses_sanitation_system': usesSanitation,
        'reason_not_using': hasSanitation == 'NO'
            ? whyNoSanitationCtrl.text
            : (usesSanitation == 'NO' ? reasonNotUsingCtrl.text : null),
        'black_water_discharge': blackWaterDischarge,
        'system_type': systemType,
        'system_dimensions': dimensionCtrl.text,
        'material_used': materialCtrl.text,
        'cleaning_period': cleaningPeriodCtrl.text,
        'system_cost': systemCostCtrl.text,
        'grey_water_discharge': greyWaterDischarge,
      },
      'state_schemes': _buildSchemePayload(stateSchemes, stateSchemeRatings),
      'central_schemes': _buildSchemePayload(
        centralSchemes,
        centralSchemeRatings,
      ),
    };
  }

  List<Map<String, dynamic>> _buildSchemePayload(
      List<String> schemes,
      Map<String, int> ratings,
      ) {
    return schemes
        .map((name) => {'name': name, 'awareness_rating': ratings[name] ?? 0})
        .toList();
  }
}

// --- PAGE 1: VILLAGE INFO ---
class Page1VillageInfo extends StatefulWidget {
  const Page1VillageInfo({Key? key}) : super(key: key);
  @override
  _Page1VillageInfoState createState() => _Page1VillageInfoState();
}

class _Page1VillageInfoState extends State<Page1VillageInfo> {
  bool _isLoading = false;
  final Map<String, String> _villageData = {
    'Amarambedu': '224074',
    'Erumaiyur': '224076',
    'Naduveerapattu': '224093',
    'Nandambakkam': '224094',
    'Pazhandhandalam': '224099',
    'Poonthandalam': '224101',
    'Sethupattu': '224105',
    'Somangalam': '224108',
    'Thirumudivakkam': '224111',
    'Varadharajapuram': '224115',
  };

  // Get only the keys for the dropdown list
  List<String> get _vills => _villageData.keys.toList();
  Future<void> _fetchGPS() async {
    setState(() => _isLoading = true);
    try {
      Position p = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );
      setState(() {
        SurveyStore.instance.locCtrl.text =
        '${p.latitude.toStringAsFixed(6)}, ${p.longitude.toStringAsFixed(6)}';
        _isLoading = false;
      });
    } catch (e) {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(24),
      children: [
        Container(
          padding: const EdgeInsets.all(24),
          decoration: PremiumUI.cardDecoration(context),
          child: Column(
            children: [
              PremiumUI.buildTextField(
                context,
                'Location Coordinate',
                controller: SurveyStore.instance.locCtrl,
                readOnly: true,
                icon: Icons.map_outlined,
                suffixIcon: GestureDetector(
                  onTap: _isLoading ? null : _fetchGPS,
                  child: Container(
                    margin: const EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      color: _isLoading
                          ? Colors.grey
                          : Theme.of(context).primaryColor.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: _isLoading
                        ? const Padding(
                      padding: EdgeInsets.all(10),
                      child: SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      ),
                    )
                        : Icon(
                      Icons.my_location,
                      color: Theme.of(context).primaryColor,
                    ),
                  ),
                ),
              ),
              Row(
                children: [
                  Expanded(
                    child: PremiumUI.buildTextField(
                      context,
                      'Door No *',
                      controller: SurveyStore.instance.doorNoCtrl,
                      validator: (v) => v!.isEmpty ? 'Required' : null,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: PremiumUI.buildTextField(
                      context,
                      'State',
                      controller: SurveyStore.instance.stateCtrl,
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                  Expanded(
                    child: PremiumUI.buildTextField(
                      context,
                      'Block Name',
                      controller: SurveyStore.instance.blockNameCtrl,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: PremiumUI.buildTextField(
                      context,
                      'Block Code',
                      controller: SurveyStore.instance.blockCodeCtrl,
                    ),
                  ),
                ],
              ),
              PremiumUI.buildDropdown(
                context,
                'Village Name *',
                _vills,
                value: SurveyStore.instance.villageSelected,
                onChanged: (v) {
                  setState(() {
                    SurveyStore.instance.villageSelected = v;
                    // Automatically set the code based on the selection
                    if (v != null) {
                      SurveyStore.instance.villageCodeCtrl.text = _villageData[v] ?? '';
                    }
                  });
                },
                validator: (v) => v == null ? 'Required' : null,
              ), // 2. Updated Village Code TextField (Now Read-Only since it's automatic)
              PremiumUI.buildTextField(
                context,
                'Village Code',
                controller: SurveyStore.instance.villageCodeCtrl,
                readOnly: true, // Set to true so users don't manually break the mapping
                icon: Icons.qr_code_2_rounded,
              ),
              PremiumUI.buildTextField(
                context,
                'Gram Panchayat Name',
                controller: SurveyStore.instance.gpNameCtrl,
              ),
              PremiumUI.buildTextField(
                context,
                'Gram Panchayat Code',
                controller: SurveyStore.instance.gpCodeCtrl,
              ),
              PremiumUI.buildDropdown(
                context,
                'Ward No *',
                ['1', '2', '3', '4', '5', '6', '7', '8', '9'],
                value: SurveyStore.instance.wardSelected,
                onChanged: (v) {
                  setState(() {
                    // 1. Update WARD selected, NOT village selected
                    SurveyStore.instance.wardSelected = v;

                    // 2. REMOVE the villageCode line from here!
                    // Wards don't change the Village Code.
                  });
                },
                validator: (v) => v == null ? 'Required' : null,
              ),
            ],
          ),
        ),
      ],
    );
  }
}

// --- PAGE 2: RESPONDENT INFO ---
class Page2RespondentInfo extends StatelessWidget {
  const Page2RespondentInfo({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(24),
      children: [
        Container(
          padding: const EdgeInsets.all(24),
          decoration: PremiumUI.cardDecoration(context),
          child: Column(
            children: [
              PremiumUI.buildTextField(
                context,
                'Aadhar Number',
                controller: SurveyStore.instance.aadharCtrl,
                icon: Icons.credit_card,
                type: TextInputType.number,
                formatters: [
                  FilteringTextInputFormatter.digitsOnly,
                  LengthLimitingTextInputFormatter(12),
                ],
              ),
              PremiumUI.buildTextField(
                context,
                'Full Name *',
                controller: SurveyStore.instance.respNameCtrl,
                icon: Icons.person_outline,
                validator: (v) => v!.isEmpty ? 'Required' : null,
              ),
              PremiumUI.buildTextField(
                context,
                'Relationship with Head *',
                controller: SurveyStore.instance.relationCtrl,
                icon: Icons.family_restroom,
                validator: (v) => v!.isEmpty ? 'Required' : null,
              ),
              PremiumUI.buildTextField(
                context,
                'Residential Address *',
                controller: SurveyStore.instance.addressCtrl,
                icon: Icons.home_outlined,
                validator: (v) => v!.isEmpty ? 'Required' : null,
              ),
              Row(
                children: [
                  Expanded(
                    child: PremiumUI.buildTextField(
                      context,
                      'Pincode *',
                      controller: SurveyStore.instance.pincodeCtrl,
                      type: TextInputType.number,
                      formatters: [
                        FilteringTextInputFormatter.digitsOnly,
                        LengthLimitingTextInputFormatter(6),
                      ],
                      validator: (v) =>
                      v!.length == 6 ? null : '6 Digits required',
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    flex: 2,
                    child: PremiumUI.buildTextField(
                      context,
                      'Mobile No. *',
                      controller: SurveyStore.instance.respMobileCtrl,
                      type: TextInputType.number,
                      formatters: [
                        FilteringTextInputFormatter.digitsOnly,
                        LengthLimitingTextInputFormatter(10),
                      ],
                      validator: (v) =>
                      v!.length == 10 ? null : '10 Digits required',
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}

// --- PAGE 3: HOUSEHOLD INFO ---
class Page3HouseholdInfo extends StatefulWidget {
  const Page3HouseholdInfo({Key? key}) : super(key: key);
  @override
  _Page3HouseholdInfoState createState() => _Page3HouseholdInfoState();
}

class _Page3HouseholdInfoState extends State<Page3HouseholdInfo> {
  String get _rc => SurveyStore.instance.hasRationCard;
  set _rc(String v) => SurveyStore.instance.hasRationCard = v;
  String get _social => SurveyStore.instance.socialStatus;
  set _social(String v) => SurveyStore.instance.socialStatus = v;
  String get _rent => SurveyStore.instance.livingIn;
  set _rent(String v) => SurveyStore.instance.livingIn = v;
  String get _houseType => SurveyStore.instance.houseType;
  set _houseType(String v) => SurveyStore.instance.houseType = v;
  String get _migrate => SurveyStore.instance.anyMigrates;
  set _migrate(String v) => SurveyStore.instance.anyMigrates = v;
  String get _migrateArea => SurveyStore.instance.familyMigratedOut;
  set _migrateArea(String v) => SurveyStore.instance.familyMigratedOut = v;
  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(24),
      children: [
        Container(
          padding: const EdgeInsets.all(24),
          decoration: PremiumUI.cardDecoration(context),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              PremiumUI.buildSectionHeader(
                context,
                'Household Basics',
                icon: Icons.roofing,
              ),
              PremiumUI.buildTextField(
                context,
                'Head Name (as per ration card) *',
                controller: SurveyStore.instance.headNameCtrl,
                validator: (v) => v!.isEmpty ? 'Required' : null,
              ),
              PremiumUI.buildTextField(
                context,
                'Total Family Members *',
                controller: SurveyStore.instance.famCountCtrl,
                type: TextInputType.number,
                validator: (v) => v!.isEmpty ? 'Required' : null,
              ),
              Row(
                children: [
                  Expanded(
                    child: PremiumUI.buildTextField(
                      context,
                      'Male',
                      controller: SurveyStore.instance.maleCtrl,
                      type: TextInputType.number,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: PremiumUI.buildTextField(
                      context,
                      'Female',
                      controller: SurveyStore.instance.femaleCtrl,
                      type: TextInputType.number,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: PremiumUI.buildTextField(
                      context,
                      'Others',
                      controller: SurveyStore.instance.otherCtrl,
                      type: TextInputType.number,
                    ),
                  ),
                ],
              ),
              PremiumUI.buildDropdown(
                context,
                'Category *',
                ['SC', 'ST', 'OBC', 'MBC', 'General'],
                value: SurveyStore.instance.categorySelected,
                onChanged: (v) =>
                    setState(() => SurveyStore.instance.categorySelected = v),
              ),
              const SizedBox(height: 12),

              PremiumUI.buildSectionHeader(
                context,
                'Documentation & Status',
                icon: Icons.description_outlined,
              ),
              PremiumUI.buildModernToggle(
                context,
                'Ration Card *',
                ['Yes', 'No'],
                _rc,
                    (v) => setState(() => _rc = v),
              ),
              if (_rc == 'Yes') ...[
                PremiumUI.buildModernToggle(
                  context,
                  'Card Type *',
                  ['NPHH', 'PHH', 'AAY', 'OTHERS'],
                  SurveyStore.instance.cardType,
                      (v) => setState(() => SurveyStore.instance.cardType = v),
                ),
                PremiumUI.buildTextField(
                  context,
                  'Ration Card No:',
                  controller: SurveyStore.instance.rationCardNoCtrl,
                ),
              ],
              PremiumUI.buildModernToggle(
                context,
                'Social Status *',
                ['APL', 'BPL'],
                _social,
                    (v) => setState(() => _social = v),
              ),
              if (_social == 'APL')
                PremiumUI.buildDropdown(
                  context,
                  'If APL *',
                  ['EWS', 'LIG', 'MIG', 'HIG'],
                  value: SurveyStore.instance.aplCategory,
                  onChanged: (v) =>
                      setState(() => SurveyStore.instance.aplCategory = v),
                ),

              const SizedBox(height: 12),
              PremiumUI.buildSectionHeader(
                context,
                'Living & Income',
                icon: Icons.account_balance_wallet_outlined,
              ),
              PremiumUI.buildModernToggle(
                context,
                'Living In *',
                ['Own House', 'Rental House'],
                _rent,
                    (v) => setState(() => _rent = v),
              ),
              if (_rent == 'Rental House')
                PremiumUI.buildTextField(
                  context,
                  'If Rental, Migration From *',
                  controller: SurveyStore.instance.rentalFromCtrl,
                ),
              PremiumUI.buildModernToggle(
                context,
                'Type Of House *',
                ['Kutcha', 'Semi Pucca', 'Pucca', 'Homeless'],
                _houseType,
                    (v) => setState(() => _houseType = v),
              ),
              PremiumUI.buildTextField(
                context,
                'Annual Income (₹) *',
                controller: SurveyStore.instance.annualIncomeCtrl,
                type: TextInputType.number,
                validator: (v) => v!.isEmpty ? 'Required' : null,
              ),

              const SizedBox(height: 12),
              PremiumUI.buildSectionHeader(
                context,
                'Migration Patterns',
                icon: Icons.flight_takeoff_rounded,
              ),
              PremiumUI.buildModernToggle(
                context,
                'Does any member migrate for work?',
                ['Yes', 'No'],
                _migrate,
                    (v) => setState(() => _migrate = v),
              ),
              if (_migrate == 'Yes') ...[
                PremiumUI.buildTextField(
                  context,
                  'How many members migrated?',
                  controller: SurveyStore.instance.migrantCountCtrl,
                  type: TextInputType.number,
                ),
                PremiumUI.buildTextField(
                  context,
                  'Since how many years?',
                  controller: SurveyStore.instance.migrationYearsCtrl,
                  type: TextInputType.number,
                ),
                PremiumUI.buildTextField(
                  context,
                  'How frequently does migration occur?',
                  controller: SurveyStore.instance.migrationFreqCtrl,
                ),
              ],
              PremiumUI.buildModernToggle(
                context,
                'Family migrated from another area?',
                ['Yes', 'No'],
                _migrateArea,
                    (v) => setState(() => _migrateArea = v),
              ),
              if (_migrateArea == 'Yes')
                PremiumUI.buildTextField(
                  context,
                  'Migrated from:',
                  controller: SurveyStore.instance.migratedFromCtrl,
                ),
            ],
          ),
        ),
      ],
    );
  }
}

// --- PAGE 4: FAMILY MEMBERS ---
class Page4FamilyMembers extends StatefulWidget {
  const Page4FamilyMembers({Key? key}) : super(key: key);
  @override
  _Page4FamilyMembersState createState() => _Page4FamilyMembersState();
}

class _Page4FamilyMembersState extends State<Page4FamilyMembers> {
  List<Map<String, dynamic>> get _mems => SurveyStore.instance.members;
  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(24),
      children: [
        ..._mems.asMap().entries.map((e) {
          int i = e.key;
          final m = _mems[i];
          return Container(
            margin: const EdgeInsets.only(bottom: 24),
            padding: const EdgeInsets.all(24),
            decoration: PremiumUI.cardDecoration(context),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 14,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: Theme.of(context).primaryColor,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        'Member ${i + 1}',
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 13,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    if (i != 0)
                      IconButton(
                        icon: const Icon(
                          Icons.close_rounded,
                          color: Colors.redAccent,
                        ),
                        onPressed: () => setState(
                              () => SurveyStore.instance.removeMember(i),
                        ),
                      ),
                  ],
                ),
                const SizedBox(height: 24),
                PremiumUI.buildTextField(
                  context,
                  'Full Name *',
                  controller: m['nameCtrl'] as TextEditingController,
                  validator: (v) => v!.isEmpty ? 'Required' : null,
                ),
                Row(
                  children: [
                    Expanded(
                      child: PremiumUI.buildTextField(
                        context,
                        'Age *',
                        controller: m['ageCtrl'] as TextEditingController,
                        type: TextInputType.number,
                        validator: (v) => v!.isEmpty ? 'Required' : null,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      flex: 2,
                      child: PremiumUI.buildDropdown(
                        context,
                        'Gender *',
                        ['Male', 'Female', 'Other'],
                        value: m['genderSel'] as String?,
                        onChanged: (v) => setState(() => m['genderSel'] = v),
                        validator: (v) => v == null ? 'Required' : null,
                      ),
                    ),
                  ],
                ),
                PremiumUI.buildDropdown(
                  context,
                  'Marital Status',
                  ['Not Married', 'Married', 'Widowed', 'Divorced'],
                  value: m['maritalSel'] as String?,
                  onChanged: (v) => setState(() => m['maritalSel'] = v),
                ),
                PremiumUI.buildDropdown(
                  context,
                  'Education Level',
                  [
                    '01. Literate',
                    '02.Upto Class 5',
                    '03. Class 8th',
                    '04. Class 10th',
                    '05. Class 12th',
                    '06. ITI/Diploma',
                    '07. Graduate',
                    '08. Post Graduate/Professional',
                    '09. Illiterate'
                  ],
                  value: m['eduSel'] as String?,
                  onChanged: (v) => setState(() => m['eduSel'] = v),
                ),
                PremiumUI.buildDropdown(
                  context,
                  'Do you have Aadhar? *',
                  ['Yes', 'No'],
                  value: m['hasAadhar'] as String?, // Ensure this key exists in SurveyStore
                  onChanged: (v) => setState(() => m['hasAadhar'] = v),
                  validator: (v) => v == null ? 'Required' : null,
                  icon: Icons.credit_card,
                ),
                Row(
                  children: [
                    Expanded(
                      child: PremiumUI.buildDropdown(
                        context,
                        'Ration Card *',
                        ['Yes', 'No'],
                        value: m['rationSel'] as String?,
                        onChanged: (v) => setState(() => m['rationSel'] = v),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: PremiumUI.buildDropdown(
                        context,
                        'Bank Acc *',
                        ['Yes', 'No'],
                        value: m['bankSel'] as String?,
                        onChanged: (v) => setState(() => m['bankSel'] = v),
                      ),
                    ),
                  ],
                ),
                PremiumUI.buildTextField(
                  context,
                  'Mobile (10 Digits) *',
                  controller: m['mobileCtrl'] as TextEditingController,
                  type: TextInputType.number,
                  formatters: [
                    FilteringTextInputFormatter.digitsOnly,
                    LengthLimitingTextInputFormatter(10),
                  ],
                  validator: (v) =>
                  v!.length == 10 ? null : '10 Digits required',
                ),
                PremiumUI.buildDropdown(
                  context,
                  'Employment Status *',
                  ['Employed', 'Unemployed'],
                  value: m['employmentSel'] as String?,
                  onChanged: (v) => setState(() => m['employmentSel'] = v),
                ),
                if (m['employmentSel'] == 'Unemployed') ...[
                  PremiumUI.buildModernToggle(
                    context,
                    'Would you like to learn new skills?',
                    ['Yes', 'No'],
                    (m['skillInterest'] as String?) ?? 'No',
                        (v) => setState(() => m['skillInterest'] = v),
                  ),
                  if (m['skillInterest'] == 'Yes')
                    PremiumUI.buildTextField(
                      context,
                      'Which skill would you like to learn?',
                      controller: m['skillTypeCtrl'] as TextEditingController,
                    ),
                ],
                PremiumUI.buildModernToggle(
                  context,
                  'Member of SHG? *',
                  ['Yes', 'No'],
                  m['shg'] as String,
                      (v) => setState(() => m['shg'] = v),
                ),
                if (m['shg'] == 'Yes') ...[
                  PremiumUI.buildTextField(
                    context,
                    'SHG Name *',
                    controller: m['shgNameCtrl'] as TextEditingController,
                  ),
                  PremiumUI.buildTextField(
                    context,
                    'SHG Activity *',
                    controller: m['shgActivityCtrl'] as TextEditingController,
                  ),
                ],
                PremiumUI.buildModernToggle(
                  context,
                  'Physically Challenged? *',
                  ['Yes', 'No'],
                  m['dis'] as String,
                      (v) => setState(() => m['dis'] = v),
                ),
                if (m['dis'] == 'Yes') ...[
                  PremiumUI.buildTextField(
                    context,
                    'Nature of Disability *',
                    controller: m['disabilityCtrl'] as TextEditingController,
                  ),
                  PremiumUI.buildDropdown(
                    context,
                    'Presently having ID Card *',
                    ['Yes', 'No'],
                    value: m['disabilityIdSel'] as String?,
                    onChanged: (v) => setState(() => m['disabilityIdSel'] = v),
                  ),
                ],
                PremiumUI.buildDropdown(
                  context,
                  'CM Health Insurance *',
                  ['Yes', 'No'],
                  value: m['healthSel'] as String?,
                  onChanged: (v) => setState(() => m['healthSel'] = v),
                ),
              ],
            ),
          );
        }).toList(),
        PremiumUI.buildDashedAddButton(
          context,
          "Add Family Member",
              () => setState(() => SurveyStore.instance.addMember()),
        ),
      ],
    );
  }
}

// --- PAGE 5: WATER & SANITATION ---
class Page5WaterSanitation extends StatefulWidget {
  const Page5WaterSanitation({Key? key}) : super(key: key);
  @override
  _Page5WaterSanitationState createState() => _Page5WaterSanitationState();
}

class _Page5WaterSanitationState extends State<Page5WaterSanitation> {
  String get _piped => SurveyStore.instance.hasPipedWater;
  set _piped(String v) => SurveyStore.instance.hasPipedWater = v;
  String get _comm => SurveyStore.instance.hasCommunityTap;
  set _comm(String v) => SurveyStore.instance.hasCommunityTap = v;
  String get _supp => SurveyStore.instance.waterSuppliedBy;
  set _supp(String v) => SurveyStore.instance.waterSuppliedBy = v;
  String get _hand => SurveyStore.instance.hasHandPump;
  set _hand(String v) => SurveyStore.instance.hasHandPump = v;
  String get _open => SurveyStore.instance.hasOpenWell;
  set _open(String v) => SurveyStore.instance.hasOpenWell = v;
  String get _mode => SurveyStore.instance.waterStorageMode;
  set _mode(String v) => SurveyStore.instance.waterStorageMode = v;
  String get _segre => SurveyStore.instance.wasteSegregated;
  set _segre(String v) => SurveyStore.instance.wasteSegregated = v;
  String get _sanSys => SurveyStore.instance.hasSanitation;
  set _sanSys(String v) => SurveyStore.instance.hasSanitation = v;
  String get _sanUse => SurveyStore.instance.usesSanitation;
  set _sanUse(String v) => SurveyStore.instance.usesSanitation = v;
  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(24),
      children: [
        Container(
          padding: const EdgeInsets.all(24),
          decoration: PremiumUI.cardDecoration(context),
          child: Column(
            children: [
              PremiumUI.buildSectionHeader(
                context,
                'Jal Shakti',
                subtitle: 'Ministry of Jal Shakti, GOI',
                icon: Icons.water_drop_outlined,
              ),
              PremiumUI.buildModernToggle(
                context,
                'Piped Water At Home *',
                ['YES', 'NO'],
                _piped,
                    (v) => setState(() => _piped = v),
              ),
              PremiumUI.buildModernToggle(
                context,
                'Community Water Tap *',
                ['YES', 'NO'],
                _comm,
                    (v) => setState(() => _comm = v),
              ),
              PremiumUI.buildModernToggle(
                context,
                'Supplied Water By *',
                ['Government', 'Private'],
                _supp,
                    (v) => setState(() => _supp = v),
              ),
              PremiumUI.buildModernToggle(
                context,
                'Hand Pump *',
                ['YES', 'NO'],
                _hand,
                    (v) => setState(() => _hand = v),
              ),
              PremiumUI.buildModernToggle(
                context,
                'Open Well *',
                ['YES', 'NO'],
                _open,
                    (v) => setState(() => _open = v),
              ),
              PremiumUI.buildModernToggle(
                context,
                'Mode of Storage *',
                ['Community', 'Individual'],
                _mode,
                    (v) => setState(() => _mode = v),
              ),

              const Divider(height: 50),
              PremiumUI.buildSectionHeader(
                context,
                'Swachh Bharat',
                subtitle: 'Ministry of Drinking Water & Sanitation',
                icon: Icons.cleaning_services_outlined,
              ),
              PremiumUI.buildModernToggle(
                context,
                'Waste Segregated',
                ['YES', 'NO'],
                _segre,
                    (v) => setState(() => _segre = v),
              ),
              PremiumUI.buildDropdown(
                context,
                'Waste Collection *',
                ['Door Step', 'Common point', 'No Collection System'],
                value: SurveyStore.instance.wasteCollection,
                onChanged: (v) =>
                    setState(() => SurveyStore.instance.wasteCollection = v),
              ),
              PremiumUI.buildDropdown(
                context,
                'Toilet *',
                ['Private', 'Public', 'Open Defecation'],
                value: SurveyStore.instance.toiletType,
                onChanged: (v) =>
                    setState(() => SurveyStore.instance.toiletType = v),
              ),
              PremiumUI.buildDropdown(
                context,
                'Drainage to House *',
                ['Covered', 'Open', 'None'],
                value: SurveyStore.instance.drainageType,
                onChanged: (v) =>
                    setState(() => SurveyStore.instance.drainageType = v),
              ),
              PremiumUI.buildDropdown(
                context,
                'Waste Freq *',
                ['Daily', 'Weekly', 'Random', 'Custom'],
                value: SurveyStore.instance.wasteFreq,
                onChanged: (v) =>
                    setState(() => SurveyStore.instance.wasteFreq = v),
              ),
              PremiumUI.buildDropdown(
                context,
                'Composed Pit *',
                ['Individual', 'Group', 'None'],
                value: SurveyStore.instance.compostPit,
                onChanged: (v) =>
                    setState(() => SurveyStore.instance.compostPit = v),
              ),
              PremiumUI.buildDropdown(
                context,
                'Biogas Plant *',
                ['Individual', 'Group', 'Community'],
                value: SurveyStore.instance.biogasPlant,
                onChanged: (v) =>
                    setState(() => SurveyStore.instance.biogasPlant = v),
              ),

              PremiumUI.buildModernToggle(
                context,
                'Sanitation System?',
                ['YES', 'NO'],
                _sanSys,
                    (v) => setState(() => _sanSys = v),
              ),
              if (_sanSys == 'YES') ...[
                PremiumUI.buildModernToggle(
                  context,
                  'Do You Use It?',
                  ['YES', 'NO'],
                  _sanUse,
                      (v) => setState(() => _sanUse = v),
                ),
                if (_sanUse == 'NO')
                  PremiumUI.buildTextField(
                    context,
                    'Why not use it? *',
                    controller: SurveyStore.instance.reasonNotUsingCtrl,
                  ),
              ] else ...[
                PremiumUI.buildTextField(
                  context,
                  'Why no sanitation system? *',
                  controller: SurveyStore.instance.whyNoSanitationCtrl,
                ),
              ],

              PremiumUI.buildDropdown(
                context,
                'Black Water Discharge *',
                ['Pond', 'Drain', 'Soak pit', 'Open pit', 'None'],
                value: SurveyStore.instance.blackWaterDischarge,
                onChanged: (v) => setState(
                      () => SurveyStore.instance.blackWaterDischarge = v,
                ),
              ),
              PremiumUI.buildDropdown(
                context,
                'System Type *',
                [
                  'Twin pit',
                  'Septic Tank',
                  'Single pit',
                  'Soak pit',
                  'Leach pit',
                  'Open pit',
                  'Kaccha pit',
                ],
                value: SurveyStore.instance.systemType,
                onChanged: (v) =>
                    setState(() => SurveyStore.instance.systemType = v),
              ),
              PremiumUI.buildTextField(
                context,
                'Dimension of System',
                controller: SurveyStore.instance.dimensionCtrl,
              ),
              PremiumUI.buildTextField(
                context,
                'Material Used',
                controller: SurveyStore.instance.materialCtrl,
              ),
              PremiumUI.buildTextField(
                context,
                'Cleaning Period',
                controller: SurveyStore.instance.cleaningPeriodCtrl,
              ),
              PremiumUI.buildTextField(
                context,
                'Cost of System (₹)',
                controller: SurveyStore.instance.systemCostCtrl,
                type: TextInputType.number,
              ),
              PremiumUI.buildDropdown(
                context,
                'Grey Water Discharge *',
                ['Soak pit', 'Kitchen Garden', 'Leach pit', 'Drain', 'None'],
                value: SurveyStore.instance.greyWaterDischarge,
                onChanged: (v) =>
                    setState(() => SurveyStore.instance.greyWaterDischarge = v),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

// --- PAGE 6: ENERGY ---
class Page6Energy extends StatefulWidget {
  const Page6Energy({Key? key}) : super(key: key);
  @override
  _Page6EnergyState createState() => _Page6EnergyState();
}

class _Page6EnergyState extends State<Page6Energy> {
  String _elec = 'YES', _subsidy = 'YES';
  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(24),
      children: [
        Container(
          padding: const EdgeInsets.all(24),
          decoration: PremiumUI.cardDecoration(context),
          child: Column(
            children: [
              PremiumUI.buildSectionHeader(
                context,
                'Power Status',
                subtitle: 'Ministry of Power',
                icon: Icons.electric_bolt_outlined,
              ),
              PremiumUI.buildModernToggle(
                context,
                'Electricity Connection *',
                ['YES', 'NO'],
                _elec,
                    (v) => setState(() => _elec = v),
              ),
              PremiumUI.buildTextField(
                context,
                'Daily Availability (Hrs)',
                type: TextInputType.number,
              ),
              PremiumUI.buildDropdown(context, 'Lighting Source *', [
                'Kerosene',
                'Solar Power',
                'Grid',
                'None',
              ]),
              PremiumUI.buildTextField(context, 'Mention If Other'),
              const Divider(height: 50),
              PremiumUI.buildSectionHeader(
                context,
                'Fuel & Petroleum',
                subtitle: 'Ministry of Petroleum',
                icon: Icons.local_fire_department_outlined,
              ),
              PremiumUI.buildDropdown(context, 'Cooking Fuel *', [
                'Cow Dung',
                'LPG',
                'Biogas',
                'Kerosene',
                'Wood',
                'Agro Residues',
                'Electricity',
              ]),
              PremiumUI.buildTextField(context, 'Mention If Other'),
              PremiumUI.buildModernToggle(
                context,
                'LPG Subsidy Active?',
                ['YES', 'NO'],
                _subsidy,
                    (v) => setState(() => _subsidy = v),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

// --- PAGE 7: AGRICULTURE ---
class Page7Agri extends StatefulWidget {
  const Page7Agri({Key? key}) : super(key: key);
  @override
  _Page7AgriState createState() => _Page7AgriState();
}

class _Page7AgriState extends State<Page7Agri> {
  String cF = 'YES', cI = 'YES', cW = 'YES', oM = 'YES';
  List<int> crops = [1];
  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(24),
      children: [
        Container(
          padding: const EdgeInsets.all(24),
          decoration: PremiumUI.cardDecoration(context),
          child: Column(
            children: [
              PremiumUI.buildSectionHeader(
                context,
                'Land Metrics',
                subtitle: 'Ministry of Panchayati Raj',
                icon: Icons.landscape_outlined,
              ),
              PremiumUI.buildTextField(
                context,
                '1. Total Area (acres) *',
                type: TextInputType.number,
              ),
              PremiumUI.buildTextField(
                context,
                '2. Cultivable Area (acres) *',
                type: TextInputType.number,
              ),
              PremiumUI.buildTextField(
                context,
                '3. Irrigated Area (acres) *',
                type: TextInputType.number,
              ),
              PremiumUI.buildTextField(
                context,
                '4. Barren Land (acres) *',
                type: TextInputType.number,
              ),
              PremiumUI.buildTextField(
                context,
                '5. Unirrigated Area (acres) *',
                type: TextInputType.number,
              ),
              PremiumUI.buildTextField(
                context,
                '6. Uncultivable Area (acres) *',
                type: TextInputType.number,
              ),
              const Divider(height: 40),
              PremiumUI.buildSectionHeader(
                context,
                'Agricultural Inputs',
                icon: Icons.eco_outlined,
              ),
              PremiumUI.buildModernToggle(
                context,
                'Chemical Fertilizer',
                ['YES', 'NO'],
                cF,
                    (v) => setState(() => cF = v),
              ),
              if (cF == 'YES')
                PremiumUI.buildTextField(context, 'Specify Fertilizer'),
              PremiumUI.buildModernToggle(
                context,
                'Chemical Insecticides',
                ['YES', 'NO'],
                cI,
                    (v) => setState(() => cI = v),
              ),
              if (cI == 'YES')
                PremiumUI.buildTextField(context, 'Specify Insecticide'),
              PremiumUI.buildModernToggle(
                context,
                'Chemical Weedicide',
                ['YES', 'NO'],
                cW,
                    (v) => setState(() => cW = v),
              ),
              if (cW == 'YES')
                PremiumUI.buildTextField(context, 'Specify Weedicide'),
              PremiumUI.buildModernToggle(
                context,
                'Organic Manure',
                ['YES', 'NO'],
                oM,
                    (v) => setState(() => oM = v),
              ),
              if (oM == 'YES')
                PremiumUI.buildTextField(context, 'Specify Manure'),
              PremiumUI.buildDropdown(context, 'Irrigation Source *', [
                'BoreWell',
                'Canal',
                'Tank',
                'River',
                'None',
                'Other',
              ]),
              PremiumUI.buildDropdown(context, 'Irrigation System *', [
                'Sprinkler',
                'Drip',
                'Flood',
              ]),
              ...crops
                  .map(
                    (c) => Container(
                  margin: const EdgeInsets.symmetric(vertical: 16),
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Theme.of(context).primaryColor.withOpacity(0.05),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Column(
                    children: [
                      PremiumUI.buildTextField(context, 'Crop Name *'),
                      PremiumUI.buildTextField(
                        context,
                        'Area (acres/yr) *',
                        type: TextInputType.number,
                      ),
                      PremiumUI.buildTextField(
                        context,
                        'Productivity (quintals/acre)',
                        type: TextInputType.number,
                      ),
                    ],
                  ),
                ),
              )
                  .toList(),
              PremiumUI.buildDashedAddButton(
                context,
                "Add Crop Data",
                    () => setState(() => crops.add(1)),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

// --- PAGE 8: LIVESTOCK ---
class Page8Livestock extends StatefulWidget {
  const Page8Livestock({Key? key}) : super(key: key);
  @override
  _Page8LivestockState createState() => _Page8LivestockState();
}

class _Page8LivestockState extends State<Page8Livestock> {
  List<int> probs = [1];
  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(24),
      children: [
        Container(
          padding: const EdgeInsets.all(24),
          decoration: PremiumUI.cardDecoration(context),
          child: Column(
            children: [
              PremiumUI.buildSectionHeader(
                context,
                'Livestock Profile',
                icon: Icons.pets_outlined,
              ),
              Row(
                children: [
                  Expanded(
                    child: PremiumUI.buildTextField(
                      context,
                      'Cows',
                      type: TextInputType.number,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: PremiumUI.buildTextField(
                      context,
                      'Buffaloes',
                      type: TextInputType.number,
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                  Expanded(
                    child: PremiumUI.buildTextField(
                      context,
                      'Goats/Sheep',
                      type: TextInputType.number,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: PremiumUI.buildTextField(
                      context,
                      'Calves',
                      type: TextInputType.number,
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                  Expanded(
                    child: PremiumUI.buildTextField(
                      context,
                      'Bullocks',
                      type: TextInputType.number,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: PremiumUI.buildTextField(
                      context,
                      'Poultry/Ducks',
                      type: TextInputType.number,
                    ),
                  ),
                ],
              ),
              PremiumUI.buildTextField(
                context,
                'Others',
                type: TextInputType.number,
              ),
              PremiumUI.buildDropdown(context, 'Shelter for livestock *', [
                'Kutcha',
                'Pucca',
                'Semi-Pucca',
                'Open',
              ]),
              PremiumUI.buildTextField(
                context,
                'Daily Milk Production (L)',
                type: TextInputType.number,
              ),
              PremiumUI.buildTextField(
                context,
                'Animal Waste (kg)',
                type: TextInputType.number,
              ),
              const Divider(height: 40),
              PremiumUI.buildSectionHeader(
                context,
                'Village Challenges',
                icon: Icons.campaign_outlined,
              ),
              ...probs
                  .map(
                    (p) => Container(
                  margin: const EdgeInsets.only(bottom: 16),
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: Theme.of(
                        context,
                      ).primaryColor.withOpacity(0.3),
                    ),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Column(
                    children: [
                      PremiumUI.buildTextField(context, 'Major Problem'),
                      PremiumUI.buildTextField(context, 'Your Suggestion'),
                    ],
                  ),
                ),
              )
                  .toList(),
              PremiumUI.buildDashedAddButton(
                context,
                "Add Problem Record",
                    () => setState(() => probs.add(1)),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

// --- PAGE 9 & 10: SCHEMES ---
class StarRating extends StatelessWidget {
  final int rating;
  final ValueChanged<int> onChanged;

  const StarRating({Key? key, required this.rating, required this.onChanged})
      : super(key: key);

  @override
  Widget build(BuildContext context) => Row(
    children: List.generate(
      5,
          (i) => IconButton(
        icon: Icon(
          i < rating ? Icons.star_rounded : Icons.star_outline_rounded,
          color: Theme.of(context).primaryColor,
          size: 36,
        ),
        onPressed: () => onChanged(i + 1),
      ),
    ),
  );
}

Widget buildSchemeList(
    BuildContext context,
    List<String> schemes,
    Map<String, int> ratings,
    String title,
    VoidCallback onChanged,
    ) {
  return ListView(
    padding: const EdgeInsets.all(24),
    children: [
      Text(
        title,
        style: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.w800,
          color: Theme.of(context).colorScheme.secondary,
          letterSpacing: -0.5,
        ),
      ),
      const SizedBox(height: 24),
      ...schemes
          .map(
            (scheme) => Container(
          margin: const EdgeInsets.only(bottom: 24),
          padding: const EdgeInsets.all(24),
          decoration: PremiumUI.cardDecoration(context),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Theme.of(
                        context,
                      ).primaryColor.withOpacity(0.1),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.verified_user_outlined,
                      color: Theme.of(context).primaryColor,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Text(
                      scheme,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        color: Theme.of(context).colorScheme.secondary,
                        height: 1.3,
                      ),
                    ),
                  ),
                ],
              ),
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 16),
                child: Divider(),
              ),
              const Text(
                'Awareness Level',
                style: TextStyle(
                  fontSize: 13,
                  color: Colors.grey,
                  fontWeight: FontWeight.w600,
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: StarRating(
                  rating: ratings[scheme] ?? 0,
                  onChanged: (value) {
                    ratings[scheme] = value;
                    onChanged();
                  },
                ),
              ),
              const SizedBox(height: 12),
              PremiumUI.buildTextField(
                context,
                'Beneficiary Count',
                type: TextInputType.number,
                icon: Icons.group_outlined,
              ),
            ],
          ),
        ),
      )
          .toList(),
    ],
  );
}

class Page9StateSchemes extends StatefulWidget {
  const Page9StateSchemes({Key? key}) : super(key: key);

  @override
  State<Page9StateSchemes> createState() => _Page9StateSchemesState();
}

class _Page9StateSchemesState extends State<Page9StateSchemes> {
  @override
  Widget build(BuildContext context) {
    final store = SurveyStore.instance;
    return buildSchemeList(
      context,
      store.stateSchemes,
      store.stateSchemeRatings,
      'State Govt. Schemes',
          () => setState(() {}),
    );
  }
}

class Page10CentralSchemes extends StatefulWidget {
  const Page10CentralSchemes({Key? key}) : super(key: key);

  @override
  State<Page10CentralSchemes> createState() => _Page10CentralSchemesState();
}

class _Page10CentralSchemesState extends State<Page10CentralSchemes> {
  @override
  Widget build(BuildContext context) {
    final store = SurveyStore.instance;
    return buildSchemeList(
      context,
      store.centralSchemes,
      store.centralSchemeRatings,
      'Central Govt. Schemes',
          () => setState(() {}),
    );
  }
}