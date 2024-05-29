
import 'package:flutter/material.dart';
import 'package:upstyleapp/screen/customer_login_screen.dart';
import 'package:upstyleapp/screen/designer_login_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  String selectedRole = 'Customer';
  Color selectedColor = const Color.fromARGB(255, 238, 99, 56);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios,
            color: Colors.black,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Container(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Tell us who you are?",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w500,
                color: Colors.black,
                fontFamily: 'ProductSansMedium',
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              'Lorem Ipsum is simply dummy text of the printing and typesetting industry.',
              style: TextStyle(
                fontSize: 14,
                color: Color.fromARGB(255, 150, 150, 150),
                fontWeight: FontWeight.normal,
                fontFamily: 'Subtitle',
              ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                GestureDetector(
                  onTap: () {
                    setState(() {
                      selectedRole = 'Designer';
                      selectedColor = const Color.fromARGB(255, 238, 99, 56);
                    });
                  },
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    margin: const EdgeInsets.only(
                      right: 8,
                      top: 16,
                      bottom: 16,
                    ),
                    decoration: BoxDecoration(
                      borderRadius: const BorderRadius.all(
                        Radius.circular(16),
                      ),
                      color: selectedRole == 'Designer'
                          ? selectedColor
                          : Colors.white,
                    ),
                    child: Column(
                      children: [
                        const Text(
                          'I am a Designer',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: Colors.black,
                            fontFamily: 'ProductSansMedium',
                          ),
                        ),
                        const SizedBox(height: 8),
                        Image.asset('assets/images/designer.png'),
                      ],
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    setState(() {
                      selectedRole = 'Customer';
                      selectedColor = const Color.fromARGB(255, 238, 99, 56);
                    });
                  },
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    margin: const EdgeInsets.only(
                      left: 8,
                      top: 16,
                      bottom: 16,
                    ),
                    decoration: BoxDecoration(
                      borderRadius: const BorderRadius.all(
                        Radius.circular(16),
                      ),
                      color: selectedRole == 'Customer'
                          ? selectedColor
                          : Colors.white,
                    ),
                    child: Column(
                      children: [
                        const Text(
                          'I am a Customer',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: Colors.black,
                            fontFamily: 'ProductSansMedium',
                          ),
                        ),
                        const SizedBox(height: 8),
                        Image.asset('assets/images/customer.png'),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            ElevatedButton(
              onPressed: () {
                if (selectedRole == 'Customer') {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const CustomerLoginScreen(),
                    ),
                  );
                } else if (selectedRole == 'Designer') {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const DesignerLoginScreen(),
                    ),
                  );
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: selectedColor,
                minimumSize: const Size(double.infinity, 48),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: Text(
                "Continue as $selectedRole",
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
