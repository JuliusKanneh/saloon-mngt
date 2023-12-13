import 'package:flutter/material.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();

  void _loginUser() {
    // Implement user login logic here
    String email = _emailController.text;
    String password = _passwordController.text;
    // You can now use the email and password for authentication or further processing.
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.pink,
        title: Text('Login'),
      ),
      body: Stack(
        children: [
          // Background image
          // Image.asset(
          //   'assets/moriah.jpg', // Replace with the actual path to your background image
          //   fit: BoxFit.cover,
          //   width: double.infinity,
          //   height: double.infinity,
          // ),
          Center(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  TextField(
                    controller: _emailController,
                    decoration: const InputDecoration(labelText: 'Email'),
                  ),
                  TextField(
                    controller: _passwordController,
                    obscureText: true,
                    decoration: InputDecoration(
                      hintText: 'Password',
                      hintStyle: const TextStyle(
                        color: Colors.grey,
                        fontSize: 22,
                        fontWeight: FontWeight.w300,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: const BorderSide(
                          color: Colors.blue,
                          width: 1.5,
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: const BorderSide(
                          color: Colors.blue,
                          width: 3.0,
                        ),
                      ),
                    ),
                    onChanged: (value) {},
                  ),
                  const SizedBox(height: 16.0),
                  ElevatedButton(
                    style: ButtonStyle(
                      backgroundColor:
                          MaterialStateProperty.all<Color>(Colors.blue),
                      foregroundColor:
                          MaterialStateProperty.all<Color>(Colors.white),
                    ),
                    onPressed: _loginUser,
                    child: const Text('Login'),
                  ),
                  TextButton(
                    onPressed: () {},
                    child: const Text("Create an account"),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
