import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:notification_app/screens/login.dart';
import 'package:permission_handler/permission_handler.dart';
import 'screens/principal/principalhome.dart';
import 'screens/students/home.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await requestNotificationPermission();
  await AwesomeNotifications().initialize('resource://drawable/ic_launcher', [
    NotificationChannel(
        channelKey: 'basic_channel',
        channelName: 'Basic Notifications',
        channelDescription: 'Notification channel for basic notifications')
  ]);

  User? user = FirebaseAuth.instance.currentUser;

  runApp(MyApp(user: user));
}

class MyApp extends StatelessWidget {
  final User? user;
  const MyApp({Key? key, required this.user}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Check if the user is logged in and their email is principal's email
    if (user != null && user!.email == 'principal@cmscollege.ac.in') {
      return MaterialApp(
        title: 'Quick Link',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
          bottomNavigationBarTheme: const BottomNavigationBarThemeData(
            backgroundColor: Color(0xFFD1C3DB),
          ),
        ),
        home: PrincipalHome(user: user),
        debugShowCheckedModeBanner: false,
      );
    } else {
      return MaterialApp(
        title: 'Quick Link',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
          bottomNavigationBarTheme: const BottomNavigationBarThemeData(
            backgroundColor: Color(0xFFD1C3DB),
          ),
        ),
        home:
            user != null ? HomePage(userEmail: user!.email) : const LoginPage(),
        debugShowCheckedModeBanner: false,
      );
    }
  }
}

Future<void> requestNotificationPermission() async {
  var status = await Permission.notification.status;
  if (!status.isGranted) {
    await Permission.notification.request();
  }
}
