import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:new_chat_app/utilits/classes.dart';
import 'package:new_chat_app/view/widgets/button_widget.dart';

import '../../utilits/navigations.dart';
import '../widgets/main_dialog.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final snackBar = SnackBar(
      elevation: 22,
      clipBehavior: Clip.antiAliasWithSaveLayer,
      margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      behavior: SnackBarBehavior.floating,
      shape: const StadiumBorder(),
      backgroundColor: Colors.black.withOpacity(.7),
      padding: const EdgeInsets.all(8),
      content: Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.center,
        children: const [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 10),
            child: Text(
              'You can\'t change it ',
              style: TextStyle(
                fontSize: 24,
              ),
            ),
          ),
        ],
      ));

  Future logOut() async {
    try {
      setState(() {
        showSpinner = true;
      });
      await _auth.signOut();

      Navigator.of(context).popAndPushNamed(AppRouts.wellcomeScreen);
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
  final _firestore = FirebaseFirestore.instance;
  bool showSpinner = false;
  String imageToPhone = "";
  final name = TextEditingController();

  Future pickImage() async {
    try {
      final imageFromPhon =
          await ImagePicker().pickImage(source: ImageSource.gallery);
      final imageToFireBase = File(imageFromPhon!.path);
      final firebaseStorage = FirebaseStorage.instance;
      var snapshot = await firebaseStorage
          .ref()
          .child('files/${imageFromPhon.name}')
          .putFile(imageToFireBase);

      var downloadUrl = await snapshot.ref.getDownloadURL();

      await _firestore
          .collection('users')
          .doc(_auth.currentUser!.uid)
          .update({'image': downloadUrl});
      setState(() {
        imageToPhone = imageFromPhon.path;
      });
    } on PlatformException catch (e) {
      MainDialog(context: context, title: "Erorr", content: e.toString())
          .showAlertDialog();
    }
  }

  Future updateUserName() async {
    try {
      await _firestore
          .collection('users')
          .doc(_auth.currentUser!.uid)
          .update({'name': name.text});
      setState(() {
        nameToDisplay = name.text;
      });
    } catch (e) {
      MainDialog(context: context, title: "Erorr", content: e.toString())
          .showAlertDialog();
    }
  }

  void bottomSheet(BuildContext context, String? hint) {
    showModalBottomSheet<void>(
      backgroundColor: Colors.grey.shade400,
      isScrollControlled: true,
      context: context,
      builder: (BuildContext context) {
        return SingleChildScrollView(
          child: Container(
            margin: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom),
            color: Colors.greenAccent,
            child: Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Align(
                      alignment: Alignment.topLeft,
                      child: Padding(
                        padding: const EdgeInsets.only(top: 15),
                        child: Text(
                          'Enter your name',
                          style: Theme.of(context)
                              .textTheme
                              .bodyLarge!
                              .copyWith(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 17,
                                  color: Colors.white),
                        ),
                      ),
                    ),
                    TextField(
                      cursorColor: Colors.grey,
                      controller: name,
                      keyboardType: TextInputType.name,
                      textAlign: TextAlign.start,
                      decoration: InputDecoration(
                          focusedBorder: const UnderlineInputBorder(
                              borderSide: BorderSide(color: Colors.green)),
                          enabledBorder: const UnderlineInputBorder(
                              borderSide: BorderSide(color: Colors.green)),
                          contentPadding: const EdgeInsets.symmetric(
                              vertical: 10, horizontal: 20),
                          hintText: hint),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: InkWell(
                              onTap: () {
                                name.clear();
                                Navigator.pop(context);
                              },
                              child: Text(
                                'CANSEL',
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyLarge!
                                    .copyWith(
                                        color: Colors.black, fontSize: 15),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: InkWell(
                              onTap: () {
                                // name.clear();
                                updateUserName();
                                Navigator.pop(context);
                              },
                              child: Text(
                                'SAVE',
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyLarge!
                                    .copyWith(
                                        color: Colors.black, fontSize: 15),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  late String imageToView =
      'https://firebasestorage.googleapis.com/v0/b/new-chat-app-aser.appspot.com/o/files%2Fgrey.png?alt=media&token=4a633944-f785-40f2-bb32-c19c79948459';
  String nameToDisplay = '';
  void userImage() async {
    final userImage = await _firestore
        .collection('users')
        .doc(_auth.currentUser!.uid)
        .get()
        .then(
      (DocumentSnapshot doc) {
        final data = doc.data() as Map<String, dynamic>;
        return data['image'];
      },
    );
    setState(() {
      imageToView = userImage;
    });
  }

  void userName() async {
    final username = await _firestore
        .collection('users')
        .doc(_auth.currentUser!.uid)
        .get()
        .then(
      (DocumentSnapshot doc) {
        final data = doc.data() as Map<String, dynamic>;
        return data['name'];
      },
    );
    setState(() {
      nameToDisplay = username;
    });
  }

  @override
  void initState() {
    userImage();
    userName();
    super.initState();
  }

  @override
  void dispose() {
    name.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final args =
        ModalRoute.of(context)!.settings.arguments as ProfileScreenArguments;
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Profile',
          style: Theme.of(context).textTheme.titleLarge!.copyWith(
                color: Colors.white,
              ),
        ),
        backgroundColor: Colors.greenAccent,
      ),
      body: Align(
        alignment: Alignment.center,
        child: ModalProgressHUD(
          inAsyncCall: showSpinner,
          child: SingleChildScrollView(
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(20),
                    child: Stack(
                      alignment: Alignment.bottomRight,
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(360),
                          child: Container(
                            color: Colors.grey,
                            width: 150,
                            height: 150,
                            child: imageToPhone != ''
                                ? Image.file(
                                    File(imageToPhone),
                                    width: 150,
                                    height: 150,
                                    fit: BoxFit.cover,
                                  )
                                : Image.network(
                                    imageToView,
                                    width: 150,
                                    height: 150,
                                    fit: BoxFit.cover,
                                  ),
                          ),
                        ),
                        SizedBox(
                          width: 40,
                          height: 40,
                          child: DecoratedBox(
                            decoration: const BoxDecoration(
                                shape: BoxShape.circle,
                                color: Colors.greenAccent),
                            child: InkWell(
                              borderRadius: BorderRadius.circular(30),
                              onTap: pickImage,
                              child: const Icon(
                                Icons.camera_alt,
                                color: Colors.white,
                                size: 23,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Expanded(
                        child: InkWell(
                          splashColor: Colors.greenAccent.withOpacity(.3),
                          onTap: () {
                            bottomSheet(context, nameToDisplay);
                          },
                          child: ListTile(
                            leading: const Icon(
                              Icons.account_circle_rounded,
                              size: 30,
                            ),
                            subtitle: Text(
                              nameToDisplay,
                              style: Theme.of(context)
                                  .textTheme
                                  .displaySmall!
                                  .copyWith(
                                    color: Colors.black,
                                    fontSize: 20,
                                    fontWeight: FontWeight.normal,
                                  ),
                            ),
                            title: Text(
                              'Name',
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyLarge!
                                  .copyWith(
                                      color: Colors.black.withOpacity(.55),
                                      fontSize: 17),
                            ),
                            trailing: const Icon(
                              Icons.change_circle_rounded,
                              size: 28,
                              color: Colors.greenAccent,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  Divider(
                    indent: size.width * .17,
                    color: Colors.greenAccent,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Expanded(
                        child: InkWell(
                          splashColor: Colors.greenAccent.withOpacity(.3),
                          onTap: () {
                            ScaffoldMessenger.of(context)
                                .showSnackBar(snackBar);
                          },
                          child: ListTile(
                            leading: const Icon(
                              Icons.email_rounded,
                              size: 30,
                            ),
                            subtitle: Text(
                              "${args.email}",
                              style: Theme.of(context)
                                  .textTheme
                                  .displaySmall!
                                  .copyWith(
                                    color: Colors.black,
                                    fontSize: 20,
                                    fontWeight: FontWeight.normal,
                                  ),
                            ),
                            title: Text(
                              'Email',
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyLarge!
                                  .copyWith(
                                      color: Colors.black.withOpacity(.55),
                                      fontSize: 17),
                            ),
                            trailing: const Icon(
                              Icons.change_circle_rounded,
                              size: 28,
                              color: Colors.greenAccent,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: size.height * (1 / 4)),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 20),
                    child: Button(
                      color: Colors.greenAccent,
                      title: " Log Out",
                      onPressed: logOut,
                    ),
                  )
                ]),
          ),
        ),
      ),
    );
  }
}
