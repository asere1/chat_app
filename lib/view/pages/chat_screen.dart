import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:new_chat_app/utilits/classes.dart';
import 'package:new_chat_app/utilits/navigations.dart';

import '../../utilits/Images.dart';
import '../widgets/main_dialog.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({Key? key}) : super(key: key);

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final _auth = FirebaseAuth.instance;
  final _firestore = FirebaseFirestore.instance;
  late User singedInUser;
  bool showSpinner = false;
  final messagesText = TextEditingController();
  late String imageUrlProfile;

  void getCurrentUser() {
    try {
      final user = _auth.currentUser;
      if (user != null) {
        singedInUser = user;
        print(singedInUser.email);
      }
    } catch (e) {
      MainDialog(
        context: context,
        title: 'Erorr',
        content: e.toString(),
      ).showAlertDialog();
    }
  }

  String name = '';
  String image = '';

  @override
  void initState() {
    getCurrentUser();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.greenAccent,
        title: Image.asset(
          Images.logoImg,
          height: 80,
          width: 180,
        ),
        actions: [
          IconButton(
            splashRadius: 30,
            iconSize: 27,
            onPressed: () {
              Navigator.of(context).pushNamed(AppRouts.profileScreen,
                  arguments: ProfileScreenArguments(
                      image: image, name: name, email: singedInUser.email));
            },
            icon: const Icon(Icons.more_vert),
          )
        ],
      ),
      body: SafeArea(
          child: ModalProgressHUD(
        color: Colors.greenAccent,
        inAsyncCall: showSpinner,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            StreamBuilder<QuerySnapshot>(
              stream:
                  _firestore.collection('messages').orderBy('time').snapshots(),
              builder: (BuildContext context, snapshot) {
                List<MessageStreem> messageWidgets = [];
                if (snapshot.hasData) {
                  final messages = snapshot.data!.docs.reversed;
                  for (var message in messages) {
                    final messageText = message.get('message');
                    final senderEmail = message.get('email');
                    final userName = message.get('userName');
                    final imageUrl = message.get('imageUrl');

                    final currentUser = singedInUser.email;

                    final messageWidget = MessageStreem(
                      userImage: imageUrl,
                      user: singedInUser,
                      text: messageText,
                      sender: userName,
                      isMe: currentUser == senderEmail,
                    );
                    messageWidgets.add(messageWidget);
                  }
                }

                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                return Expanded(
                  child: ListView(
                    reverse: true,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 10, vertical: 20),
                    children: messageWidgets,
                  ),
                );
              },
            ),
            SizedBox(
              child: DecoratedBox(
                decoration: const BoxDecoration(
                    border: Border(
                  top: BorderSide(color: Colors.greenAccent, width: 2),
                )),
                child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Expanded(
                        child: TextField(
                          textInputAction: TextInputAction.send,
                          controller: messagesText,
                          decoration: const InputDecoration(
                              contentPadding: EdgeInsets.symmetric(
                                vertical: 10,
                                horizontal: 20,
                              ),
                              hintText: 'Write your message here...',
                              border: InputBorder.none),
                        ),
                      ),
                      TextButton(
                        onPressed: () async {
                          if (messagesText.text.isNotEmpty) {
                            try {
                              await _firestore.collection('messages').add({
                                'message': messagesText.text.toString(),
                                'email': singedInUser.email,
                                'time': FieldValue.serverTimestamp(),
                                'userName': await _firestore
                                    .collection('users')
                                    .doc(_auth.currentUser!.uid)
                                    .get()
                                    .then(
                                  (DocumentSnapshot doc) {
                                    final data =
                                        doc.data() as Map<String, dynamic>;
                                    return data['name'];
                                  },
                                ),
                                'imageUrl': await _firestore
                                    .collection('users')
                                    .doc(_auth.currentUser!.uid)
                                    .get()
                                    .then(
                                  (DocumentSnapshot doc) {
                                    final data =
                                        doc.data() as Map<String, dynamic>;
                                    return data['image'];
                                  },
                                ),
                              });
                              messagesText.clear();
                            } catch (e) {
                              MainDialog(
                                context: context,
                                title: 'Erorr',
                                content: e.toString(),
                              ).showAlertDialog();
                            }
                          }
                        },
                        child: Text(
                          'send',
                          style: Theme.of(context)
                              .textTheme
                              .bodyLarge!
                              .copyWith(
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18),
                        ),
                      )
                    ]),
              ),
            )
          ],
        ),
      )),
    );
  }
}

class MessageStreem extends StatelessWidget {
  final dynamic userImage;
  final User user;
  final String text;
  final String sender;
  final bool isMe;
  const MessageStreem(
      {required this.userImage,
      required this.user,
      required this.text,
      required this.sender,
      required this.isMe,
      Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment:
            isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
        children: [
          if (isMe) ...[
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  sender,
                  style: const TextStyle(color: Colors.black, fontSize: 12),
                ),
                const SizedBox(
                  height: 5,
                ),
                ConstrainedBox(
                  constraints: const BoxConstraints(
                    maxWidth: 230,
                  ),
                  child: Material(
                    elevation: 5,
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(30),
                      bottomLeft: Radius.circular(30),
                      bottomRight: Radius.circular(30),
                    ),
                    color: Colors.greenAccent,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 10, horizontal: 20),
                      child: Text(
                        text,
                        style:
                            const TextStyle(fontSize: 16, color: Colors.white),
                        overflow: TextOverflow.fade,
                        softWrap: true,
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 3,
                ),
              ],
            ),
            const SizedBox(
              width: 6,
            ),
            Padding(
              padding: const EdgeInsets.only(top: 17),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  SizedBox(
                    height: 40,
                    width: 40,
                    child: CircleAvatar(
                      backgroundColor: Colors.grey,
                      backgroundImage: NetworkImage(userImage.toString()),
                    ),
                  )
                ],
              ),
            ),
          ] else ...[
            Padding(
              padding: const EdgeInsets.only(top: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  SizedBox(
                    height: 40,
                    width: 40,
                    child: CircleAvatar(
                      backgroundColor: Colors.grey,
                      backgroundImage: NetworkImage(userImage.toString()),
                    ),
                  )
                ],
              ),
            ),
            const SizedBox(
              width: 6,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  sender,
                  style: const TextStyle(color: Colors.black, fontSize: 12),
                ),
                const SizedBox(
                  height: 5,
                ),
                ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 230),
                  child: Material(
                    elevation: 5,
                    borderRadius: const BorderRadius.only(
                      topRight: Radius.circular(30),
                      bottomLeft: Radius.circular(30),
                      bottomRight: Radius.circular(30),
                    ),
                    color: Colors.white,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 10, horizontal: 20),
                      child: Text(
                        text,
                        style:
                            const TextStyle(fontSize: 16, color: Colors.black),
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 3,
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }
}
