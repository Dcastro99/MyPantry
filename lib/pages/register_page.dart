import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:inventory_app/components/HelperWidgets/login_textfeilds.dart';

class RegisterPage extends StatefulWidget {
  final Function togglePages;
  const RegisterPage({super.key, required this.togglePages});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  void signUserUp() async {
    showDialog(
        context: context,
        builder: (context) => const Center(
              child: CircularProgressIndicator(),
            ));
    try {
      if (passwordController.text == confirmPasswordController.text) {
        print('Passwords match!');
        await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: emailController.text,
          password: passwordController.text,
        );
      } else {
        Navigator.pop(context); // Close the loading dialog
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text('Error'),
            content: Text('Passwords do not match.'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop(); // Close the dialog
                },
                child: Text('OK'),
              ),
            ],
          ),
        );

        return; // Don't proceed with registration if passwords don't match
      }

      // ignore: use_build_context_synchronously
      showDialog(
        context: context,
        builder: (context) => const Center(
          child: CircularProgressIndicator(),
        ),
      );

      // Continue with successful registration logic here

      Navigator.pop(context); // Close the loading dialog
      Navigator.pop(context); // Close the registration page
    } on FirebaseAuthException catch (e) {
      print('FirebaseAuthException: $e');
      Navigator.pop(context); // Close the loading dialog
      // ignore: use_build_context_synchronously
      showDialog(
          context: context,
          builder: (context) => AlertDialog(
                backgroundColor: const Color.fromARGB(255, 245, 95, 95),
                title: Center(
                    child: Text(
                  e.message.toString(),
                  style: const TextStyle(color: Colors.white),
                )),
              ));
      // Handle authentication exceptions here
    }
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
    return Scaffold(
        backgroundColor: Colors.grey[300],
        body: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              child: Column(children: [
                const SizedBox(height: 25),
                const Image(
                    image: NetworkImage('https://i.imgur.com/cTvQfLy.png'),
                    height: 200),
                const Text(
                  'My Pantry',
                  style: TextStyle(
                    fontSize: 40,
                    fontFamily: 'DancingScript',
                    color: Colors.black,
                  ),
                ),
                const SizedBox(height: 25),
                LoginTextfeild(
                    hintText: 'Email',
                    controller: emailController,
                    obscureText: false),
                const SizedBox(height: 15),
                LoginTextfeild(
                    hintText: 'Password',
                    controller: passwordController,
                    obscureText: true),
                const SizedBox(height: 10),
                LoginTextfeild(
                    hintText: 'Confirm Password',
                    controller: confirmPasswordController,
                    obscureText: true),
                const SizedBox(height: 10),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ElevatedButton(
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all<Color>(
                            const Color.fromARGB(255, 73, 112, 130)),
                      ),
                      onPressed: () {
                        signUserUp();
                      },
                      child: const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 20.0),
                        child: Text(
                          'Sign Up',
                          style: TextStyle(),
                        ),
                      )),
                ),
                const SizedBox(height: 120),
              ]),
            ),
          ),
        ),
        bottomNavigationBar: BottomAppBar(
          color: Colors.grey[300],
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                'Already have an account?',
                style: TextStyle(color: Colors.grey),
              ),
              TextButton(
                onPressed: () {
                  widget.togglePages();
                },
                child: const Text(
                  'Login now',
                  style: TextStyle(color: Colors.black),
                ),
              ),
            ],
          ),
        ));
  }
}
