import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:maps_launcher/maps_launcher.dart';
import 'package:travel_network/addPost.dart';
import 'package:travel_network/chat.dart';
import 'package:travel_network/editPost.dart';
import 'package:travel_network/home.dart';

class ProfileHomeView extends StatefulWidget {
  @override
  _ProfileHomeViewState createState() => _ProfileHomeViewState();
}

class _ProfileHomeViewState extends State<ProfileHomeView> {
  bool checkedValue = false;

  final FirebaseAuth _auth = FirebaseAuth.instance;
  FirebaseUser user;

  openMap(String _address) async {
  //  MapsLauncher.launchCoordinates(latitude, longitude);
    MapsLauncher.launchQuery(_address);
  }

  @override
  void initState() {
    super.initState();
    initUser();
  }

  initUser() async {
    user = await _auth.currentUser();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        home: Scaffold(
            resizeToAvoidBottomPadding: false,
            appBar: AppBar(
              iconTheme: new IconThemeData(color: Colors.black),
              title: Text('My Home',
                  style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.w500,
                  )),
              backgroundColor: Colors.white,
              elevation: 0,
              titleSpacing: -10,
              leading: Icon(Icons.home),
              actions: <Widget>[
                Padding(
                  padding: EdgeInsets.all(15),
                  child: Icon(
                    Icons.notifications_none,
                    size: 30,
                  ),
                )
              ],
            ),
            floatingActionButton: FloatingActionButton(
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => AddPostView(),
                    ));
              },
              child: Icon(Icons.add),
              backgroundColor: Colors.black,
            ),
            body: StreamBuilder(
                stream: Firestore.instance
                    .collection('Posts')
                    .where("userID", isEqualTo: user.uid)
                    .getDocuments()
                    .asStream(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return Center(
                        child: Text(
                      "Loading...",
                      style: TextStyle(
                          color: Colors.black, fontWeight: FontWeight.bold),
                    ));
                  } else {
                    return snapshot.data.documents.isNotEmpty
                        ? new ListView.builder(
                            itemCount: snapshot.data.documents.length,
                            itemBuilder: (context, index) {
                              return Padding(
                                  padding: EdgeInsets.all(2),
                                  child: Card(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: <Widget>[
                                        Padding(
                                          padding:
                                              EdgeInsets.fromLTRB(5, 5, 5, 0),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: <Widget>[
                                              Column(
                                                mainAxisSize: MainAxisSize.min,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: <Widget>[
                                                  Row(
                                                    children: <Widget>[
                                                      SizedBox(
                                                        width: 5,
                                                      ),
                                                      Text(
                                                          snapshot.data
                                                                      .documents[
                                                                  index]
                                                              ['userFirstName'],
                                                          style: TextStyle(
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            fontSize: 16,
                                                          )),
                                                      Padding(
                                                          padding:
                                                              EdgeInsets.all(
                                                                  3)),
                                                      Text(
                                                          snapshot.data
                                                                      .documents[
                                                                  index]
                                                              ['userLastName'],
                                                          style: TextStyle(
                                                            fontSize: 16,
                                                          ))
                                                    ],
                                                  ),
                                                  Row(
                                                    children: <Widget>[
                                                      SizedBox(
                                                        width: 5,
                                                      ),
                                                      Text(
                                                          snapshot.data
                                                                  .documents[
                                                              index]['date'],
                                                          style: TextStyle(
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            color: Colors.grey,
                                                            fontStyle: FontStyle
                                                                .italic,
                                                            fontSize: 10,
                                                          )),
                                                      Text(" | ",
                                                          style: TextStyle(
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            color: Colors.grey,
                                                            fontStyle: FontStyle
                                                                .italic,
                                                            fontSize: 10,
                                                          )),
                                                      Text(
                                                          snapshot.data
                                                                  .documents[
                                                              index]['time'],
                                                          style: TextStyle(
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            color: Colors.grey,
                                                            fontStyle: FontStyle
                                                                .italic,
                                                            fontSize: 10,
                                                          ))
                                                    ],
                                                  )
                                                ],
                                              ),
                                              Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.end,
                                                children: <Widget>[
                                                  Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment.end,
                                                    children: <Widget>[
                                                      IconButton(
                                                          icon: Icon(
                                                            Icons.edit,
                                                            color: Colors.grey,
                                                          ),
                                                          alignment: Alignment
                                                              .topRight,
                                                          onPressed: () {
                                                            Navigator.push(
                                                                context,
                                                                MaterialPageRoute(
                                                                  builder:
                                                                      (context) =>
                                                                          EditPostView(snapshot.data
                                                                  .documents[
                                                              index]['postID']),
                                                                ));
                                                          }),
                                                      IconButton(
                                                          icon: Icon(
                                                            Icons.delete,
                                                            color: Colors.grey,
                                                          ),
                                                          alignment:
                                                              Alignment.topLeft,
                                                          onPressed: () {
                                                            showDialog(
                                                                context:
                                                                    context,
                                                                child:
                                                                    AlertDialog(
                                                                  title: Row(
                                                                    children: <
                                                                        Widget>[
                                                                      Icon(
                                                                        Icons
                                                                            .warning,
                                                                        color: Colors
                                                                            .red,
                                                                      ),
                                                                      Text(
                                                                        " Alert",
                                                                        style: TextStyle(
                                                                            color:
                                                                                Colors.black,
                                                                            fontWeight: FontWeight.bold),
                                                                      ),
                                                                    ],
                                                                  ),
                                                                  content: Text(
                                                                      "Are you sure you want to delete this post?",
                                                                      style: TextStyle(
                                                                          color:
                                                                              Colors.black)),
                                                                  actions: [
                                                                    FlatButton(
                                                                      child:
                                                                          Text(
                                                                        "Yes, Delete",
                                                                        style: TextStyle(
                                                                            color:
                                                                                Colors.red),
                                                                      ),
                                                                      onPressed:
                                                                          () {
                                                                        Firestore
                                                                            .instance
                                                                            .runTransaction((Transaction
                                                                                myTransaction) async {
                                                                          await myTransaction.delete(snapshot
                                                                              .data
                                                                              .documents[index]
                                                                              .reference);
                                                                          Navigator.of(context, rootNavigator: true)
                                                                              .pop();
                                                                          Navigator.push(
                                                                              context,
                                                                              MaterialPageRoute(
                                                                                builder: (context) => Home(),
                                                                              ));
                                                                        });
                                                                      },
                                                                    )
                                                                  ],
                                                                ));
                                                          })
                                                    ],
                                                  )
                                                ],
                                              )
                                            ],
                                          ),
                                        ),
                                        Padding(
                                          padding:
                                              EdgeInsets.fromLTRB(8, 0, 8, 0),
                                          child: Divider(
                                            color: Colors.grey,
                                            thickness: 1,
                                          ),
                                        ),
                                        Padding(
                                          padding:
                                              EdgeInsets.fromLTRB(10, 2, 10, 2),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: <Widget>[
                                              Text(
                                                  snapshot.data.documents[index]
                                                      ['description']),
                                              Padding(
                                                  padding: EdgeInsets.all(2)),
                                              Text(
                                                snapshot.data.documents[index]
                                                    ['hashtag'],
                                                style: TextStyle(
                                                    fontWeight:
                                                        FontWeight.bold),
                                              )
                                            ],
                                          ),
                                        ),
                                        Padding(
                                          padding:
                                              EdgeInsets.fromLTRB(0, 2, 0, 2),
                                          child: SizedBox(
                                            width: MediaQuery.of(context)
                                                .size
                                                .width,
                                            height: 180,
                                            child: DecoratedBox(
                                              child: Image.network(
                                                snapshot.data.documents[index]
                                                    ['cover'],
                                                width: 100,
                                                height: 100,
                                                fit: BoxFit.cover,
                                              ),
                                              decoration: BoxDecoration(
                                                  color: Colors.grey,
                                                  borderRadius:
                                                      BorderRadius.circular(8)),
                                            ),
                                          ),
                                        ),
                                        // Padding(
                                        //     padding: EdgeInsets.fromLTRB(
                                        //         10, 0, 10, 0),
                                        //     child: Row(
                                        //       children: <Widget>[
                                        //         Icon(
                                        //           Icons.star,
                                        //           color: Colors.amber,
                                        //         ),
                                        //         Text(
                                        //           snapshot.data.documents[index]
                                        //             ['starCount'].toString(),
                                        //           style: TextStyle(
                                        //               fontWeight:
                                        //                   FontWeight.bold),
                                        //         )
                                        //       ],
                                        //     )),
                                        Padding(
                                          padding:
                                              EdgeInsets.fromLTRB(8, 0, 8, 0),
                                          child: Divider(
                                            color: Colors.grey,
                                            thickness: 1,
                                          ),
                                        ),
                                        Padding(
                                          padding:
                                              EdgeInsets.fromLTRB(5, 0, 5, 0),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceAround,
                                            children: <Widget>[
                                              // TextButton.icon(
                                              //     onPressed: () {},
                                              //     icon: Icon(
                                              //       Icons.star,
                                              //       color: Colors.grey,
                                              //     ),
                                              //     style: TextButton.styleFrom(
                                              //         backgroundColor:
                                              //             Colors.grey[50]),
                                              //     label: Text(" Star ",
                                              //         style: TextStyle(
                                              //             color:
                                              //                 Colors.black))),
                                              TextButton.icon(
                                            onPressed: () {
                                              Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                      builder: (context) =>
                                                          ChatPage(
                                                              postID: snapshot
                                                                          .data
                                                                          .documents[
                                                                      index]
                                                                  ['postID'])));
                                            },
                                            icon: Icon(
                                              Icons.question_answer_rounded,
                                              color: Colors.grey,
                                            ),
                                            style: TextButton.styleFrom(
                                                backgroundColor:
                                                    Colors.grey[50]),
                                            label: Text("Comments / Chat ",
                                                style: TextStyle(
                                                    color: Colors.black))),
                                              TextButton.icon(
                                                  onPressed: () {
                                                     openMap(snapshot.data.documents[index]
                                                    ['location']);                                                  },
                                                  icon: Icon(
                                                    Icons.location_on,
                                                    color: Colors.grey,
                                                  ),
                                                  style: TextButton.styleFrom(
                                                      backgroundColor:
                                                          Colors.grey[50]),
                                                  label: Text("Get Location ",
                                                      style: TextStyle(
                                                          color: Colors.black)))
                                            ],
                                          ),
                                        )
                                      ],
                                    ),
                                  ));
                            })
                        : Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Text(
                                  "No any Posts are created.\nClick + to add posts",
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 15),
                                  textAlign: TextAlign.center,
                                ),
                              ],
                            ),
                          );
                  }
                })));
  }
}
