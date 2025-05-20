import 'package:flutter/material.dart';
import 'package:notification_app/services/auth_services.dart';
import 'principal/principalLogin.dart';
import 'students/home.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Padding(
                padding: EdgeInsets.only(left: 20, top: 50),
                child: Text(
                  'Never miss\na single\nnotification',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 42,
                    fontWeight: FontWeight.w400,
                    fontFamily: 'Gilroy',
                  ),
                ),
              ),
              Image.asset('assets/images/Frame 6.png'),
              Padding(
                padding: const EdgeInsets.only(top: 30, bottom: 0),
                child: GestureDetector(
                  onTap: () async {
                    // Sign in with Google using your authentication service
                    await AuthService().signInWithGoogle();

                    String? userEmail = AuthService().getUserEmail();

                    // Navigate to the home page
                    if (userEmail != null) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => HomePage(userEmail: userEmail),
                        ),
                      );
                    } else {
                      // Handle the case where userEmail is null (e.g., show an error message).
                      print('User email is null.');
                    }
                  },
                  child: Container(
                    height: 60,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: const Color(0xff000000),
                      borderRadius: BorderRadiusDirectional.circular(12),
                      border:
                          Border.all(color: const Color(0xff161616), width: 2),
                    ),
                    child: Center(
                      child: RichText(
                        text: const TextSpan(
                          children: [
                            TextSpan(
                              text: 'Login with ',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                                fontFamily: 'Gilroy',
                              ),
                            ),
                            TextSpan(
                              text: 'Google',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                fontFamily: 'Gilroy',
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              TextButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => PrincipalLogin(),
                      ),
                    );
                  },
                  child: Center(
                    child: Text(
                      'Principal Login',
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.40),
                        fontSize: 10,
                        fontWeight: FontWeight.w300,
                        fontFamily: 'Gilroy',
                      ),
                    ),
                  ))
            ],
          ),
        ),
      ),
    );
  }
}
