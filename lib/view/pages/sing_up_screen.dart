import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:new_chat_app/utilits/navigations.dart';
import 'package:new_chat_app/view/widgets/button_widget.dart';
import 'package:new_chat_app/view/widgets/main_dialog.dart';
import '../../utilits/Images.dart';

class SingUpScreen extends StatefulWidget {
  const SingUpScreen({Key? key}) : super(key: key);

  @override
  State<SingUpScreen> createState() => _SingUpScreenState();
}

class _SingUpScreenState extends State<SingUpScreen> {
  final _firestore = FirebaseFirestore.instance;
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _userController = TextEditingController();
  final _passwordController = TextEditingController();
  final _emailFocusNode = FocusNode();
  final _userFocusNode = FocusNode();
  Future singIn() async {
    setState(() {
      showSpinner = true;
    });
    try {
      final newUser = await _auth.createUserWithEmailAndPassword(
          email: _emailController.text.trim(),
          password: _passwordController.text.trim());

      await _firestore
          .collection('users')
          .doc(newUser.user!.uid)
          .set({'name': _userController.text});
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

  final _passwordFocusNode = FocusNode();

  final _auth = FirebaseAuth.instance;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _userController.dispose();
    super.dispose();
  }

  bool showSpinner = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
          child: Form(
        key: _formKey,
        child: ModalProgressHUD(
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
                      keyboardType: TextInputType.emailAddress,
                      textAlign: TextAlign.center,
                      // autovalidateMode: AutovalidateMode.always,
                      onEditingComplete: () =>
                          FocusScope.of(context).requestFocus(_emailFocusNode),
                      textInputAction: TextInputAction.next,
                      focusNode: _userFocusNode,
                      controller: _userController,
                      validator: ((val) =>
                          val!.isEmpty ? 'Please enter your Name' : null),
                      decoration: const InputDecoration(
                        contentPadding:
                            EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                        hintText: 'Enter your Name !',
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.all(
                          Radius.circular(30),
                        )),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.all(
                            Radius.circular(30),
                          ),
                          borderSide: BorderSide(
                            color: Colors.black,
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.all(
                            Radius.circular(30),
                          ),
                          borderSide:
                              BorderSide(color: Colors.greenAccent, width: 2),
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
                      keyboardType: TextInputType.emailAddress,
                      textAlign: TextAlign.center,
                      // autovalidateMode: AutovalidateMode.always,
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
                            color: Colors.black,
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.all(
                            Radius.circular(30),
                          ),
                          borderSide:
                              BorderSide(color: Colors.greenAccent, width: 2),
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
                      // autovalidateMode: AutovalidateMode.always,
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
                            color: Colors.black,
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.all(
                            Radius.circular(30),
                          ),
                          borderSide:
                              BorderSide(color: Colors.greenAccent, width: 2),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Button(
                      color: Colors.greenAccent,
                      title: 'Sing Up',
                      onPressed: singIn),
                  const SizedBox(
                    height: 8,
                  ),
                  InkWell(
                    onTap: () => Navigator.of(context)
                        .pushReplacementNamed(AppRouts.logeScreen),
                    child: Text('Already have an account !',
                        style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                            color: Colors.black, fontWeight: FontWeight.w700)),
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
