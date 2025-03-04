import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:women_safety/child/bottom_page.dart';
import 'package:women_safety/child/child_login_screen.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:women_safety/db/shared_pref.dart';
import 'package:women_safety/utils/flutter_background_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await MySharedPrefference.init();
  await initializeService();
  runApp(const MyApp());
  // runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        textTheme: GoogleFonts.balooTamma2TextTheme(Theme.of(context).textTheme),
        colorScheme: ColorScheme.fromSeed(seedColor: Color.fromARGB(255, 58, 160, 183)),
        useMaterial3: true,
      ),
      home: const AuthChecker(),
    );
  }
}

class AuthChecker extends StatelessWidget {
  const AuthChecker({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<String?>(
      future: MySharedPrefference.getUserEmail(), // Ensure this method exists
      builder: (BuildContext context, AsyncSnapshot<String?> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else {
          final userEmail = snapshot.data ?? "";

          if (userEmail.isNotEmpty) {
            Fluttertoast.showToast(msg: 'Logged in as: $userEmail');
            return BottomPage(); // Navigate to home page if user email is found
          } else {
            return LoginScreen(); // Show login screen if no user email is found
          }
        }
      },
    );
  }
}
