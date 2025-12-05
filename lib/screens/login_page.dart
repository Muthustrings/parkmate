import 'package:flutter/material.dart';

import 'package:provider/provider.dart';
import 'package:parkmate/providers/user_provider.dart';
import 'package:parkmate/providers/parking_provider.dart';
import 'package:parkmate/screens/signup_page.dart';
import 'package:parkmate/screens/home_page.dart';
import 'package:parkmate/services/database_helper.dart';
import 'package:parkmate/screens/forgot_password_page.dart';
import 'package:parkmate/models/user_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _phoneController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isLoading = false;
  bool _obscurePassword = true;

  @override
  void dispose() {
    _phoneController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _handleLogin() async {
    final phone = _phoneController.text.trim();
    final password = _passwordController.text.trim();

    if (phone.isEmpty || password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill in all fields')),
      );
      return;
    }

    if (phone.length != 10 || !RegExp(r'^[0-9]+$').hasMatch(phone)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please enter a valid 10-digit phone number'),
        ),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final user = await DatabaseHelper.instance.getUser(phone, password);
      if (user != null) {
        if (mounted) {
          // Save login state
          final prefs = await SharedPreferences.getInstance();
          await prefs.setBool('isLoggedIn', true);
          await prefs.setString('userPhone', phone);

          // Set user in provider
          Provider.of<UserProvider>(context, listen: false).setUser(user);

          // Load user's tickets
          Provider.of<ParkingProvider>(
            context,
            listen: false,
          ).loadTickets(phone);

          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const HomePage()),
          );
        }
      } else {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Invalid phone number or password')),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Error: $e')));
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  Future<void> _handleGoogleSignIn() async {
    setState(() {
      _isLoading = true;
    });

    try {
      // Simulate network delay for "Google Auth"
      await Future.delayed(const Duration(seconds: 1)); // Mocking API call

      // Use a fixed dummy account for Google Sign-In simulation
      // identifying it by a specific phone number (as our DB requires a phone PK)
      const googleUserPhone = "9999999999";
      const googleUserName =
          "Muthu Kannappan"; // Updated name to be more realistic
      const googleUserEmail = "muthukannappan121998@gmail.com";

      // Check if this pseudo-Google user already exists
      User? user = await DatabaseHelper.instance.getUserByPhone(
        googleUserPhone,
      );

      if (user == null) {
        // First time Google Sign-In: Create the account
        user = User(
          phone: googleUserPhone,
          name: googleUserName,
          email: googleUserEmail,
        );
        await DatabaseHelper.instance.createUser(user);
      } else {
        // Validation: Verify/Update email if it doesn't match the new requirement
        // This ensures existing test users get the updated specific email
        if (user.email != googleUserEmail) {
          user = User(
            phone: user.phone,
            name: user.name,
            password: user.password,
            email: googleUserEmail,
          );
          await DatabaseHelper.instance.updateUser(user);
        }
      }

      if (mounted) {
        // PROCEED WITH LOGIN (Same logic as standard login)

        // 1. Save Session
        final prefs = await SharedPreferences.getInstance();
        await prefs.setBool('isLoggedIn', true);
        await prefs.setString('userPhone', user.phone);

        // 2. Update Providers
        final userProvider = Provider.of<UserProvider>(context, listen: false);
        userProvider.setUser(user);

        final parkingProvider = Provider.of<ParkingProvider>(
          context,
          listen: false,
        );
        await parkingProvider.loadTickets(user.phone);

        // 3. Feedback
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Signed in with Google (Simulated)',
              style: TextStyle(
                color: Theme.of(context).colorScheme.onSecondary,
              ),
            ),
            backgroundColor: Theme.of(context).colorScheme.secondary,
          ),
        );

        // 4. Navigate
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const HomePage()),
        );
      }
    } catch (error) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Error signing in: $error',
              style: TextStyle(color: Theme.of(context).colorScheme.onError),
            ),
            backgroundColor: Theme.of(context).colorScheme.error,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      backgroundColor: theme.colorScheme.background,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: SingleChildScrollView(
            // Added SingleChildScrollView to prevent overflow
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                const SizedBox(height: 40), // Add some top spacing
                Image.asset('assets/Logo.png', height: 100),
                const SizedBox(height: 10),
                Text(
                  'ParkMate',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: theme.colorScheme.primary,
                  ),
                ),
                const SizedBox(height: 30),
                Text(
                  'Welcome Back',
                  style: TextStyle(
                    color: theme.colorScheme.onBackground,
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  'Login to continue',
                  style: TextStyle(
                    color: theme.colorScheme.onBackground,
                    fontSize: 18,
                  ),
                ),
                const SizedBox(height: 40),
                Container(
                  decoration: BoxDecoration(
                    color: theme.colorScheme.surface,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: TextField(
                    controller: _phoneController,
                    keyboardType: TextInputType.phone,
                    maxLength: 10,
                    style: TextStyle(color: theme.colorScheme.onSurface),
                    decoration: InputDecoration(
                      prefixIcon: Icon(
                        Icons.phone,
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                      hintText: 'Phone Number',
                      hintStyle: TextStyle(
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                      border: InputBorder.none,
                      contentPadding: const EdgeInsets.symmetric(
                        vertical: 15.0,
                        horizontal: 10.0,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 15),
                Container(
                  decoration: BoxDecoration(
                    color: theme.colorScheme.surface,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: TextField(
                    controller: _passwordController,
                    obscureText: _obscurePassword,
                    style: TextStyle(color: theme.colorScheme.onSurface),
                    decoration: InputDecoration(
                      prefixIcon: Icon(
                        Icons.lock_outline,
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                      hintText: 'Password',
                      hintStyle: TextStyle(
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                      border: InputBorder.none,
                      contentPadding: const EdgeInsets.symmetric(
                        vertical: 15.0,
                        horizontal: 10.0,
                      ),
                      suffixIcon: IconButton(
                        icon: Icon(
                          _obscurePassword
                              ? Icons.visibility_off
                              : Icons.visibility,
                          color: theme.colorScheme.onSurfaceVariant,
                        ),
                        onPressed: () {
                          setState(() {
                            _obscurePassword = !_obscurePassword;
                          });
                        },
                      ),
                    ),
                  ),
                ),
                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const ForgotPasswordPage(),
                        ),
                      );
                    },
                    child: Text(
                      'Forgot Password?',
                      style: TextStyle(color: theme.colorScheme.onBackground),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: _isLoading ? null : _handleLogin,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: theme.colorScheme.primary,
                    foregroundColor: theme.colorScheme.onPrimary,
                    minimumSize: const Size(double.infinity, 50),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: _isLoading
                      ? CircularProgressIndicator(
                          color: theme.colorScheme.onPrimary,
                        )
                      : Text(
                          'Login',
                          style: TextStyle(
                            fontSize: 18,
                            color: theme.colorScheme.onPrimary,
                          ),
                        ),
                ),
                const SizedBox(height: 25),
                Row(
                  children: <Widget>[
                    Expanded(
                      child: Divider(color: theme.colorScheme.onBackground),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10.0),
                      child: Text(
                        'OR',
                        style: TextStyle(color: theme.colorScheme.onBackground),
                      ),
                    ),
                    Expanded(
                      child: Divider(color: theme.colorScheme.onBackground),
                    ),
                  ],
                ),
                const SizedBox(height: 25),
                ElevatedButton(
                  onPressed: _handleGoogleSignIn,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: theme.colorScheme.primary,
                    foregroundColor: theme.colorScheme.onPrimary,
                    minimumSize: const Size(double.infinity, 50),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Image.asset(
                        'assets/googleicon.png',
                        height: 24.0,
                        color: theme.colorScheme.onPrimary,
                      ),
                      const SizedBox(width: 10),
                      Text(
                        'Sign in with Google',
                        style: TextStyle(
                          fontSize: 18,
                          color: theme.colorScheme.onPrimary,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 40),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text(
                      'New here?',
                      style: TextStyle(
                        color: theme.colorScheme.onBackground,
                        fontSize: 16,
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const SignUpPage(),
                          ),
                        );
                      },
                      child: Text(
                        'Sign up',
                        style: TextStyle(
                          color: theme.colorScheme.onBackground,
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
      ),
    );
  }
}
