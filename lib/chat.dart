import 'dart:async';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:dash_chat/dash_chat.dart';

class ChatPage extends StatefulWidget {

  final String postID;

  ChatPage({Key key, @required this.postID}) : super (key:  key);

  @override
  _ChatPageState createState() => _ChatPageState(postID);
}

class _ChatPageState extends State<ChatPage> {

  String postID;
  _ChatPageState(this.postID);

  final GlobalKey<DashChatState> _chatViewKey = GlobalKey<DashChatState>();

  final ChatUser user = ChatUser(
    // name: "shevon soyza",
    // firstName: "shevon",
    // lastName: "soyza",
    //uid: "123456789",
    //avatar: "https://www.wrappixel.com/ampleadmin/assets/images/users/4.jpg",
  );

  ///////////////////////////////

  getUSerDetails() async {
    final FirebaseUser userdetails = await FirebaseAuth.instance.currentUser();
    String userid = userdetails.uid.toString();

    DocumentReference documentReference =
        Firestore.instance.collection("Users").document(userid);
    documentReference.get().then((datasnapshot) {
      user.name = datasnapshot.data['firstname'];
      user.firstName = datasnapshot.data['firstname'];
      user.lastName = datasnapshot.data['lastname'];
     // user.avatar = datasnapshot.data['profileimg'];
      user.uid = userid;
    });
  }

  //////////////////////////////////

  final ChatUser otherUser = ChatUser(
    // name: "user2",
    // uid: "25649654",
  );

  List<ChatMessage> messages = List<ChatMessage>();
  var m = List<ChatMessage>();

  var i = 0;

  @override
  void initState() {
    super.initState();
    getUSerDetails();
  }

  void systemMessage() {
    Timer(Duration(milliseconds: 300), () {
      if (i < 6) {
        setState(() {
          messages = [...messages, m[i]];
        });
        i++;
      }
      Timer(Duration(milliseconds: 300), () {
        _chatViewKey.currentState.scrollController
          ..animateTo(
            _chatViewKey.currentState.scrollController.position.maxScrollExtent,
            curve: Curves.easeOut,
            duration: const Duration(milliseconds: 300),
          );
      });
    });
  }

  void onSend(ChatMessage message) async {
    print(message.toJson());
    var documentReference = Firestore.instance
        .collection('chat').document(postID).collection('messages').document(DateTime.now().millisecondsSinceEpoch.toString());

    await Firestore.instance.runTransaction((transaction) async {
      await transaction.set(
        documentReference,
        message.toJson(),
      );
    });
    /* setState(() {
      messages = [...messages, message];
      print(messages.length);
    });

    if (i == 0) {
      systemMessage();
      Timer(Duration(milliseconds: 600), () {
        systemMessage();
      });
    } else {
      systemMessage();
    } */
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        home: Scaffold(
      appBar: AppBar(
        iconTheme: new IconThemeData(color: Colors.black),
              title: Text('Chat/ Comments',
                  style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.w500,
                  )),
              backgroundColor: Colors.white,
              elevation: 0,
              titleSpacing: -10,
              leading: Icon(Icons.question_answer_rounded),
      ),
      body: StreamBuilder(
          stream: Firestore.instance.collection('chat').document(postID).collection('messages').snapshots(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return Center(
                child: CircularProgressIndicator(
                  backgroundColor: Colors.black,
                  valueColor: new AlwaysStoppedAnimation<Color>(Colors.blue),
                ),
              );
            } else {
              List<DocumentSnapshot> items = snapshot.data.documents;
              var messages =
                  items.map((i) => ChatMessage.fromJson(i.data)).toList();
              return Padding(
                  padding: EdgeInsets.all(10),
                  child: DashChat(
                    key: _chatViewKey,
                    inverted: false,
                    onSend: onSend,
                    
                    sendOnEnter: true,
                    textInputAction: TextInputAction.send,
                    user: user,
                    sendButtonBuilder: (Function onSend) {
                      return Container(
                          padding: const EdgeInsets.all(15.0),
                          decoration: BoxDecoration(
                              color: Colors.black, shape: BoxShape.circle),
                          child: InkWell(
                            child: Icon(
                              Icons.send,
                              color: Colors.white,
                            ),
                            onTap: () {
                              onSend();
                            },
                          ));
                    },
                    scrollToBottomStyle: ScrollToBottomStyle(
                      icon: Icons.arrow_drop_down,
                      width: 30,
                      bottom: 65,
                      height: 30,
                      backgroundColor: Colors.blue,
                    ),
                    messageTextBuilder: (String message,
                        [ChatMessage messages]) {
                      return Text(message,
                          style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.w800,
                              fontSize: 15));
                    },
                    messageTimeBuilder: (String message,
                        [ChatMessage messages]) {
                      return Text(message,
                          style: TextStyle(
                              color: Colors.blue,
                              fontWeight: FontWeight.w500,
                              fontSize: 6));
                    },
                    dateBuilder: (String message, [ChatMessage messages]) {
                      return Card(
                          color: Colors.grey[300],
                          child: Padding(
                            padding: EdgeInsets.all(8),
                            child: Text(message,
                                style: TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.w500)),
                          ));
                    },
                    messageImageBuilder: (String message,
                        [ChatMessage messages]) {
                      return Image.network(
                        message,
                        //fit: BoxFit.contain,
                      );
                    },
                    messageContainerDecoration:
                        BoxDecoration(
                            color: Colors.grey[200],
                            shape: BoxShape.rectangle,
                            borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(5.0),
                                topRight: Radius.circular(15.0),
                                bottomLeft: Radius.circular(15.0),
                                bottomRight: Radius.circular(5.0))),
                     inputDecoration: InputDecoration.collapsed(
                         hintText: "  Type Something... "),
                    dateFormat: DateFormat('yyyy-MMM-dd'),
                    timeFormat: DateFormat('HH:mm'),
                    showInputCursor: true,
                    textBeforeImage: true,
                    inputCursorColor: Colors.blue,
                    messages: messages,
                    shouldStartMessagesFromTop: true,
                    showUserAvatar: true,
                    showAvatarForEveryMessage: true,
                    scrollToBottom: true,
                    onPressAvatar: (ChatUser user) {
                      // print("OnPressAvatar: ${user.name}");
                    },
                    onLongPressAvatar: (ChatUser user) {
                     // Fluttertoast.showToast(msg: '${user.name}' + ' | ' + '$userfaculty');
                      //print("OnLongPressAvatar: ${user.name}");
                    },
                    inputMaxLines: 2,
                    messageContainerPadding:
                        EdgeInsets.only(left: 2.0, right: 2.0),
                    alwaysShowSend: true,
                    inputTextStyle:
                        TextStyle(fontSize: 16.0, color: Colors.black),
                    inputContainerStyle: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(35.0),
                      boxShadow: [
                        BoxShadow(
                            offset: Offset(0, 3),
                            blurRadius: 5,
                            color: Colors.grey)
                      ],
                    ),
                    onQuickReply: (Reply reply) {
                      setState(() {
                        messages.add(ChatMessage(
                            text: reply.value,
                            createdAt: DateTime.now(),
                            user: user));

                        messages = [...messages];
                      });

                      Timer(Duration(milliseconds: 300), () {
                        _chatViewKey.currentState.scrollController
                          ..animateTo(
                            _chatViewKey.currentState.scrollController.position
                                .maxScrollExtent,
                            curve: Curves.easeOut,
                            duration: const Duration(milliseconds: 300),
                          );

                        if (i == 0) {
                          systemMessage();
                          Timer(Duration(milliseconds: 600), () {
                            systemMessage();
                          });
                        } else {
                          systemMessage();
                        }
                      });
                    },
                    onLoadEarlier: () {
                      print("laoding...");
                    },
                    shouldShowLoadEarlier: false,
                    showTraillingBeforeSend: true,
                    trailing: <Widget>[
                      IconButton(
                        icon: Icon(Icons.photo_camera),
                        onPressed: () async {
                          File result = await ImagePicker.pickImage(
                            source: ImageSource.gallery,
                            //imageQuality: 100,
                            //maxHeight: 400,
                            //maxWidth: 400,
                          );

                          if (result != null) {
                            final StorageReference storageRef = FirebaseStorage
                                .instance
                                .ref()
                                .child("chat_images");

                            StorageUploadTask uploadTask = storageRef.putFile(
                              result,
                              StorageMetadata(
                                contentType: 'image/jpg',
                              ),
                            );
                            StorageTaskSnapshot download =
                                await uploadTask.onComplete;

                            String url = await download.ref.getDownloadURL();

                            ChatMessage message =
                                ChatMessage(text: "", user: user, image: url);

                            var documentReference = Firestore.instance
                                .collection('messages')
                                .document(DateTime.now()
                                    .millisecondsSinceEpoch
                                    .toString());

                            Firestore.instance
                                .runTransaction((transaction) async {
                              await transaction.set(
                                documentReference,
                                message.toJson(),
                              );
                            });
                          }
                        },
                      )
                    ],
                  ));
            }
          }),
    ));
  }
}
