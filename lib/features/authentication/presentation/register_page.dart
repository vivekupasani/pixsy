import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pixsy/features/authentication/presentation/components/my_button.dart';
import 'package:pixsy/features/authentication/presentation/components/my_textfield.dart';
import 'package:pixsy/features/authentication/presentation/cubit/authentication_cubit.dart';
import 'package:pixsy/responsive/scaffold_responsive.dart';


class RegisterPage extends StatefulWidget {
  final void Function()? onTap;

  const RegisterPage({super.key, required this.onTap});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final pwdController = TextEditingController();
  final confirmPwdController = TextEditingController();

  void register() async{
    final name= nameController.text.toString().trim();
    final email = emailController.text.toString().trim();
    final password= pwdController.text.toString().trim();
    final confimPassword= confirmPwdController.text.toString().trim();

    final authCubit = context.read<AuthenticationCubit>();

    if(email.isNotEmpty && password.isNotEmpty&& name.isNotEmpty&& confimPassword.isNotEmpty){
      if(password == confimPassword){
     await authCubit.register(name,email, password);
      }
      else{
        ScaffoldMessenger.of(context).showSnackBar(
           const SnackBar(content: Text('Password don\'t match')),
          );
      }

    }
    else{
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
                    Icons.lock_outline,
                    size: 100,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                  const SizedBox(height: 24),

                  // Welcome text
                  Text(
                    "Let's create an account for you",
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.primary,
                      fontWeight: FontWeight.w600,
                      fontSize: 18,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 32),

                  // Name TextField
                  MyTextField(
                    Controller: nameController,
                    hint: "Enter your name",
                    obscureText: false,
                  ),
                  const SizedBox(height: 16),

                  // Email TextField
                  MyTextField(
                    Controller: emailController,
                    hint: "Enter your email",
                    obscureText: false,
                  ),
                  const SizedBox(height: 16),

                  // Password TextField
                  MyTextField(
                    Controller: pwdController,
                    hint: "Enter your password",
                    obscureText: true,
                  ),
                  const SizedBox(height: 16),

                  // Confirm Password TextField
                  MyTextField(
                    Controller: confirmPwdController,
                    hint: "Confirm your password",
                    obscureText: true,
                  ),
                  const SizedBox(height: 24),

                  // Register Button
                  MyButton(
                    text: "Register",
                    onTap: register, 
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

                  // Already have an account? Login
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        "Already have an account? ",
                        style: TextStyle(fontSize: 14),
                      ),
                      GestureDetector(
                        onTap: widget.onTap,
                        child: Text(
                          "Login",
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
}
