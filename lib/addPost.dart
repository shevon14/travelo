import 'dart:io';
import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:travel_network/auth_service.dart';
import 'package:travel_network/home.dart';

class AddPostView extends StatefulWidget {
  @override
  _AddPostViewState createState() => _AddPostViewState();
}

class _AddPostViewState extends State<AddPostView> {
  final _formKey1 = GlobalKey<FormState>();
  String _description,
      _hashtags,
      _cover,
      _location = "location link",
      _date,
      _time,
      _userfirstname,
      _userlastname;
  int _category;
  int _starCount = 0;
  bool _approval = true;
  bool showSpinner = false;
  DateTime _dateTime;

  FirebaseStorage storage = FirebaseStorage.instance;

  File _tempframeimage;

  bool validate() {
    final form = _formKey1.currentState;
    form.save();
    if (form.validate()) {
      form.save();
      return true;
    } else {
      return false;
    }
  }

  analyzeCategory() async {
    var keywords = _description.toLowerCase() + " " + _hashtags.toLowerCase();
    var keywordsArray = keywords.split(' ');
    print(keywordsArray);
    int beach = 0, mountain = 0;

    for (int i = 0; i <= keywordsArray.length; i++) {
      if (keywordsArray[i] == 'beach' ||
          keywordsArray[i] == '#beach' ||
          keywordsArray[i] == 'sea' ||
          keywordsArray[i] == '#sea' ||
          keywordsArray[i] == 'coast' ||
          keywordsArray[i] == '#coast' ||
          keywordsArray[i] == 'seaside' ||
          keywordsArray[i] == '#seaside' ||
          keywordsArray[i] == 'coral' ||
          keywordsArray[i] == '#coral' ||
          keywordsArray[i] == 'island' ||
          keywordsArray[i] == '#island' ||
          keywordsArray[i] == 'fish' ||
          keywordsArray[i] == '#fish' ||
          keywordsArray[i] == 'jellyfish' ||
          keywordsArray[i] == '#jellyfish' ||
          keywordsArray[i] == 'downsouth' ||
          keywordsArray[i] == '#downsouth') {
        _category = 1;
      }
      if (keywordsArray[i] == 'mountain' ||
          keywordsArray[i] == '#mountain' ||
          keywordsArray[i] == 'hill' ||
          keywordsArray[i] == '#hill' ||
          keywordsArray[i] == 'hillside' ||
          keywordsArray[i] == '#hillside' ||
          keywordsArray[i] == 'hike' ||
          keywordsArray[i] == '#hike' ||
          keywordsArray[i] == 'cave' ||
          keywordsArray[i] == '#cave' ||
          keywordsArray[i] == 'climb' ||
          keywordsArray[i] == '#climb' ||
          keywordsArray[i] == 'rock' ||
          keywordsArray[i] == '#rock') {
        _category = 2;
      }
      if (keywordsArray[i] == 'camp' ||
          keywordsArray[i] == '#camp' ||
          keywordsArray[i] == 'fire' ||
          keywordsArray[i] == '#fire' ||
          keywordsArray[i] == 'campfire' ||
          keywordsArray[i] == '#campfire' ||
          keywordsArray[i] == 'tent' ||
          keywordsArray[i] == '#tent' ||
          keywordsArray[i] == 'retreat' ||
          keywordsArray[i] == '#retreat') {
        _category = 3;
      }
      if (keywordsArray[i] == 'waterfall' ||
          keywordsArray[i] == '#waterfall' ||
          keywordsArray[i] == 'river' ||
          keywordsArray[i] == '#river' ||
          keywordsArray[i] == 'lagoon' ||
          keywordsArray[i] == '#lagoon' ||
          keywordsArray[i] == 'stream' ||
          keywordsArray[i] == '#stream' ||
          keywordsArray[i] == 'lake' ||
          keywordsArray[i] == '#lake') {
        _category = 4;
      }
      if (keywordsArray[i] == 'forest' ||
          keywordsArray[i] == '#forest' ||
          keywordsArray[i] == 'wildlife' ||
          keywordsArray[i] == '#wildlife' ||
          keywordsArray[i] == 'wild' ||
          keywordsArray[i] == '#wild' ||
          keywordsArray[i] == 'trees' ||
          keywordsArray[i] == '#trees' ||
          keywordsArray[i] == 'jungle' ||
          keywordsArray[i] == '#jungle' ||
          keywordsArray[i] == 'rainforest' ||
          keywordsArray[i] == '#rainforest') {
        _category = 5;
      }
      if (keywordsArray[i] == 'ancient' ||
          keywordsArray[i] == '#acient' ||
          keywordsArray[i] == 'musieum' ||
          keywordsArray[i] == '#musiem' ||
          keywordsArray[i] == 'histroy' ||
          keywordsArray[i] == '#history' ||
          keywordsArray[i] == 'art' ||
          keywordsArray[i] == '#art' ||
          keywordsArray[i] == 'statue' ||
          keywordsArray[i] == '#statue' ||
          keywordsArray[i] == 'relic' ||
          keywordsArray[i] == '#relic' ||
          keywordsArray[i] == 'zoo' ||
          keywordsArray[i] == '#zoo') {
        _category = 6;
      }
      if (keywordsArray[i] == 'park' ||
          keywordsArray[i] == '#park' ||
          keywordsArray[i] == 'playground' ||
          keywordsArray[i] == '#playground' ||
          keywordsArray[i] == 'garden' ||
          keywordsArray[i] == '#garden' ||
          keywordsArray[i] == 'flowers' ||
          keywordsArray[i] == '#flowers' ||
          keywordsArray[i] == 'nationalpark' ||
          keywordsArray[i] == '#nationaprk' ||
          keywordsArray[i] == 'botanical' ||
          keywordsArray[i] == '#botanical') {
        _category = 7;
      }
      if (keywordsArray[i] == 'hotel' ||
          keywordsArray[i] == '#hotel' ||
          keywordsArray[i] == 'resturent' ||
          keywordsArray[i] == '#resturent' ||
          keywordsArray[i] == 'bar' ||
          keywordsArray[i] == '#bar' ||
          keywordsArray[i] == 'casino' ||
          keywordsArray[i] == '#casino' ||
          keywordsArray[i] == 'cafe' ||
          keywordsArray[i] == '#cafe' ||
          keywordsArray[i] == 'ballroom' ||
          keywordsArray[i] == '#ballroom' ||
          keywordsArray[i] == 'suite' ||
          keywordsArray[i] == '#suite' ||
          keywordsArray[i] == 'coffehouse' ||
          keywordsArray[i] == '#coffehouse') {
        _category = 8;
      }
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
        _cover != null &&
        _location != null &&
        _date != null &&
        _time != null) {
      setState(() {
        showSpinner = true;
      });
      try {
        analyzeCategory();
        addDatatoFirestore();
        Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => Home(),
            ));
        setState(() {
          showSpinner = false;
        });
      } catch (e) {}
    } else {}
  }

  addDatatoFirestore() async {
    final _userCollectionReference = Firestore.instance;

    final FirebaseUser user = await FirebaseAuth.instance.currentUser();
    String userid = user.uid.toString();

    DocumentReference postid =
        await _userCollectionReference.collection('Posts').document();

    postid.setData({
      'description': '$_description',
      'hashtag': '$_hashtags',
      'cover': '$_cover',
      'location': '$_location',
      'postID': postid.documentID,
      'userID': '$userid',
      'approval': _approval,
      'date': '$_date',
      'time': '$_time',
      'category': _category,
      'starCount': _starCount,
      'userFirstName':
          (await Firestore.instance.collection('Users').document(userid).get())
              .data['firstname'],
      'userLastName':
          (await Firestore.instance.collection('Users').document(userid).get())
              .data['lastname']
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
              title: Text('Create Post',
                  style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.w500,
                  )),
              backgroundColor: Colors.white,
              elevation: 0,
              titleSpacing: -10,
              leading: Icon(Icons.add),
            ),
            body: SingleChildScrollView(
                child: Form(
                    key: _formKey1,
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
                                                color: Colors.black,
                                                width: 1.0)),
                                        focusedBorder: UnderlineInputBorder(
                                            borderSide: BorderSide(
                                                color: Colors.black,
                                                width: 1.0)),
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
                                                color: Colors.black,
                                                width: 1.0)),
                                        focusedBorder: UnderlineInputBorder(
                                            borderSide: BorderSide(
                                                color: Colors.black,
                                                width: 1.0)),
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
                              ),
                              Container(
                                child: Padding(
                                  padding: EdgeInsets.only(),
                                  child: TextFormField(
                                      validator: HashTagsValidator.validate,
                                      keyboardType: TextInputType.multiline,
                                      maxLines: null,
                                      style: TextStyle(
                                          color: Colors.black,
                                          fontWeight: FontWeight.bold),
                                      decoration: InputDecoration(
                                        hintText: "Add Location Address/ Name",
                                        helperMaxLines: 2,
                                        hintStyle: TextStyle(
                                            color: Colors.grey,
                                            fontWeight: FontWeight.bold),
                                        enabledBorder: UnderlineInputBorder(
                                            borderSide: BorderSide(
                                                color: Colors.black,
                                                width: 1.0)),
                                        focusedBorder: UnderlineInputBorder(
                                            borderSide: BorderSide(
                                                color: Colors.black,
                                                width: 1.0)),
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
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: <Widget>[
                                  ButtonTheme(
                                      minWidth: 320,
                                      height: 50,
                                      child: new RaisedButton(
                                        child: const Text(
                                          'Upload a Photo',
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
                                          PickedFile tempimage =
                                              await ImagePicker().getImage(
                                                  source: ImageSource.gallery);

                                          File _tempimage =
                                              File(tempimage.path);

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
                                            _tempframeimage =
                                                File(tempimage.path);
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
                                          ? Text(
                                              "No photo selected\nRecommended Size : 16:9\n(1920px X 1080px)",
                                              style: TextStyle(
                                                  color: Colors.black),
                                              textAlign: TextAlign.center)
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
                                      'Publish',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.w900,
                                      ),
                                    ),
                                    color: Colors.black,
                                    shape: new RoundedRectangleBorder(
                                      borderRadius:
                                          new BorderRadius.circular(10.0),
                                    ),
                                    onPressed: () {
                                      submit();
                                    },
                                  )),
                            ],
                          ),
                        ))))));
  }
}
