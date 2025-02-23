import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:firebase_auth/firebase_auth.dart'; // Add this import
import 'package:newsapp_mm/pages/Signup_page.dart';
import 'package:newsapp_mm/pages/home_page.dart'; // Add your home page import

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _emailController = TextEditingController(); // Controller for email
  final _passwordController =
      TextEditingController(); // Controller for password
  final FirebaseAuth _auth = FirebaseAuth.instance; // Firebase Auth instance

  Future<void> _login() async {
    try {
      // Sign in with email and password
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );

      // Navigate to home page after successful login
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => HomePage()),
      );
    } on FirebaseAuthException catch (e) {
      // Handle login errors
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Login failed: ${e.message}')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: double.maxFinite,
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/background_image.png'),
            fit: BoxFit.cover,
          ),
        ),
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(15),
            child: Form(
              child: Column(
                children: [
                  const SizedBox(height: 100),
                  Image.asset(
                    'assets/images/logo_nobg.png',
                    width: 250.0,
                    height: 250.0,
                  ),
                  Text(
                    "Welcome Back!",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 30,
                      color: Colors.black.withOpacity(0.7),
                    ),
                  ),
                  const Text(
                    "Please, Log In.",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 30,
                      color: Colors.white,
                    ),
                  ),
                  TextFormField(
                    controller: _emailController, // Add controller
                    keyboardType: TextInputType.emailAddress, // Change to email
                    style: const TextStyle(color: Color(0xff3C3C43)),
                    decoration: InputDecoration(
                      contentPadding:
                          const EdgeInsets.symmetric(vertical: 20.0),
                      filled: true,
                      hintText: "Email", // Change hint to Email
                      prefixIcon: IconButton(
                        onPressed: () {},
                        icon: SvgPicture.asset("assets/icons/user_icon.svg"),
                      ),
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                        borderSide: BorderSide.none,
                        borderRadius: BorderRadius.circular(37),
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  TextFormField(
                    controller: _passwordController, // Add controller
                    obscureText: true,
                    keyboardType: TextInputType.text,
                    style: const TextStyle(color: Color(0xff3C3C43)),
                    decoration: InputDecoration(
                      contentPadding:
                          const EdgeInsets.symmetric(vertical: 20.0),
                      filled: true,
                      hintText: "Password",
                      prefixIcon: IconButton(
                        onPressed: () {},
                        icon: SvgPicture.asset("assets/icons/key_icon.svg"),
                      ),
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                        borderSide: BorderSide.none,
                        borderRadius: BorderRadius.circular(37),
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  CupertinoButton(
                    padding: EdgeInsets.zero,
                    child: Container(
                      alignment: Alignment.center,
                      height: 60,
                      decoration: BoxDecoration(
                        color: const Color(0xFFC92B2B),
                        borderRadius: BorderRadius.circular(37),
                      ),
                      child: const Text(
                        "Login",
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                    onPressed: _login, // Call _login function
                  ),
                  const SizedBox(height: 15),
                  SvgPicture.asset('assets/icons/deisgn.svg'),
                  const SizedBox(height: 15),
                  CupertinoButton(
                    padding: EdgeInsets.zero,
                    child: Container(
                      alignment: Alignment.center,
                      height: 60,
                      decoration: BoxDecoration(
                        boxShadow: const [
                          BoxShadow(
                            blurRadius: 45,
                            spreadRadius: 0,
                            color: Color.fromRGBO(201, 43, 43, 0.7),
                            offset: Offset(0, 25),
                          )
                        ],
                        borderRadius: BorderRadius.circular(37),
                        color:
                            const Color.fromRGBO(4, 0, 0, 0.5372549019607843),
                      ),
                      child: const Text(
                        "Sign Up",
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => SignupPage()),
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
