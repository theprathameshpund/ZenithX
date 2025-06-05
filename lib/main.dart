import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:url_launcher/url_launcher.dart';
import 'firebase_options.dart';
import 'package:version2/api/firebase_api.dart';
import 'financial_metrics_page.dart';
import 'News/news_page.dart';
import 'begineers guide/beginners_guide_page.dart';
import 'profile_page.dart';
import 'package:version2/Login/login_page.dart';
import 'home_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Firebase only (essential)
  await Future.wait([
    Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform),
    Hive.initFlutter(),
  ]);

  // Initialize Hive and open only critical boxes
  // Open essential Hive box only
  await Hive.openBox('user_data'); // Essential box only

  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool isDarkMode = false;

  @override
  void initState() {
    super.initState();
    final userBox = Hive.box('user_data');
    isDarkMode = userBox.get('isDarkMode', defaultValue: false);

    // Defer non-critical initialization
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _initializeNonCritical();
    });
  }

  Future<void> _initializeNonCritical() async {
    // Firebase notifications (non-critical for startup)
    await FirebaseApi().initNotifications();

    // Open additional Hive boxes (not essential for startup)
    await Hive.openBox('search_history');
  }

  void toggleDarkMode() {
    setState(() {
      isDarkMode = !isDarkMode;
      Hive.box('user_data').put('isDarkMode', isDarkMode);
    });
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: Hive.box('user_data').listenable(),
      builder: (context, box, widget) {
        return MaterialApp(
          title: 'Stock Analysis App',
          theme: isDarkMode ? ThemeData.dark() : ThemeData.light(),
          home: AuthCheck(toggleDarkMode: toggleDarkMode, isDarkMode: isDarkMode),
        );
      },
    );
  }
}

class AuthCheck extends StatelessWidget {
  final Function toggleDarkMode;
  final bool isDarkMode;

  const AuthCheck({super.key, required this.toggleDarkMode, required this.isDarkMode});

  Future<bool> _checkUserProfile() async {
    User? user = FirebaseAuth.instance.currentUser;
    return user != null;
  }

  @override
  Widget build(BuildContext context) {
    final userBox = Hive.box('user_data');
    final bool isLoggedIn = userBox.get('isLoggedIn', defaultValue: false);
    final bool isFirstTime = userBox.get('isFirstTime', defaultValue: true);

    return FutureBuilder<bool>(
      future: _checkUserProfile(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }
        if (snapshot.hasError || !snapshot.hasData || !snapshot.data!) {
          return const LoginPage();
        }
        if (isFirstTime) {
          userBox.put('isFirstTime', false);
          return const LoginPage();
        }
        if (isLoggedIn) {
          return MainApp(toggleDarkMode: toggleDarkMode, isDarkMode: isDarkMode);
        } else {
          return const LoginPage();
        }
      },
    );
  }
}

class MainApp extends StatefulWidget {
  final Function toggleDarkMode;
  final bool isDarkMode;

  const MainApp({super.key, required this.toggleDarkMode, required this.isDarkMode});

  @override
  _MainAppState createState() => _MainAppState();
}

class _MainAppState extends State<MainApp> {
  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  void _navigateToBeginnersGuide(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const BeginnersGuidePage()),
    );
  }

  Future<void> _logout() async {
    final userBox = Hive.box('user_data');
    await FirebaseAuth.instance.signOut();
    await userBox.clear();
    Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => const LoginPage()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('ZenithX'),
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
              decoration: BoxDecoration(
                color: widget.isDarkMode ? Colors.grey[850] : Colors.purple,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'ZenithX',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                    ),
                  ),
                  const SizedBox(height: 20),
                  GestureDetector(
                    onTap: () {
                      Navigator.pop(context); // Close the drawer
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const ProfilePage()),
                      );
                    },
                    child: const Row(
                      children: [
                        Icon(
                          Icons.account_circle,
                          color: Colors.white,
                          size: 40,
                        ),
                        SizedBox(width: 10),
                        Text(
                          'Profile',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            ListTile(
              leading: const Icon(Icons.brightness_6),
              title: Text(widget.isDarkMode ? 'Light Mode' : 'Dark Mode'),
              onTap: () {
                widget.toggleDarkMode();
                Navigator.of(context).pop();
              },
            ),
            ListTile(
              leading: const Icon(Icons.book),
              title: const Text('Beginner\'s Guide'),
              onTap: () {
                Navigator.pop(context);
                _navigateToBeginnersGuide(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.contact_mail),
              title: const Text('Contact Us'),
              onTap: _openGmail,
            ),
            ListTile(
              leading: const Icon(Icons.privacy_tip),
              title: const Text('Privacy Policy'),
              onTap: _openPrivacyPolicy,
            ),
            ListTile(
              leading: const Icon(Icons.delete),
              title: const Text('Delete Account'),
              onTap: _deleteaccount,
            ),
            ListTile(
              leading: const Icon(Icons.logout),
              title: const Text('Logout'),
              onTap: () async {
                await _logout();
              },
            ),
          ],
        ),
      ),
      body: IndexedStack(
        index: _selectedIndex,
        children: const [
          StockMarketHomePage(),
          // MovingAveragesPage(),
          // CompanyDataPage(),
          FinancialMetricsPage(),
          NewsPage(),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          // BottomNavigationBarItem(icon: Icon(Icons.show_chart), label: 'Moving Average'),
          // BottomNavigationBarItem(icon: Icon(Icons.business), label: 'Company Data'),
          BottomNavigationBarItem(icon: Icon(Icons.monetization_on), label: 'Financial Metrics'),
          BottomNavigationBarItem(icon: Icon(Icons.article), label: 'News'),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: widget.isDarkMode ? Colors.white : Colors.purple,
        unselectedItemColor: widget.isDarkMode ? Colors.white60 : Colors.black54,
        onTap: _onItemTapped,
      ),
    );
  }

  void _openGmail() async {
    final Uri emailUri = Uri(
      scheme: 'mailto',
      path: 'zenithx996@gmail.com',
      query: 'subject=Support Request',
    );

    if (await canLaunchUrl(emailUri)) {
      await launchUrl(emailUri);
    } else {
      _showEmailFallback();
    }
  }

  void _showEmailFallback() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('No Email App Found'),
          content: const Text('Would you like to fill out our support form instead?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () async {
                const String formUrl = 'https://forms.gle/WdH7VxM1DR5NUCWu5';
                final Uri uri = Uri.parse(formUrl);
                if (await canLaunchUrl(uri)) {
                  await launchUrl(uri, mode: LaunchMode.externalApplication);
                } else {
                  _showError('Could not open the form.');
                }
                Navigator.pop(context);
              },
              child: const Text('Open Form'),
            ),
          ],
        );
      },
    );
  }


  void _openPrivacyPolicy() async {
    const String url = 'https://sites.google.com/view/zenithx-financial-learning';
    final Uri uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    } else {
      _showError('Could not open the Privacy Policy.');
    }
  }

  void _deleteaccount() async {
    const String url = 'https://forms.gle/LqBGPqKwxH7Qt9YRA';
    final Uri uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    } else {
      _showError('Could not open Account Deletion form');
    }
  }

  void _showError(String message) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Error'),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }
}
