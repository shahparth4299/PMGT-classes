// ignore_for_file: avoid_print

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pmgt/screens/home.dart';
import 'package:pmgt/services/auth.dart';
import 'package:pmgt/widgets/constants.dart';
import 'package:pmgt/widgets/roundedbutton.dart';
import 'package:pmgt/widgets/textfieldcontainer.dart';

class LoginPage extends StatefulWidget {
  final Function? toggleView;

  const LoginPage({this.toggleView, Key? key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool _isObscure = true;
  String _errorMessage = '';

  final _formKey = GlobalKey<FormState>();
  AuthService authService = AuthService();

  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();

  Future signIn() async {
    if (_formKey.currentState!.validate()) {
      try {
        await authService.signInPlay(email.text, password.text).then((value) {
          print(value);
          if (value != 'error') {
            Navigator.pushReplacement(
                context, MaterialPageRoute(builder: (context) => const Home()));
          }
        }).catchError((err) {
          print(err);
          setState(() {
            _errorMessage = err;
          });
        });
      } catch (e) {
        print(e);
      }
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(_errorMessage),
          duration: const Duration(milliseconds: 300),
        ),
      );
    }
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return SafeArea(
      child: Scaffold(
        body: SizedBox(
          height: size.height,
          width: double.infinity,
          child: Stack(
            alignment: Alignment.center,
            children: [
              Positioned(
                top: 0,
                left: 0,
                child: Image.asset(
                  "assets/main_top.png",
                  width: size.width * 0.35,
                ),
              ),
              Positioned(
                bottom: 0,
                right: 0,
                child: Image.asset(
                  "assets/login_bottom.png",
                  width: size.width * 0.4,
                ),
              ),
              SingleChildScrollView(
                child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text(
                        "LOGIN",
                        style: GoogleFonts.openSans(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: size.height * 0.03),
                      Image.asset(
                        "assets/logo-removebg.png",
                        height: size.height * 0.35,
                      ),
                      SizedBox(height: size.height * 0.03),
                      TextFieldContainer(
                        child: TextFormField(
                          validator: (val) {
                            return RegExp(
                                        r"^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?)*$")
                                    .hasMatch(val!)
                                ? null
                                : 'Enter valid email';
                          },
                          keyboardType: TextInputType.emailAddress,
                          controller: email,
                          cursorColor: kPrimaryColor,
                          decoration: const InputDecoration(
                            icon: Icon(
                              Icons.person,
                              color: kPrimaryColor,
                            ),
                            hintText: "Email",
                            border: InputBorder.none,
                          ),
                        ),
                      ),
                      TextFieldContainer(
                        child: TextFormField(
                          validator: (val) {
                            return val!.length < 8 || val.isEmpty
                                ? 'Password should not be less than 8'
                                : null;
                          },
                          controller: password,
                          obscureText: _isObscure,
                          cursorColor: kPrimaryColor,
                          decoration: InputDecoration(
                            hintText: "Password",
                            icon: const Icon(
                              Icons.lock,
                              color: kPrimaryColor,
                            ),
                            suffixIcon: IconButton(
                              icon: Icon(
                                _isObscure
                                    ? Icons.visibility
                                    : Icons.visibility_off,
                                color: kPrimaryColor,
                              ),
                              onPressed: () {
                                setState(() {
                                  _isObscure = !_isObscure;
                                });
                              },
                            ),
                            border: InputBorder.none,
                          ),
                        ),
                      ),
                      RoundedButton(
                        text: "LOGIN",
                        press: signIn,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
