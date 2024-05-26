import 'package:flutter/material.dart';
import 'package:upstyleapp/screen/login_screen.dart';
import 'package:upstyleapp/screen/register_screen.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          color: Color.fromARGB(
            255,
            238,
            99,
            56,
          ),
          image: DecorationImage(
            image: AssetImage("assets/images/OBJECTS.png"),
            fit: BoxFit.cover,
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                height: 302,
                width: 284,
                decoration: const BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage("assets/images/image 7.png"),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.all(16),
                margin: const EdgeInsets.all(16),
                decoration: const BoxDecoration(
                  borderRadius: BorderRadius.all(
                    Radius.circular(16),
                  ),
                  color: Color.fromARGB(255, 255, 255, 255),
                ),
                child: Column(
                  children: [
                    const SizedBox(height: 8),
                    RichText(
                      textAlign: TextAlign.center,
                      text: const TextSpan(
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.w500,
                          color: Colors.black, // Default text color
                          fontFamily: 'ProductSansMedium',
                        ),
                        children: [
                          TextSpan(text: 'Find the '),
                          TextSpan(
                            text: 'designer',
                            style: TextStyle(
                              color: Color.fromARGB(
                                255,
                                238,
                                99,
                                56,
                              ), // Color for 'designer'
                              fontFamily:
                                  'ProductSansMedium', // Font for 'designer
                            ),
                          ),
                          TextSpan(text: ' that \n fits your vision'),
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 16,
                    ), // Add some space between the texts
                    const Center(
                      child: Text(
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 14,
                          color: Color.fromARGB(255, 150, 150, 150),
                          fontWeight: FontWeight.normal,
                          fontFamily: 'Subtitle',
                        ),
                        "Lorem Ipsum is simply dummy text of the printing and typesetting industry.",
                      ),
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => LoginScreen(),
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color.fromARGB(255, 238, 99, 56),
                        minimumSize: const Size(double.infinity, 48),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: const Text(
                        "Login",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => RegisterScreen(),
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        minimumSize: const Size(double.infinity, 48),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        //tolong tambahkan outlien berwarna Color.fromARGB(255, 238, 99, 56)
                        side: const BorderSide(
                          color: Color.fromARGB(255, 238, 99, 56),
                        ),
                      ),
                      child: const Text(
                        "Register",
                        style: TextStyle(
                          color: Color.fromARGB(255, 238, 99, 56),
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
