import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:maps_launcher/maps_launcher.dart';
import 'package:travel_network/addPost.dart';
import 'package:travel_network/chat.dart';
import 'package:travel_network/nav_drawer.dart';

class Home extends StatefulWidget {
  @override
  _HomeViewState createState() => _HomeViewState();
}

class _HomeViewState extends State<Home> {
  bool _starcolor = false;
  bool beach, mountain, camp, waterfall, forest, ancient, park, hotel;

  final FirebaseAuth _auth = FirebaseAuth.instance;
  FirebaseUser user;

  @override
  void initState() {
    super.initState();
    getBoolData();
    //getFiltedPosts();
  }

  addDatatoFirestore(String _likeID) async {
    final _userCollectionReference = Firestore.instance;

    final FirebaseUser user = await FirebaseAuth.instance.currentUser();
    String userid = user.uid.toString();

    DocumentReference likepostid = await _userCollectionReference
        .collection('LikePosts')
        .document(userid)
        .collection(_likeID)
        .document(_likeID);

    likepostid.setData({
      // _userCollectionReference.collection(_likeID).document()
      'postID': '$_likeID',
      'userID': userid,
      'btncolor': true
    });
  }

  addLikeData(String _postID) async {
    final _userCollectionReference = Firestore.instance;

    final FirebaseUser user = await FirebaseAuth.instance.currentUser();
    String userid = user.uid.toString();

    DocumentReference docid = await _userCollectionReference
        .collection('LikeGiven')
        .document(userid + _postID);

    docid.setData({'liked': true, 'userID': userid, 'postID': _postID});
  }

  openMap(String _address) async {
    //  MapsLauncher.launchCoordinates(latitude, longitude);
    MapsLauncher.launchQuery(_address);
  }

  var _stream;

  getBoolData() async {
    user = await _auth.currentUser();

    if (user != null) {
      final DocumentReference interstDocID =
          await Firestore.instance.collection('Interests').document(user.uid);

      await interstDocID.get().then((DocumentSnapshot snapshot) async {
        setState(() {
          beach = snapshot.data['beach'];
          mountain = snapshot.data['mountain'];
          camp = snapshot.data['camp'];
          waterfall = snapshot.data['waterfall'];
          forest = snapshot.data['forest'];
          ancient = snapshot.data['ancient'];
          park = snapshot.data['park'];
          hotel = snapshot.data['hotel'];
        });
      });
    }
    getFiltedPosts();
  }

  getFiltedPosts() {
    var cats = [];
    print(camp);
    if (beach == true) {
      cats = cats + [1];
    }
    if (mountain == true) {
      cats = cats + [2];
    }
    if (camp == true) {
      cats = cats + [3];
    }
    if (waterfall == true) {
      cats = cats + [4];
    }
    if (forest == true) {
      cats = cats + [5];
    }
    if (ancient == true) {
      cats = cats + [6];
    }
    if (park == true) {
      cats = cats + [7];
    }
    if (hotel == true) {
      cats = cats + [8];
    }
    if (beach == false &&
        mountain == false &&
        camp == false &&
        waterfall == false &&
        forest == false &&
        ancient == false &&
        park == false &&
        hotel == false) {
      cats = [0];
    }

    _stream = Firestore.instance
        .collection('Posts')
        .where('category', whereIn: cats)
        .getDocuments()
        .asStream();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: NavDrawer(),
      appBar: AppBar(
        iconTheme: new IconThemeData(color: Colors.black),
        title: Text('Travelo',
            style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
        backgroundColor: Colors.white,
        elevation: 0,
        titleSpacing: 0,
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
          stream: _stream,
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return Center(
                  child: Text(
                "Add Interets to see more posts",
                style:
                    TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
              ));
            } else {
              return snapshot.data.documents.isNotEmpty
                  ? new ListView.builder(
                      itemCount: snapshot.data.documents.length,
                      itemBuilder: (context, index) {
                        //Color Btncolr = Colors.green;
                        return Padding(
                            padding: EdgeInsets.all(2),
                            child: Card(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Padding(
                                    padding: EdgeInsets.all(5),
                                    child: Row(
                                      children: <Widget>[
                                        Icon(
                                          Icons.location_history,
                                          size: 30,
                                          color: Colors.blue,
                                        ),
                                        Padding(padding: EdgeInsets.all(3)),
                                        Column(
                                          mainAxisSize: MainAxisSize.min,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: <Widget>[
                                            Row(
                                              children: <Widget>[
                                                Text(
                                                    snapshot.data
                                                            .documents[index]
                                                        ['userFirstName'],
                                                    style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontSize: 16,
                                                    )),
                                                Padding(
                                                    padding: EdgeInsets.all(3)),
                                                Text(
                                                    snapshot.data
                                                            .documents[index]
                                                        ['userLastName'],
                                                    style: TextStyle(
                                                      fontSize: 16,
                                                    ))
                                              ],
                                            ),
                                            Row(
                                              children: <Widget>[
                                                Text(
                                                    snapshot.data
                                                            .documents[index]
                                                        ['date'],
                                                    style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      color: Colors.grey,
                                                      fontStyle:
                                                          FontStyle.italic,
                                                      fontSize: 10,
                                                    )),
                                                Text(" | ",
                                                    style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      color: Colors.grey,
                                                      fontStyle:
                                                          FontStyle.italic,
                                                      fontSize: 10,
                                                    )),
                                                Text(
                                                    snapshot.data
                                                            .documents[index]
                                                        ['time'],
                                                    style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      color: Colors.grey,
                                                      fontStyle:
                                                          FontStyle.italic,
                                                      fontSize: 10,
                                                    ))
                                              ],
                                            )
                                          ],
                                        )
                                      ],
                                    ),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.fromLTRB(10, 2, 10, 2),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: <Widget>[
                                        Text(snapshot.data.documents[index]
                                            ['description']),
                                        Padding(padding: EdgeInsets.all(2)),
                                        Text(
                                          snapshot.data.documents[index]
                                              ['hashtag'],
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold),
                                        )
                                      ],
                                    ),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.fromLTRB(0, 2, 0, 2),
                                    child: SizedBox(
                                      width: MediaQuery.of(context).size.width,
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
        //                           Padding(
        //                               padding:
        //                                   EdgeInsets.fromLTRB(10, 0, 10, 0),
        //                               child: Row(
        //                                 children: <Widget>[
        //                                   Icon(
        //                                     Icons.format_align_left_rounded,
        //                                     color: Colors.black,
        //                                     size: 20,
        //                                   ),
        //                                   Padding(padding: EdgeInsets.only(right: 5)),
        //                                   Text(
        //                                     '2' + Firestore.instance
        // .collection('chat').document(snapshot.data.documents[index]
        //                                       ['cover']).collection('messages').toString()  ,
        //                                        // .toString(),
        //                                     style: TextStyle(
        //                                         fontWeight: FontWeight.bold),
        //                                   )
        //                                 ],
        //                               )),
                                  Padding(
                                    padding: EdgeInsets.fromLTRB(8, 0, 8, 0),
                                    child: Divider(
                                      color: Colors.grey,
                                      thickness: 1,
                                    ),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.fromLTRB(2, 0, 2, 0),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceAround,
                                      children: <Widget>[
                                        // TextButton.icon(
                                        //     onPressed: () {
                                        //       //checklikeButtonlogic(snapshot.data.documents[index]['postID']);
                                        //       int count =
                                        //           snapshot.data.documents[index]
                                        //               ['starCount'];
                                        //       _starcolor == false
                                        //           ? count = count + 1
                                        //           : count = count - 1;
                                        //       Firestore.instance
                                        //           .collection('Posts')
                                        //           .document(snapshot
                                        //                   .data.documents[index]
                                        //               ['postID'])
                                        //           .updateData(
                                        //               {'starCount': count});

                                        //       addLikeData(snapshot.data
                                        //           .documents[index]['postID']);

                                        //       _starcolor == true
                                        //           ? _starcolor = false
                                        //           : _starcolor == false
                                        //               ? _starcolor = true
                                        //               : _starcolor = false;

                                        //       // _starcolor == true ?
                                        //       // Firestore.instance.collection('LikePosts').
                                        //       // document(snapshot.data.documents[index]['UserID']).
                                        //       // collection(snapshot.data.documents[index]['postID']).document().delete() : null;
                                        //       //addDatatoFirestore(snapshot.data.documents[index]['postID']);
                                        //     },
                                        //     icon: Icon(Icons.star,
                                        //         color:
                                        //             // Firestore.instance.collection('LikeGiven').
                                        //             //document(snapshot.data.documents[index]['userID']+snapshot.data.documents[index]['postID']).get() == null ? Colors.amber : Colors.grey),
                                        //             //collection(snapshot.data.documents[index]['postID']).document(snapshot.data.documents[index]['postID']) != null ? Colors.amber : Colors.grey
                                        //             //_starcolor == true ? Colors.amber :
                                        //             // Btncolr
                                        //             Colors.grey),
                                        //     style: TextButton.styleFrom(
                                        //         backgroundColor:
                                        //             Colors.grey[50]),
                                        //     label: Text(" Star ",
                                        //         style: TextStyle(
                                        //             color: Colors.black))),
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
                                              openMap(
                                                  snapshot.data.documents[index]
                                                      ['location']);
                                            },
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
                            "No any Posts are available\nbased on your interets",
                            style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                                fontSize: 15),
                            textAlign: TextAlign.center,
                          ),
                          Icon(
                            Icons.mood_bad,
                            color: Colors.black,
                          )
                        ],
                      ),
                    );
            }
          }),
      // ],
      //   ) ],
      //  ),
      //  )
    );
  }
}
