import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  Future<void> _handleSignIn(BuildContext context) async {
    try {
      GoogleSignIn googleSignIn = GoogleSignIn();
      await googleSignIn.signIn();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Signed in with Google')),
      );
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error signing in with Google: $error')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1A439B),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              const Text(
                'Welcome Back',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 10),
              const Text(
                'Login to continue',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                ),
              ),
              const SizedBox(height: 40),
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const TextField(
                  decoration: InputDecoration(
                    prefixIcon: Icon(Icons.mail_outline, color: Colors.grey),
                    hintText: 'Email or Phone',
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.symmetric(vertical: 15.0, horizontal: 10.0),
                  ),
                ),
              ),
              const SizedBox(height: 15),
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const TextField(
                  obscureText: true,
                  decoration: InputDecoration(
                    prefixIcon: Icon(Icons.lock_outline, color: Colors.grey),
                    hintText: 'Password',
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.symmetric(vertical: 15.0, horizontal: 10.0),
                  ),
                ),
              ),
              Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Forgot Password button pressed')),
                    );
                  },
                  child: const Text(
                    'Forgot Password?',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Login button pressed')),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  foregroundColor: Colors.black,
                  minimumSize: const Size(double.infinity, 50),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: const Text(
                  'Login',
                  style: TextStyle(fontSize: 18),
                ),
              ),
              const SizedBox(height: 25),
              const Row(
                children: <Widget>[
                  Expanded(child: Divider(color: Colors.white)),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 10.0),
                    child: Text(
                      'OR',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                  Expanded(child: Divider(color: Colors.white)),
                ],
              ),
              const SizedBox(height: 25),
              ElevatedButton(
                onPressed: () => _handleSignIn(context),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  foregroundColor: Colors.black,
                  minimumSize: const Size(double.infinity, 50),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Image.asset(
                      'assets/googleicon.png', // Make sure you have this asset
                      height: 24.0,
                    ),
                    const SizedBox(width: 10),
                    const Text(
                      'Sign in with Google',
                      style: TextStyle(fontSize: 18),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 40),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  const Text(
                    'New here?',
                    style: TextStyle(color: Colors.white, fontSize: 16),
                  ),
                  TextButton(
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Sign up button pressed')),
                      );
                    },
                    child: const Text(
                      'Sign up',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
