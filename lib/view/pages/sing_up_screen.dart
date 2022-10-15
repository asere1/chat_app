import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
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

      final imageToFireBase = File(imageFromPhon!.path);
      final firebaseStorage = FirebaseStorage.instance;
      var snapshot = await firebaseStorage
          .ref()
          .child('files/${imageFromPhon!.name}')
          .putFile(imageToFireBase);

      var downloadUrl = await snapshot.ref.getDownloadURL();

      await _firestore
          .collection('users')
          .doc(newUser.user!.uid)
          .set({'name': _userController.text, 'image': downloadUrl});

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
  File? image;
  XFile? imageFromPhon;

  Future pickImage() async {
    try {
      final imageFromPhon =
          await ImagePicker().pickImage(source: ImageSource.gallery);
      final imageToView = File(imageFromPhon!.path);

      setState(() {
        image = imageToView;
        this.imageFromPhon = imageFromPhon;
      });
    } on PlatformException catch (e) {
      MainDialog(context: context, title: "Erorr", content: e.toString())
          .showAlertDialog();
    }
  }

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
          color: Colors.greenAccent,
          inAsyncCall: showSpinner,
          child: Center(
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisSize: MainAxisSize.max,
                children: [
                  Stack(
                    alignment: Alignment.bottomCenter,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(bottom: 60),
                        child: SizedBox(
                          child: Image.asset(Images.logoImg),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(bottom: 10),
                        child: Align(
                          alignment: Alignment.bottomCenter,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Stack(
                                alignment: Alignment.bottomRight,
                                children: [
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(360),
                                    child: SizedBox(
                                      width: 90,
                                      height: 90,
                                      child: image == null
                                          ? Image.asset(
                                              Images.grey,
                                              width: 90,
                                              height: 90,
                                              fit: BoxFit.cover,
                                            )
                                          : Image.file(
                                              image!,
                                              width: 90,
                                              height: 90,
                                              fit: BoxFit.cover,
                                            ),
                                    ),
                                  ),
                                  SizedBox(
                                    width: 30,
                                    height: 30,
                                    child: DecoratedBox(
                                      decoration: const BoxDecoration(
                                          shape: BoxShape.circle,
                                          color: Colors.greenAccent),
                                      child: InkWell(
                                        borderRadius: BorderRadius.circular(30),
                                        onTap: () {
                                          pickImage();
                                        },
                                        child: const Icon(
                                          Icons.camera_alt,
                                          color: Colors.white,
                                          size: 20,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 30),
                    child: TextFormField(
                      keyboardType: TextInputType.emailAddress,
                      textAlign: TextAlign.center,
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
                    onPressed: () {
                      if (imageFromPhon == null) return;
                      singIn();
                    },
                  ),
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
