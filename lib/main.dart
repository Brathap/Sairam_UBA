import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:animate_do/animate_do.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:geolocator/geolocator.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const UBASurveyApp());
}

// ==========================================
// GLOBAL STATE & THEME MANAGEMENT
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

  void toggleTheme() {
    setState(() {
      _themeMode = _themeMode == ThemeMode.light ? ThemeMode.dark : ThemeMode.light;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'UBA Survey Premium',
      debugShowCheckedModeBanner: false,
      themeMode: _themeMode,
      theme: ThemeData(
        brightness: Brightness.light,
        primaryColor: const Color(0xFFF5A623),
        scaffoldBackgroundColor: const Color(0xFFF4F7FC),
        cardColor: Colors.white,
        textTheme: GoogleFonts.poppinsTextTheme(ThemeData.light().textTheme),
        colorScheme: const ColorScheme.light(primary: Color(0xFFF5A623), secondary: Color(0xFF2A3037)),
      ),
      darkTheme: ThemeData(
        brightness: Brightness.dark,
        primaryColor: const Color(0xFFF5A623),
        scaffoldBackgroundColor: const Color(0xFF0A0C10),
        cardColor: const Color(0xFF161B22),
        textTheme: GoogleFonts.poppinsTextTheme(ThemeData.dark().textTheme),
        colorScheme: const ColorScheme.dark(primary: Color(0xFFF5A623), secondary: Colors.white),
      ),
      home: const SplashScreen(),
    );
  }
}

// ==========================================
// PREMIUM UI HELPER COMPONENTS
// ==========================================
class PremiumUI {
  static BoxDecoration cardDecoration(BuildContext context) {
    bool isDark = Theme.of(context).brightness == Brightness.dark;
    return BoxDecoration(
      color: Theme.of(context).cardColor,
      borderRadius: BorderRadius.circular(20),
      boxShadow: isDark ? [] : [
        BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 20, spreadRadius: 2, offset: const Offset(0, 5)),
      ],
    );
  }

  static InputDecoration inputDecoration(BuildContext context, String label, {IconData? icon}) {
    bool isDark = Theme.of(context).brightness == Brightness.dark;
    return InputDecoration(
      labelText: label,
      labelStyle: TextStyle(color: isDark ? Colors.grey.shade400 : Colors.grey.shade600, fontSize: 14),
      filled: true,
      fillColor: isDark ? const Color(0xFF21262D) : const Color(0xFFF9FAFC),
      prefixIcon: icon != null ? Icon(icon, color: const Color(0xFFF5A623), size: 20) : null,
      enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(15), borderSide: BorderSide(color: isDark ? Colors.grey.shade800 : Colors.grey.shade200)),
      focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(15), borderSide: const BorderSide(color: Color(0xFFF5A623), width: 2)),
      errorBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(15), borderSide: const BorderSide(color: Colors.redAccent, width: 1)),
      focusedErrorBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(15), borderSide: const BorderSide(color: Colors.redAccent, width: 2)),
      contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
    );
  }
}

// ==========================================
// 1. ULTRA-PREMIUM SPLASH SCREEN
// ==========================================
class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with SingleTickerProviderStateMixin {
  late AnimationController _pulseController;
  late Animation<double> _pulseAnimation;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(vsync: this, duration: const Duration(seconds: 2))..repeat(reverse: true);
    _pulseAnimation = Tween<double>(begin: 1.0, end: 1.08).animate(CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut));

    Future.delayed(const Duration(seconds: 3), () {
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const LoginScreen()));
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
          gradient: LinearGradient(colors: [Color(0xFF0F1115), Color(0xFF1E2228)], begin: Alignment.topLeft, end: Alignment.bottomRight),
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
                    color: Colors.white, shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(color: const Color(0xFFF5A623).withOpacity(0.2), blurRadius: 50, spreadRadius: 20),
                      BoxShadow(color: Colors.white.withOpacity(0.1), blurRadius: 20, spreadRadius: -5)
                    ],
                  ),
                  child: Image.asset('assets/UBA_Logo.png', height: 120, width: 120, errorBuilder: (c, e, s) => const Icon(Icons.account_balance, size: 80, color: Color(0xFFF5A623))),
                ),
              ),
            ),
            const SizedBox(height: 60),
            FadeInUp(
              duration: const Duration(milliseconds: 1000),
              child: Text('UNNAT BHARAT\nABHIYAN', textAlign: TextAlign.center, style: GoogleFonts.montserrat(fontSize: 34, fontWeight: FontWeight.w900, color: Colors.white, height: 1.1, letterSpacing: 3)),
            ),
            const SizedBox(height: 20),
            FadeInUp(
              delay: const Duration(milliseconds: 500),
              duration: const Duration(milliseconds: 1000),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                decoration: BoxDecoration(color: Colors.white.withOpacity(0.05), borderRadius: BorderRadius.circular(20), border: Border.all(color: Colors.white.withOpacity(0.1))),
                child: Text('Digital Survey Platform', style: GoogleFonts.poppins(color: const Color(0xFFF5A623), fontSize: 14, letterSpacing: 2, fontWeight: FontWeight.w500)),
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
// 2. LOGIN SCREEN
// ==========================================
class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: FadeInUp(
            child: Container(
              padding: const EdgeInsets.all(30),
              decoration: PremiumUI.cardDecoration(context),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Welcome Back', style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Theme.of(context).colorScheme.secondary)),
                    const SizedBox(height: 8),
                    const Text('Sign in to continue UBA Survey', style: TextStyle(fontSize: 14, color: Colors.grey)),
                    const SizedBox(height: 30),

                    TextFormField(
                      controller: _nameController,
                      decoration: PremiumUI.inputDecoration(context, 'Schedule Filed By *', icon: Icons.person_outline),
                      validator: (val) => val == null || val.isEmpty ? 'Required' : null,
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      decoration: PremiumUI.inputDecoration(context, 'College ID (SIT/SEC)*' , icon: Icons.badge_outlined),
                      validator: (val) {
                        if (val == null || val.isEmpty) return 'Required';
                        if (!val.toUpperCase().startsWith('SIT') && !val.toUpperCase().startsWith('SEC')) return 'Must start with SIT or SEC';
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      obscureText: true,
                      decoration: PremiumUI.inputDecoration(context, 'Password *', icon: Icons.lock_outline),
                      validator: (val) => val == 'sairam123' ? null : 'Invalid password',
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      keyboardType: TextInputType.number,
                      inputFormatters: [FilteringTextInputFormatter.digitsOnly, LengthLimitingTextInputFormatter(10)],
                      decoration: PremiumUI.inputDecoration(context, 'Mobile Number *', icon: Icons.phone_outlined),
                      validator: (val) => (val != null && val.length == 10) ? null : 'Enter a valid 10-digit number',
                    ),
                    const SizedBox(height: 16),
                    TextFormField(decoration: PremiumUI.inputDecoration(context, 'Mentor', icon: Icons.supervisor_account_outlined)),
                    const SizedBox(height: 16),
                    TextFormField(decoration: PremiumUI.inputDecoration(context, 'Department', icon: Icons.domain)),
                    const SizedBox(height: 16),
                    DropdownButtonFormField<String>(decoration: PremiumUI.inputDecoration(context, 'Year *' ,icon:Icons.school), items: ['I', 'II', 'III', 'IV'].map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(), onChanged: (v) {}, validator: (val) => val == null ? 'Required' : null),
                    const SizedBox(height: 16),
                    DropdownButtonFormField<String>(decoration: PremiumUI.inputDecoration(context, 'Section *', icon:Icons.menu_book_outlined), items: ['A', 'B', 'C', 'D', 'E', 'F','G','H'].map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(), onChanged: (v) {}, validator: (val) => val == null ? 'Required' : null),
                    const SizedBox(height: 30),
                    SizedBox(
                      width: double.infinity, height: 55,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFFF5A623), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15))),
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => DashboardScreen(userName: _nameController.text)));
                          }
                        },
                        child: const Text('LOGIN', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white, letterSpacing: 1.2)),
                      ),
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
// 3. MINIMALIST DASHBOARD & LOGOUT
// ==========================================
class DashboardScreen extends StatelessWidget {
  final String userName;
  const DashboardScreen({Key? key, required this.userName}) : super(key: key);

  void _logout(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Logout'),
        content: const Text('Are you sure you want to logout?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const LoginScreen()));
            },
            child: const Row(mainAxisSize: MainAxisSize.min, children: [Icon(Icons.power_settings_new, color: Colors.red, size: 18), SizedBox(width: 4), Text('Logout', style: TextStyle(color: Colors.red))]),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    bool isDark = Theme.of(context).brightness == Brightness.dark;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          IconButton(
            icon: Icon(isDark ? Icons.light_mode : Icons.dark_mode, color: const Color(0xFFF5A623)),
            onPressed: () => UBASurveyApp.of(context).toggleTheme(),
          ),
          IconButton(
            icon: const Icon(Icons.logout_rounded, color: Colors.redAccent, size: 28),
            onPressed: () => _logout(context),
            tooltip: 'Logout',
          ),
          const SizedBox(width: 10),
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
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(color: const Color(0xFFF5A623).withOpacity(0.1), shape: BoxShape.circle),
                  child: const Icon(Icons.waving_hand_rounded, size: 60, color: Color(0xFFF5A623)),
                ),
              ),
              const SizedBox(height: 30),
              FadeInUp(
                child: Text('Welcome, $userName', textAlign: TextAlign.center, style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: Theme.of(context).colorScheme.secondary)),
              ),
              const SizedBox(height: 10),
              FadeInUp(
                delay: const Duration(milliseconds: 200),
                child: const Text('You are successfully logged in. Ready to collect data?', textAlign: TextAlign.center, style: TextStyle(color: Colors.grey, fontSize: 16)),
              ),
              const SizedBox(height: 50),
              FadeInUp(
                delay: const Duration(milliseconds: 400),
                child: SizedBox(
                  width: double.infinity, height: 60,
                  child: ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFF5A623),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                      elevation: 10, shadowColor: const Color(0xFFF5A623).withOpacity(0.5),
                    ),
                    onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const SurveyMasterPage())),
                    icon: const Icon(Icons.add_chart, color: Colors.white, size: 28),
                    label: const Text('START NEW SURVEY', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white, letterSpacing: 1.5)),
                  ),
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
// 4. SURVEY MASTER PAGE
// ==========================================
class SurveyMasterPage extends StatefulWidget {
  const SurveyMasterPage({Key? key}) : super(key: key);
  @override
  _SurveyMasterPageState createState() => _SurveyMasterPageState();
}

class _SurveyMasterPageState extends State<SurveyMasterPage> {
  final PageController _pageController = PageController();
  int _currentPage = 0;
  final List<String> _titles = ['Village Info', 'Respondent Info', 'Household Info', 'Family Details'];

  final _formKey1 = GlobalKey<FormState>();
  final _formKey2 = GlobalKey<FormState>();
  final _formKey3 = GlobalKey<FormState>();
  final _formKey4 = GlobalKey<FormState>();

  void _nextPage() {
    bool canProceed = false;
    if (_currentPage == 0) canProceed = _formKey1.currentState!.validate();
    else if (_currentPage == 1) canProceed = _formKey2.currentState!.validate();
    else if (_currentPage == 2) canProceed = _formKey3.currentState!.validate();
    else if (_currentPage == 3) canProceed = _formKey4.currentState!.validate();

    if (canProceed) {
      if (_currentPage < 3) {
        _pageController.nextPage(duration: const Duration(milliseconds: 400), curve: Curves.easeInOut);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Survey Submitted Successfully!', style: TextStyle(color: Colors.white)), backgroundColor: Colors.green));
        Navigator.pop(context);
      }
    }
  }

  void _prevPage() {
    if (_currentPage > 0) _pageController.previousPage(duration: const Duration(milliseconds: 400), curve: Curves.easeInOut);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent, elevation: 0,
        title: Text(_titles[_currentPage], style: TextStyle(color: Theme.of(context).colorScheme.secondary, fontWeight: FontWeight.bold)),
        iconTheme: IconThemeData(color: Theme.of(context).colorScheme.secondary),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(20),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Row(
              children: List.generate(4, (index) => Expanded(
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  margin: const EdgeInsets.symmetric(horizontal: 4), height: 6,
                  decoration: BoxDecoration(color: index <= _currentPage ? const Color(0xFFF5A623) : Colors.grey.shade300, borderRadius: BorderRadius.circular(10)),
                ),
              )),
            ),
          ),
        ),
      ),
      body: PageView(
        controller: _pageController,
        physics: const NeverScrollableScrollPhysics(),
        onPageChanged: (idx) => setState(() => _currentPage = idx),
        children: [
          Form(key: _formKey1, child: const Page1VillageInfo()),
          Form(key: _formKey2, child: const Page2RespondentInfo()),
          Form(key: _formKey3, child: const Page3HouseholdInfo()),
          Form(key: _formKey4, child: const Page4FamilyMembers()),
        ],
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(color: Theme.of(context).cardColor, boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 20, offset: const Offset(0, -5))]),
        child: Row(
          children: [
            if (_currentPage > 0)
              Expanded(
                child: OutlinedButton(
                  onPressed: _prevPage,
                  style: OutlinedButton.styleFrom(padding: const EdgeInsets.symmetric(vertical: 16), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15))),
                  child: Text('Back', style: TextStyle(color: Theme.of(context).colorScheme.secondary, fontWeight: FontWeight.bold)),
                ),
              ),
            if (_currentPage > 0) const SizedBox(width: 16),
            Expanded(flex: 2, child: ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFFF5A623), padding: const EdgeInsets.symmetric(vertical: 16), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15))),
              onPressed: _nextPage,
              child: Text(_currentPage == 3 ? 'SUBMIT SURVEY' : 'NEXT', style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white, letterSpacing: 1.2)),
            )),
          ],
        ),
      ),
    );
  }
}

// ==========================================
// PAGE 1: VILLAGE INFO (DYNAMIC & EDITABLE)
// ==========================================
class Page1VillageInfo extends StatefulWidget {
  const Page1VillageInfo({Key? key}) : super(key: key);
  @override
  _Page1VillageInfoState createState() => _Page1VillageInfoState();
}

class _Page1VillageInfoState extends State<Page1VillageInfo> {
  final TextEditingController _locationController = TextEditingController();
  final TextEditingController _stateController = TextEditingController(text: 'Tamil Nadu');
  final TextEditingController _blockController = TextEditingController(text: 'Kundrathur');
  final TextEditingController _blockCodeController = TextEditingController(text: '6484');
  bool _isLoadingLocation = false;

  // Simulated dynamic village list based on location
  List<String> _dynamicVillages = ['Amarambedu', 'Erumaiyur', 'Pudupakkam', 'Siruseri'];

  Future<void> _fetchLiveLocation() async {
    setState(() => _isLoadingLocation = true);
    try {
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) throw Exception('Location services are disabled.');

      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) throw Exception('Location permissions are denied');
      }
      Position position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);

      setState(() {
        _locationController.text = '${position.latitude}, ${position.longitude}';
        // Simulate fetching nearby villages based on GPS
        _dynamicVillages = ['Amarambedu', 'Erumaiyur', 'Naduveerapattu', 'Nandambakkam','Pazhandhandalam','Poonthandalam','Sethupattu','Somangalam','Thirumudivakkam','Varadharajapuram'];
        _isLoadingLocation = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Location & Nearby Villages Fetched!'), backgroundColor: Colors.green));
    } catch (e) {
      setState(() => _isLoadingLocation = false);
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.toString()), backgroundColor: Colors.redAccent));
    }
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(24),
      children: [
        Container(
          padding: const EdgeInsets.all(24), decoration: PremiumUI.cardDecoration(context),
          child: Column(
            children: [
              TextFormField(
                controller: _locationController, readOnly: true,
                decoration: PremiumUI.inputDecoration(context, 'Location (Lat, Long) *').copyWith(
                  suffixIcon: GestureDetector(
                    onTap: _isLoadingLocation ? null : _fetchLiveLocation,
                    child: Container(
                      margin: const EdgeInsets.all(8),
                      decoration: BoxDecoration(color: _isLoadingLocation ? Colors.grey : const Color(0xFFF5A623), borderRadius: BorderRadius.circular(10)),
                      child: _isLoadingLocation ? const Padding(padding: EdgeInsets.all(8.0), child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2)) : const Icon(Icons.my_location, color: Colors.white, size: 20),
                    ),
                  ),
                ),
                validator: (val) => val == null || val.isEmpty ? 'Tap the icon to fetch location' : null,
              ),
              const SizedBox(height: 16),
              TextFormField(decoration: PremiumUI.inputDecoration(context, 'Door No: *'), validator: (val) => val!.isEmpty ? 'Required' : null),
              const SizedBox(height: 16),
              // EDITABLE STATE & BLOCK FIELDS
              TextFormField(controller: _stateController, decoration: PremiumUI.inputDecoration(context, 'State: *'), validator: (val) => val!.isEmpty ? 'Required' : null),
              const SizedBox(height: 16),
              TextFormField(controller: _blockController, decoration: PremiumUI.inputDecoration(context, 'Block Name: *'), validator: (val) => val!.isEmpty ? 'Required' : null),
              const SizedBox(height: 16),
              TextFormField(controller: _blockCodeController, decoration: PremiumUI.inputDecoration(context, 'Block Code: *'), validator: (val) => val!.isEmpty ? 'Required' : null),
              const SizedBox(height: 16),

              // VILLAGE NAME DROPDOWN
              DropdownButtonFormField<String>(
                decoration: PremiumUI.inputDecoration(context, 'Village Name: *'),
                items: _dynamicVillages.map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
                onChanged: (v) {},
                validator: (val) => val == null || val.isEmpty ? 'Required' : null,
              ),

              const SizedBox(height: 16),
              TextFormField(decoration: PremiumUI.inputDecoration(context, 'Village Code:')),
              const SizedBox(height: 16),
              TextFormField(decoration: PremiumUI.inputDecoration(context, 'Gram Panchayat Name:')),
              const SizedBox(height: 16),
              TextFormField(decoration: PremiumUI.inputDecoration(context, 'Gram Panchayat Code:')),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(decoration: PremiumUI.inputDecoration(context, 'Ward No: *'), items: ['1', '2', '3', '4', '5', '6'].map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(), onChanged: (v) {}, validator: (val) => val == null ? 'Required' : null),
            ],
          ),
        ),
      ],
    );
  }
}

// ==========================================
// PAGE 2: RESPONDENT INFO
// ==========================================
class Page2RespondentInfo extends StatelessWidget {
  const Page2RespondentInfo({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(24),
      children: [
        Container(
          padding: const EdgeInsets.all(24), decoration: PremiumUI.cardDecoration(context),
          child: Column(
            children: [
              TextFormField(
                keyboardType: TextInputType.number, inputFormatters: [FilteringTextInputFormatter.digitsOnly, LengthLimitingTextInputFormatter(12)],
                decoration: PremiumUI.inputDecoration(context, 'Aadhar Number (12 Digits): *'),
                validator: (val) => (val != null && val.length == 12) ? null : 'Enter a valid 12-digit Aadhar',
              ),
              const SizedBox(height: 16),
              TextFormField(decoration: PremiumUI.inputDecoration(context, 'Name: *'), validator: (val) => val!.isEmpty ? 'Required' : null),
              const SizedBox(height: 16),
              TextFormField(decoration: PremiumUI.inputDecoration(context, 'Relationship with Head: *')),
              const SizedBox(height: 16),
              TextFormField(decoration: PremiumUI.inputDecoration(context, 'Address: *')),
              const SizedBox(height: 16),
              TextFormField(
                keyboardType: TextInputType.number, inputFormatters: [FilteringTextInputFormatter.digitsOnly, LengthLimitingTextInputFormatter(6)],
                decoration: PremiumUI.inputDecoration(context, 'Pincode (6 Digits): *'),
                validator: (val) => (val != null && val.length == 6) ? null : 'Enter a valid 6-digit Pincode',
              ),
              const SizedBox(height: 16),
              TextFormField(
                keyboardType: TextInputType.number, inputFormatters: [FilteringTextInputFormatter.digitsOnly, LengthLimitingTextInputFormatter(10)],
                decoration: PremiumUI.inputDecoration(context, 'Mobile (10 Digits): *'),
                validator: (val) => (val != null && val.length == 10) ? null : 'Enter a valid 10-digit Mobile',
              ),
            ],
          ),
        ),
      ],
    );
  }
}

// ==========================================
// PAGE 3: HOUSEHOLD INFO (100% COMPLETE)
// ==========================================
class Page3HouseholdInfo extends StatefulWidget {
  const Page3HouseholdInfo({Key? key}) : super(key: key);
  @override
  _Page3HouseholdInfoState createState() => _Page3HouseholdInfoState();
}
class _Page3HouseholdInfoState extends State<Page3HouseholdInfo> {
  String _rationCard = 'Yes';
  String _socialStatus = 'APL';
  String _livingIn = 'Rental House';
  String _houseType = 'Kutcha';

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(24),
      children: [
        Container(
          padding: const EdgeInsets.all(24), decoration: PremiumUI.cardDecoration(context),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextFormField(decoration: PremiumUI.inputDecoration(context, 'Name of the head: *'), validator: (v) => v!.isEmpty ? 'Required' : null),
              const SizedBox(height: 16),
              TextFormField(keyboardType: TextInputType.number, inputFormatters: [FilteringTextInputFormatter.digitsOnly], decoration: PremiumUI.inputDecoration(context, 'No of Family Members: *'), validator: (v) => v!.isEmpty ? 'Required' : null),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(child: TextFormField(keyboardType: TextInputType.number, decoration: PremiumUI.inputDecoration(context, 'Male:'))),
                  const SizedBox(width: 8),
                  Expanded(child: TextFormField(keyboardType: TextInputType.number, decoration: PremiumUI.inputDecoration(context, 'Female:'))),
                  const SizedBox(width: 8),
                  Expanded(child: TextFormField(keyboardType: TextInputType.number, decoration: PremiumUI.inputDecoration(context, 'Others:'))),
                ],
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(decoration: PremiumUI.inputDecoration(context, 'Category: *'), items: ['SC', 'ST', 'OBC', 'MBC', 'General'].map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(), onChanged: (v) {}),
              const SizedBox(height: 24),

              const Text('Ration Card: *', style: TextStyle(fontWeight: FontWeight.bold)),
              Row(children: [
                Expanded(child: RadioListTile(title: const Text('Yes'), value: 'Yes', activeColor: const Color(0xFFF5A623), groupValue: _rationCard, onChanged: (v) => setState(() => _rationCard = v.toString()))),
                Expanded(child: RadioListTile(title: const Text('No'), value: 'No', activeColor: const Color(0xFFF5A623), groupValue: _rationCard, onChanged: (v) => setState(() => _rationCard = v.toString()))),
              ]),
              if (_rationCard == 'Yes') ...[
                DropdownButtonFormField<String>(decoration: PremiumUI.inputDecoration(context, 'Card Type: *'), items: ['NPHH', 'PHH', 'AAY', 'OTHERS'].map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(), onChanged: (v) {}),
                const SizedBox(height: 16),
                TextFormField(decoration: PremiumUI.inputDecoration(context, 'Ration Card No:')),
              ],
              const SizedBox(height: 24),

              const Text('Social Status: *', style: TextStyle(fontWeight: FontWeight.bold)),
              Row(children: [
                Expanded(child: RadioListTile(title: const Text('APL'), value: 'APL', activeColor: const Color(0xFFF5A623), groupValue: _socialStatus, onChanged: (v) => setState(() => _socialStatus = v.toString()))),
                Expanded(child: RadioListTile(title: const Text('BPL'), value: 'BPL', activeColor: const Color(0xFFF5A623), groupValue: _socialStatus, onChanged: (v) => setState(() => _socialStatus = v.toString()))),
              ]),
              if (_socialStatus == 'APL') ...[
                DropdownButtonFormField<String>(decoration: PremiumUI.inputDecoration(context, 'If APL: *'), items: ['EWS', 'LIG', 'MIG', 'HIG'].map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(), onChanged: (v) {}),
              ],
              const SizedBox(height: 24),

              const Text('Living In: *', style: TextStyle(fontWeight: FontWeight.bold)),
              Row(children: [
                Expanded(child: RadioListTile(title: const Text('Own House', style: TextStyle(fontSize: 12)), value: 'Own House', activeColor: const Color(0xFFF5A623), groupValue: _livingIn, onChanged: (v) => setState(() => _livingIn = v.toString()))),
                Expanded(child: RadioListTile(title: const Text('Rental House', style: TextStyle(fontSize: 12)), value: 'Rental House', activeColor: const Color(0xFFF5A623), groupValue: _livingIn, onChanged: (v) => setState(() => _livingIn = v.toString()))),
              ]),
              if (_livingIn == 'Rental House') ...[
                TextFormField(decoration: PremiumUI.inputDecoration(context, 'If Rental, Migration From: *')),
              ],
              const SizedBox(height: 24),

              // RESTORED FIELDS
              const Text('Type Of House: *', style: TextStyle(fontWeight: FontWeight.bold)),
              Wrap(
                children: ['Kutcha', 'Semi Pucca', 'Pucca', 'Homeless'].map((type) {
                  return SizedBox(width: MediaQuery.of(context).size.width / 2 - 40, child: RadioListTile(title: Text(type, style: const TextStyle(fontSize: 12)), value: type, activeColor: const Color(0xFFF5A623), groupValue: _houseType, onChanged: (v) => setState(() => _houseType = v.toString())));
                }).toList(),
              ),
              const SizedBox(height: 16),
              TextFormField(keyboardType: TextInputType.number, decoration: PremiumUI.inputDecoration(context, 'Annual Income: *'), validator: (v) => v!.isEmpty ? 'Required' : null),
            ],
          ),
        ),
      ],
    );
  }
}

// ==========================================
// PAGE 4: FAMILY MEMBERS (100% COMPLETE)
// ==========================================
class Page4FamilyMembers extends StatefulWidget {
  const Page4FamilyMembers({Key? key}) : super(key: key);
  @override
  _Page4FamilyMembersState createState() => _Page4FamilyMembersState();
}
class _Page4FamilyMembersState extends State<Page4FamilyMembers> {
  List<Map<String, dynamic>> members = [{'shg': 'No', 'disabled': 'No'}];

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(24),
      children: [
        ...members.asMap().entries.map((entry) {
          int index = entry.key;
          return Container(
            margin: const EdgeInsets.only(bottom: 24),
            padding: const EdgeInsets.all(24),
            decoration: PremiumUI.cardDecoration(context),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6), decoration: BoxDecoration(color: const Color(0xFFF5A623).withOpacity(0.1), borderRadius: BorderRadius.circular(20)), child: Text('Member ${index + 1}', style: const TextStyle(color: Color(0xFFF5A623), fontWeight: FontWeight.bold))),
                    if (index != 0) IconButton(icon: const Icon(Icons.delete_outline, color: Colors.redAccent), onPressed: () => setState(() => members.removeAt(index)))
                  ],
                ),
                const SizedBox(height: 20),
                TextFormField(decoration: PremiumUI.inputDecoration(context, 'Name: *'), validator: (v) => v!.isEmpty ? 'Required' : null),
                const SizedBox(height: 16),
                TextFormField(keyboardType: TextInputType.number, decoration: PremiumUI.inputDecoration(context, 'Age: *'), validator: (v) => v!.isEmpty ? 'Required' : null),
                const SizedBox(height: 16),
                DropdownButtonFormField<String>(decoration: PremiumUI.inputDecoration(context, 'Gender: *'), items: ['Male', 'Female', 'Other'].map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(), onChanged: (v) {}),
                const SizedBox(height: 16),

                // RESTORED FIELDS
                DropdownButtonFormField<String>(decoration: PremiumUI.inputDecoration(context, 'Marital Status:'), items: ['Not Married', 'Married', 'Widowed', 'Divorced'].map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(), onChanged: (v) {}),
                const SizedBox(height: 16),
                DropdownButtonFormField<String>(decoration: PremiumUI.inputDecoration(context, 'Level of Education:'), items: ['01. Literate', '05. Class 12th', 'Graduate', 'Post Graduate'].map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(), onChanged: (v) {}),
                const SizedBox(height: 16),

                TextFormField(
                  keyboardType: TextInputType.number, inputFormatters: [FilteringTextInputFormatter.digitsOnly, LengthLimitingTextInputFormatter(12)],
                  decoration: PremiumUI.inputDecoration(context, 'Member Aadhar (12 Digits): *'),
                  validator: (val) => (val != null && val.length == 12) ? null : '12 digits required',
                ),
                const SizedBox(height: 16),
                DropdownButtonFormField<String>(decoration: PremiumUI.inputDecoration(context, 'Do you have a Ration Card? *'), items: ['Yes', 'No'].map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(), onChanged: (v) {}),
                const SizedBox(height: 16),
                DropdownButtonFormField<String>(decoration: PremiumUI.inputDecoration(context, 'Do you have a Bank Account? *'), items: ['Yes', 'No'].map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(), onChanged: (v) {}),
                const SizedBox(height: 16),

                TextFormField(
                  keyboardType: TextInputType.number, inputFormatters: [FilteringTextInputFormatter.digitsOnly, LengthLimitingTextInputFormatter(10)],
                  decoration: PremiumUI.inputDecoration(context, 'Member Mobile (10 Digits): *'),
                  validator: (val) => (val != null && val.length == 10) ? null : '10 digits required',
                ),
                const SizedBox(height: 16),
                DropdownButtonFormField<String>(decoration: PremiumUI.inputDecoration(context, 'Present Status of Employment: *'), items: ['Employed', 'Unemployed', 'Student', 'Housewife'].map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(), onChanged: (v) {}),
                const SizedBox(height: 16),

                DropdownButtonFormField<String>(
                  decoration: PremiumUI.inputDecoration(context, 'Is she a member of a SHG? *'),
                  items: ['Yes', 'No'].map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
                  onChanged: (v) => setState(() => members[index]['shg'] = v!),
                ),
                if (members[index]['shg'] == 'Yes') ...[
                  const SizedBox(height: 16), TextFormField(decoration: PremiumUI.inputDecoration(context, 'Name of the SHG: *')),
                  const SizedBox(height: 16), TextFormField(decoration: PremiumUI.inputDecoration(context, 'Activity done by the SHG: *')),
                ],
                const SizedBox(height: 16),

                DropdownButtonFormField<String>(
                  decoration: PremiumUI.inputDecoration(context, 'Physically Challenged: *'),
                  items: ['Yes', 'No'].map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
                  onChanged: (v) => setState(() => members[index]['disabled'] = v!),
                ),
                if (members[index]['disabled'] == 'Yes') ...[
                  const SizedBox(height: 16), TextFormField(decoration: PremiumUI.inputDecoration(context, 'Nature of Disability: *')),
                  const SizedBox(height: 16), DropdownButtonFormField<String>(decoration: PremiumUI.inputDecoration(context, 'Presently having ID Card for Phy. Challenged: *'), items: ['Yes', 'No'].map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(), onChanged: (v) {}),
                ],
                const SizedBox(height: 16),
                DropdownButtonFormField<String>(decoration: PremiumUI.inputDecoration(context, 'CM Comprehensive Health Insurance: *'), items: ['Yes', 'No'].map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(), onChanged: (v) {}),
              ],
            ),
          );
        }).toList(),

        InkWell(
          onTap: () => setState(() => members.add({'shg': 'No', 'disabled': 'No'})),
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 16),
            decoration: BoxDecoration(color: Theme.of(context).cardColor, borderRadius: BorderRadius.circular(15), border: Border.all(color: const Color(0xFFF5A623), width: 1.5)),
            child: const Row(mainAxisAlignment: MainAxisAlignment.center, children: [Icon(Icons.person_add_alt_1, color: Color(0xFFF5A623)), SizedBox(width: 8), Text('ADD ANOTHER FAMILY MEMBER', style: TextStyle(color: Color(0xFFF5A623), fontWeight: FontWeight.bold))]),
          ),
        ),
      ],
    );
  }
}