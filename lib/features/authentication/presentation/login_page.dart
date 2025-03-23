import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart'; // Ensure to import Flutter BLoC
import 'package:pixsy/features/authentication/presentation/components/my_button.dart';
import 'package:pixsy/features/authentication/presentation/components/my_textfield.dart';
import 'package:pixsy/features/authentication/presentation/cubit/authentication_cubit.dart';
import 'package:pixsy/responsive/scaffold_responsive.dart';

class LoginPage extends StatefulWidget {
  final void Function()? onTap; // Use final for better performance
  const LoginPage({super.key, required this.onTap});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final emailController = TextEditingController();
  final pwdController = TextEditingController();

  void login() async {
    final email = emailController.text.toString().trim();
    final password = pwdController.text.toString().trim();

    final authCubit = context.read<AuthenticationCubit>();

    if (email.isNotEmpty && password.isNotEmpty) {
      await authCubit.login(email, password);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter both fields')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthenticationCubit, AuthenticationState>(
      listener: (context, state) {
        if (state is AuthError) {
          // Show error messages in a SnackBar
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.message)),
          );
        }
      },
      builder: (context, state) {
        return ScaffoldResponsive(
          body: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // App Icon
                  Icon(
                    Icons.lock_open_outlined,
                    size: 100,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                  const SizedBox(height: 24),

                  // Welcome text
                  Text(
                    "Welcome back, you've been missed!",
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.primary,
                      fontWeight: FontWeight.w600,
                      fontSize: 18,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 32),

                  // Email TextField
                  MyTextField(
                    Controller: emailController, // Use lowercase 'controller'
                    hint: "Enter email",
                    obscureText: false,
                  ),
                  const SizedBox(height: 16),

                  // Password TextField
                  MyTextField(
                    Controller: pwdController, // Use lowercase 'controller'
                    hint: "Enter password",
                    obscureText: true,
                  ),
                  const SizedBox(height: 12),

                  // Forgot password
                  Align(
                    alignment: Alignment.centerRight,
                    child: TextButton(
                      onPressed: () {
                        // Implement forgot password functionality
                      },
                      child: Text(
                        "Forgot password?",
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.primary,
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Login Button
                  MyButton(
                    text: "Login",
                    onTap: login, // Use the login method defined
                  ),
                  const SizedBox(height: 36),

                  // Divider
                  Row(
                    children: [
                      Expanded(
                        child: Divider(
                          thickness: 1,
                          color: Colors.grey[300],
                        ),
                      ),
                      const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 8),
                        child: Text("OR"),
                      ),
                      Expanded(
                        child: Divider(
                          thickness: 1,
                          color: Colors.grey[300],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 36),

                  // Register Now
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        "Not a member? ",
                        style: TextStyle(fontSize: 14),
                      ),
                      GestureDetector(
                        onTap: widget.onTap, // Call the onTap function
                        child: Text(
                          "Register now",
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.primary,
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
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
      },
    );
  }

  @override
  void dispose() {
    emailController.dispose();
    pwdController.dispose();
    super.dispose();
  }
}
