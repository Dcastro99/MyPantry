import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:inventory_app/components/HelperWidgets/login_textfeilds.dart';
import 'package:inventory_app/components/HelperWidgets/my_textfeilds.dart';
import 'package:inventory_app/pages/forgot_password_page.dart';

class LoginPage extends StatefulWidget {
  final Function togglePages;
  const LoginPage({super.key, required this.togglePages});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  void signUserIn() async {
    showDialog(
        context: context,
        builder: (context) => const Center(
              child: CircularProgressIndicator(),
            ));
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: emailController.text, password: passwordController.text);
      Navigator.pop(context);
    } on FirebaseAuthException catch (e) {
      Navigator.pop(context);

      showErrorMesg(e.code);
    }
  }

  void showErrorMesg(String mesg) {
    showDialog(
        context: context,
        builder: (context) => AlertDialog(
              backgroundColor: const Color.fromARGB(255, 245, 95, 95),
              title: Center(
                  child: Text(
                mesg,
                style: const TextStyle(color: Colors.white),
              )),
            ));
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
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 25.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) {
                                return const ForgotPasswordPage();
                              },
                            ),
                          );
                        },
                        child: const Text(
                          'Forgot Password?',
                          style: TextStyle(
                              color: Color.fromARGB(255, 40, 164, 247)),
                        ),
                      ),
                      const SizedBox(height: 25),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ElevatedButton(
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all<Color>(
                            const Color.fromARGB(255, 73, 112, 130)),
                      ),
                      onPressed: () {
                        signUserIn();
                      },
                      child: const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 20.0),
                        child: Text(
                          'Login',
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
                'Don\'t have an account?',
                style: TextStyle(color: Colors.grey),
              ),
              TextButton(
                onPressed: () {
                  widget.togglePages();
                },
                child: const Text(
                  'Sign Up',
                  style: TextStyle(color: Colors.black),
                ),
              ),
            ],
          ),
        ));
  }
}
