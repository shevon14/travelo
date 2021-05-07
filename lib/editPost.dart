import 'dart:io';
import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:travel_network/auth_service.dart';
import 'package:travel_network/home.dart';
import 'package:travel_network/profileHome.dart';

class EditPostView extends StatefulWidget {
 // const EditPostView({Key key, this.postID}) : super(key: key);
  final String postID;
  EditPostView(this.postID);

  @override
  _EditPostViewState createState() => _EditPostViewState(postID);
  
}

class _EditPostViewState extends State<EditPostView> {
  final _formKey3 = GlobalKey<FormState>();
  _EditPostViewState(this._postDocID);
  String _description,
      _hashtags,
      _cover,
      _location,
      _date,
      _time,
      _userfirstname,
      _userlastname;
  bool _approval = true;
  bool showSpinner = false;
  DateTime _dateTime;

  FirebaseStorage storage = FirebaseStorage.instance;

  File _tempframeimage;

  String _postDocID;
  
  getProductId() async {
    setState(() {
     // _postDocID = ;
    });
  }

  @override
  void initState() {
    super.initState();
    getProductId();
  }

  bool validate() {
    final form = _formKey3.currentState;
    form.save();
    if (form.validate()) {
      form.save();
      return true;
    } else {
      return false;
    }
  }

  void submit() async {
    _dateTime = DateTime.now();
    _date = '${_dateTime}'.split(' ')[0];
    _time = ('${_dateTime}'.split(' ')[1]).split(':')[0] +
        ':' +
        ('${_dateTime}'.split(' ')[1]).split(':')[1];

    print(_cover);

    if (validate() &&
        _location != null &&
        _date != null &&
        _time != null) {
      setState(() {
        showSpinner = true;
      });
      try {
        updateDatatoFirestore();
        Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => Home(),
            ));
        setState(() {
          showSpinner = false;
        });
      } catch (e) {}
    }
    else{
      
    }
  }

 
  updateDatatoFirestore() async {
    final _userCollectionReference = Firestore.instance;

    final FirebaseUser user = await FirebaseAuth.instance.currentUser();
    String userid = user.uid.toString();

    DocumentReference postid =
        await _userCollectionReference.collection('Posts').document(_postDocID);


    postid.updateData({
      'description': '$_description',
      'hashtag': '$_hashtags',
      'cover': '$_cover',
      'location': '$_location',
      'postID': postid.documentID,
      'userID': '$userid',
      'approval': _approval,
      'date': '$_date',
      'time': '$_time',
      'userFirstName': (await Firestore.instance.collection('Users').document(userid).get()).data['firstname'],
      'userLastName': (await Firestore.instance.collection('Users').document(userid).get()).data['lastname']
    });
  }

  Future getImageFromGalary() async {
    PickedFile tempimage =
        await ImagePicker().getImage(source: ImageSource.gallery);

    setState(() {
      _tempframeimage = File(tempimage.path);
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        home: Scaffold(
            resizeToAvoidBottomPadding: false,
            appBar: AppBar(
              iconTheme: new IconThemeData(color: Colors.black),
              title: Text('Update Post',
                  style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.w500,
                  )),
              backgroundColor: Colors.white,
              elevation: 0,
              titleSpacing: -10,
              leading: Icon(Icons.edit_outlined),
            ),
            body: SingleChildScrollView( child: 
            StreamBuilder(
        stream: Firestore.instance
            .collection('Posts')
            .document(_postDocID)
            .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) return Text('Loading Data.. Please Wait...');
          return Form(
                key: _formKey3,
                child: Padding(
                    padding: EdgeInsets.fromLTRB(5, 15, 5, 5),
                    child: GestureDetector(
                      onTap: () {
                        // call this method here to hide soft keyboard
                        FocusScope.of(context).unfocus();
                      },
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Container(
                            child: Padding(
                              padding: EdgeInsets.only(),
                              child: TextFormField(
                                  keyboardType: TextInputType.multiline,
                                  initialValue: snapshot.data['description'],
                                  maxLines: null,
                                  style: TextStyle(color: Colors.black),
                                  decoration: InputDecoration(
                                    hintText: "Add a description",
                                    helperMaxLines: 2,
                                    hintStyle: TextStyle(
                                        color: Colors.grey,
                                        fontWeight: FontWeight.bold),
                                    enabledBorder: UnderlineInputBorder(
                                        borderSide: BorderSide(
                                            color: Colors.black, width: 1.0)),
                                    focusedBorder: UnderlineInputBorder(
                                        borderSide: BorderSide(
                                            color: Colors.black, width: 1.0)),
                                    prefixIcon: const Icon(
                                      Icons.edit,
                                      color: Colors.grey,
                                    ),
                                  ),
                                  obscureText: false,
                                  onSaved: (value) => _description = value),
                            ),
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          Container(
                            child: Padding(
                              padding: EdgeInsets.only(),
                              child: TextFormField(
                                initialValue: snapshot.data['hashtag'],
                                  validator: HashTagsValidator.validate,
                                  keyboardType: TextInputType.multiline,
                                  maxLines: null,
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold),
                                  decoration: InputDecoration(
                                    hintText:
                                        "Add HashTags (Ex : #Travel #Hike)",
                                    helperMaxLines: 2,
                                    hintStyle: TextStyle(
                                        color: Colors.grey,
                                        fontWeight: FontWeight.bold),
                                    enabledBorder: UnderlineInputBorder(
                                        borderSide: BorderSide(
                                            color: Colors.black, width: 1.0)),
                                    focusedBorder: UnderlineInputBorder(
                                        borderSide: BorderSide(
                                            color: Colors.black, width: 1.0)),
                                    prefixIcon: const Icon(
                                      Icons.edit,
                                      color: Colors.grey,
                                    ),
                                  ),
                                  obscureText: false,
                                  onSaved: (value) => _hashtags = value),
                            ),
                          ),
                          SizedBox(
                            height: 20,
                          ),Container(
                            child: Padding(
                              padding: EdgeInsets.only(),
                              child: TextFormField(
                                   initialValue: snapshot.data['location'],
                                  validator: HashTagsValidator.validate,
                                  keyboardType: TextInputType.multiline,
                                  maxLines: null,
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold),
                                  decoration: InputDecoration(
                                    hintText:
                                        "Add Location Address/ Name",
                                    helperMaxLines: 2,
                                    hintStyle: TextStyle(
                                        color: Colors.grey,
                                        fontWeight: FontWeight.bold),
                                    enabledBorder: UnderlineInputBorder(
                                        borderSide: BorderSide(
                                            color: Colors.black, width: 1.0)),
                                    focusedBorder: UnderlineInputBorder(
                                        borderSide: BorderSide(
                                            color: Colors.black, width: 1.0)),
                                    prefixIcon: const Icon(
                                      Icons.location_on_outlined,
                                      color: Colors.grey,
                                    ),
                                  ),
                                  obscureText: false,
                                  onSaved: (value) => _location = value),
                            ),
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: <Widget>[
                              ButtonTheme(
                                  minWidth: 320,
                                  height: 50,
                                  child: new RaisedButton(
                                    child: const Text(
                                      'Change Photo',
                                      style: TextStyle(
                                        color: Colors.grey,
                                        fontWeight: FontWeight.w900,
                                      ),
                                    ),
                                    color: Colors.grey[200],
                                    shape: new RoundedRectangleBorder(
                                      borderRadius:
                                          new BorderRadius.circular(10.0),
                                    ),
                                    onPressed: () async {
                                      PickedFile tempimage = await ImagePicker()
                                          .getImage(
                                              source: ImageSource.gallery);

                                      File _tempimage = File(tempimage.path);

                                      final _userCollectionReference =
                                          Firestore.instance;

                                      DocumentReference postid =
                                          await _userCollectionReference
                                              .collection('Posts')
                                              .document();

                                      StorageReference reference = storage
                                          .ref()
                                          .child(
                                              "postCovers/${postid.documentID}");

                                      //Upload the file to firebase
                                      StorageUploadTask uploadTask =
                                          reference.putFile(_tempimage);

                                      // setState(() {
                                      //   Scaffold.of(context)
                                      //       .showSnackBar(SnackBar(
                                      //     content: Text('Uploading...',
                                      //         style: TextStyle(
                                      //           color: Colors.white,
                                      //         )),
                                      //     backgroundColor: Colors.black,
                                      //   ));
                                      // });

                                      StorageTaskSnapshot taskSnapshot =
                                          await uploadTask.onComplete;

                                      // Waits till the file is uploaded then stores the download url
                                      _cover = await taskSnapshot.ref
                                          .getDownloadURL();

                                      // setState(() {
                                      //   Scaffold.of(context)
                                      //       .showSnackBar(SnackBar(
                                      //           content: Text(
                                      //             'Successfully Uploaded',
                                      //             style: TextStyle(
                                      //                 color: Color(0xFF4A184C)),
                                      //           ),
                                      //           backgroundColor: Colors.amber));
                                      // });

                                      setState(() {
                                        _tempframeimage = File(tempimage.path);
                                      });
                                    },
                                  )), 
                            ],
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          Padding(
                            padding: EdgeInsets.fromLTRB(10, 2, 10, 2),
                            child: SizedBox(
                              width: MediaQuery.of(context).size.width,
                              height: 180,
                              child: DecoratedBox(
                                child: Center(
                                  child: _tempframeimage == null
                                      ? Container(
                                          child: Image.network(snapshot.data['cover'],
                                              height: 180,
                                              width: 320,
                                              fit: BoxFit.cover),
                                        )
                                      : Container(
                                          child: Image.file(_tempframeimage,
                                              height: 180,
                                              width: 320,
                                              fit: BoxFit.cover),
                                        ),
                                ),
                                decoration: BoxDecoration(
                                    color: Colors.grey[200],
                                    borderRadius: BorderRadius.circular(8)),
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          ButtonTheme(
                              minWidth: 400,
                              height: 50,
                              child: new RaisedButton(
                                child: const Text(
                                  'Save Changes',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w900,
                                  ),
                                ),
                                color: Colors.black,
                                shape: new RoundedRectangleBorder(
                                  borderRadius: new BorderRadius.circular(10.0),
                                ),
                                onPressed: () {
                                  if (_cover == null) {
                                _cover = snapshot.data['cover'];
                                   }
                                  submit();
                                },
                              )),
                        ],
                      ),
                    )));}))));
  }
}
