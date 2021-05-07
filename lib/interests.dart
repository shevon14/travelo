import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:travel_network/home.dart';
import 'package:travel_network/ui_curve_design.dart';

class InterestView extends StatefulWidget {
  @override
  _InterestViewState createState() => _InterestViewState();
}

class _InterestViewState extends State<InterestView> {
  bool beach, mountain, camp, waterfall, forest, ancient, park, hotel;

  final FirebaseAuth _auth = FirebaseAuth.instance;
  FirebaseUser user;

  @override
  void initState() {
    super.initState();
    //initUser();
    getBoolData();
  }

  // initUser() async {
  //   user = await _auth.currentUser();
  //   setState(() {});
  // }

  //dynamic data;

  getBoolData() async {
    user = await _auth.currentUser();

    if(user != null){
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
  }

  updateDatatoFirestore() async {
    final _userCollectionReference = Firestore.instance;

    final FirebaseUser user = await FirebaseAuth.instance.currentUser();
    String userid = user.uid.toString();

    DocumentReference interestid =
        await _userCollectionReference.collection('Interests').document(userid);

    interestid.updateData({
      'beach': beach,
      'mountain': mountain,
      'camp': camp,
      'waterfall': waterfall,
      'forest': forest,
      'ancient': ancient,
      'park': park,
      'hotel': hotel,
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        home: Scaffold(
            resizeToAvoidBottomPadding: false,
            appBar: AppBar(
              iconTheme: new IconThemeData(color: Colors.black),
              title: Text('INTERESTS',
                  style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.w500,
                  )),
              backgroundColor: Colors.white,
              elevation: 0,
              titleSpacing: -10,
              leading: Icon(Icons.star_border),
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
            body: CustomPaint(
              painter: CurvePainter(),
              child: Column(
                children: <Widget>[
                  Padding(padding: EdgeInsets.all(5)),
                  Row(
                    children: <Widget>[
                      Checkbox(
                          value: beach,
                          activeColor: Colors.blue,
                          onChanged: (val) {
                            setState(() {
                              beach = val;
                              if (val == true) {}
                            });
                          }),
                      Text(
                        "Beaches/ Islands",
                        style: TextStyle(
                            color: Colors.black, fontWeight: FontWeight.bold),
                      )
                    ],
                  ),
                  Row(
                    children: <Widget>[
                      Checkbox(
                          value: mountain,
                          activeColor: Colors.blue,
                          onChanged: (val) {
                            setState(() {
                              mountain = val;
                              if (val == true) {}
                            });
                          }),
                      Text(
                        "Mountains/ Hike",
                        style: TextStyle(
                            color: Colors.black, fontWeight: FontWeight.bold),
                      )
                    ],
                  ),
                  Row(
                    children: <Widget>[
                      Checkbox(
                          value: camp,
                          activeColor: Colors.blue,
                          onChanged: (val) {
                            setState(() {
                              camp = val;
                              if (val == true) {}
                            });
                          }),
                      Text(
                        "Camping",
                        style: TextStyle(
                            color: Colors.black, fontWeight: FontWeight.bold),
                      )
                    ],
                  ),
                  Row(
                    children: <Widget>[
                      Checkbox(
                          value: waterfall,
                          activeColor: Colors.blue,
                          onChanged: (val) {
                            setState(() {
                              waterfall = val;
                              if (val == true) {}
                            });
                          }),
                      Text(
                        "Waterfalls/ Rivers",
                        style: TextStyle(
                            color: Colors.black, fontWeight: FontWeight.bold),
                      )
                    ],
                  ),
                  Row(
                    children: <Widget>[
                      Checkbox(
                          value: forest,
                          activeColor: Colors.blue,
                          onChanged: (val) {
                            setState(() {
                              forest = val;
                              if (val == true) {}
                            });
                          }),
                      Text(
                        "Forests",
                        style: TextStyle(
                            color: Colors.black, fontWeight: FontWeight.bold),
                      )
                    ],
                  ),
                  Row(
                    children: <Widget>[
                      Checkbox(
                          value: ancient,
                          activeColor: Colors.blue,
                          onChanged: (val) {
                            setState(() {
                              ancient = val;
                              if (val == true) {}
                            });
                          }),
                      Text(
                        "Ancient/ Museum",
                        style: TextStyle(
                            color: Colors.black, fontWeight: FontWeight.bold),
                      )
                    ],
                  ),
                  Row(
                    children: <Widget>[
                      Checkbox(
                          value: park,
                          activeColor: Colors.blue,
                          onChanged: (val) {
                            setState(() {
                              park = val;
                              if (val == true) {}
                            });
                          }),
                      Text(
                        "Parks",
                        style: TextStyle(
                            color: Colors.black, fontWeight: FontWeight.bold),
                      )
                    ],
                  ),
                  Row(
                    children: <Widget>[
                      Checkbox(
                          value: hotel,
                          activeColor: Colors.blue,
                          onChanged: (val) {
                            setState(() {
                              hotel = val;
                              if (val == true) {}
                            });
                          }),
                      Text(
                        "Hotels/ Resturents",
                        style: TextStyle(
                            color: Colors.black, fontWeight: FontWeight.bold),
                      )
                    ],
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  ButtonTheme(
                      minWidth: 200,
                      height: 50,
                      child: new RaisedButton(
                        child: const Text(
                          'Save',
                          style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w900,
                              fontSize: 18),
                        ),
                        color: Colors.black,
                        shape: new RoundedRectangleBorder(
                          borderRadius: new BorderRadius.circular(30.0),
                        ),
                        onPressed: () {
                          updateDatatoFirestore();
                          Navigator.push(context,
                              MaterialPageRoute(builder: (context) => Home()));
                        },
                      )),
                ],
              ),
            )));
  }
}
