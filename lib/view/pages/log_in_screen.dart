import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

import '../../utilits/Images.dart';
import '../../utilits/navigations.dart';
import '../widgets/button_widget.dart';
import '../widgets/main_dialog.dart';

class LogeInScreen extends StatefulWidget {
  const LogeInScreen({Key? key}) : super(key: key);

  @override
  State<LogeInScreen> createState() => _LogeInScreenState();
}

class _LogeInScreenState extends State<LogeInScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _emailFocusNode = FocusNode();
  final _passwordFocusNode = FocusNode();
  Future logeIn() async {
    setState(() {
      showSpinner = true;
    });
    try {
      await _auth.signInWithEmailAndPassword(
          email: _emailController.text.trim(),
          password: _passwordController.text.trim());
      Navigator.of(context).pushReplacementNamed(AppRouts.chatScreen);
    } catch (e) {
      setState(() {
        showSpinner = false;
      });
      MainDialog(
        context: context,
        title: 'Erorr',
        content: e.toString(),
      ).showAlertDialog();
    }
  }

  final _auth = FirebaseAuth.instance;
  bool showSpinner = false;
  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
          child: Form(
        key: _formKey,
        child: ModalProgressHUD(
          color: Colors.greenAccent,
          inAsyncCall: showSpinner,
          child: Center(
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisSize: MainAxisSize.max,
                children: [
                  SizedBox(
                    child: Image.asset(Images.logoImg),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 30),
                    child: TextFormField(
                      textAlign: TextAlign.center,
                      keyboardType: TextInputType.emailAddress,
                      onEditingComplete: () => FocusScope.of(context)
                          .requestFocus(_passwordFocusNode),
                      textInputAction: TextInputAction.next,
                      focusNode: _emailFocusNode,
                      controller: _emailController,
                      validator: ((val) =>
                          val!.isEmpty ? 'Please enter your email' : null),
                      decoration: const InputDecoration(
                        contentPadding:
                            EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                        hintText: 'Enter your Email !',
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.all(
                          Radius.circular(30),
                        )),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.all(
                            Radius.circular(30),
                          ),
                          borderSide: BorderSide(
                            color: Colors.greenAccent,
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.all(
                            Radius.circular(30),
                          ),
                          borderSide: BorderSide(color: Colors.black, width: 2),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 8,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 30),
                    child: TextFormField(
                      textAlign: TextAlign.center,
                      obscureText: true,
                      focusNode: _passwordFocusNode,
                      controller: _passwordController,
                      validator: ((val) => val!.isEmpty || val.length > 8
                          ? 'Please enter your password'
                          : null),
                      decoration: const InputDecoration(
                        contentPadding:
                            EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                        hintText: 'Enter your Password !',
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.all(
                          Radius.circular(30),
                        )),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.all(
                            Radius.circular(30),
                          ),
                          borderSide: BorderSide(
                            color: Colors.greenAccent,
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.all(
                            Radius.circular(30),
                          ),
                          borderSide: BorderSide(color: Colors.black, width: 2),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Button(
                    color: Colors.black,
                    title: 'Log In',
                    onPressed: logeIn,
                  ),
                  const SizedBox(
                    height: 8,
                  ),
                  InkWell(
                    onTap: () => Navigator.of(context)
                        .pushReplacementNamed(AppRouts.singScreen),
                    child: Text('Don\'t have an account sign up !',
                        style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                            color: Colors.greenAccent,
                            fontWeight: FontWeight.w700)),
                  )
                ],
              ),
            ),
          ),
        ),
      )),
    );
  }
}
