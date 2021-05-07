import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:travel_network/auth_service.dart';

class Settings extends StatefulWidget {
  @override
  _SettingsState createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  FirebaseUser user;

  String _email,
      _password,
      _firstname,
      _lastname,
      _gender,
      _contact,
      _profileimg,
      _warning;

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
    return Scaffold(
        appBar: AppBar(
          iconTheme: new IconThemeData(color: Colors.black),
          title: Text('Settings',
              style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.w500,
              )),
          backgroundColor: Colors.white,
          elevation: 0,
          titleSpacing: -10,
          leading: Icon(Icons.settings),
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
        body: SafeArea(
            child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                  padding: EdgeInsets.fromLTRB(10, 15, 10, 0),
                  child: Text(
                    "Account Settings",
                    style: TextStyle(
                      fontSize: 20.0,
                      fontWeight: FontWeight.w600,
                    ),
                  )),
              Padding(
                  padding: EdgeInsets.fromLTRB(12, 3, 12, 0),
                  child: Text(
                    "Manage information about your account in general. Tap and update your name, contact, gender and set a profile image.",
                    style: TextStyle(
                      fontSize: 15.0,
                    ),
                  )),
              StreamBuilder(
                  stream: Firestore.instance
                      .collection('Users')
                      .document(user.uid)
                      .snapshots(),
                  builder: (context, snapshot) {
                    if (!snapshot.hasData)
                      return Text('Loading Account Data.. Please Wait...');
                    return Column(children: [
                      Padding(
                        padding: EdgeInsets.fromLTRB(15, 2, 15, 0),
                        child: TextFormField(
                          keyboardType: TextInputType.text,
                          validator: NameValidator.validate,
                          style: TextStyle(fontSize: 15.0, color: Colors.black),
                          decoration: InputDecoration(
                            hintText: 'First Name : ' + snapshot.data['firstname'],
                            errorMaxLines: 1,
                            hintStyle: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.bold),
                            enabledBorder: UnderlineInputBorder(
                                borderSide: BorderSide(
                                    color: Theme.of(context).accentColor,
                                    width: 1.0)),
                            focusedBorder: UnderlineInputBorder(
                                borderSide: BorderSide(
                                    color: Theme.of(context).accentColor,
                                    width: 1.0)),
                            prefixIcon: const Icon(
                              Icons.account_circle,
                              color: Colors.blue,
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.fromLTRB(15, 2, 15, 0),
                        child: TextFormField(
                          keyboardType: TextInputType.text,
                          validator: NameValidator.validate,
                          style: TextStyle(fontSize: 15.0, color: Colors.black),
                          decoration: InputDecoration(
                            hintText: 'Last Name : ' + snapshot.data['lastname'],
                            errorMaxLines: 1,
                            hintStyle: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.bold),
                            enabledBorder: UnderlineInputBorder(
                                borderSide: BorderSide(
                                    color: Theme.of(context).accentColor,
                                    width: 1.0)),
                            focusedBorder: UnderlineInputBorder(
                                borderSide: BorderSide(
                                    color: Theme.of(context).accentColor,
                                    width: 1.0)),
                            prefixIcon: const Icon(
                              Icons.account_circle,
                              color: Colors.blue,
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.fromLTRB(15, 2, 15, 0),
                        child: TextFormField(
                          keyboardType: TextInputType.text,
                          validator: ContactValidator.validate,
                          style: TextStyle(fontSize: 15.0, color: Colors.black),
                          decoration: InputDecoration(
                            hintText: 'Contact Number : ' + snapshot.data['contact'],
                            errorMaxLines: 1,
                            hintStyle: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.bold),
                            enabledBorder: UnderlineInputBorder(
                                borderSide: BorderSide(
                                    color: Theme.of(context).accentColor,
                                    width: 1.0)),
                            focusedBorder: UnderlineInputBorder(
                                borderSide: BorderSide(
                                    color: Theme.of(context).accentColor,
                                    width: 1.0)),
                            prefixIcon: const Icon(
                              Icons.phone,
                              color: Colors.blue,
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.fromLTRB(15, 2, 15, 0),
                        child: DropdownButtonFormField<String>(
                          validator: (value) {
                            if (value == null) {
                              return "gender can't be empty";
                            }
                          },
                          value: _gender,
                          items: [
                            "Male",
                            "Female",
                          ]
                              .map((label) => DropdownMenuItem(
                                    child: Text(label),
                                    value: label,
                                  ))
                              .toList(),
                          onChanged: (value) {
                            setState(() => _gender = value);
                          },
                          style: TextStyle(fontSize: 15.0, color: Colors.black),
                          decoration: InputDecoration(
                            hintText: "Select Gender : " + snapshot.data['gender'],
                            hintStyle: TextStyle(
                                color: Colors.black,
                                fontSize: 15.0,
                                fontWeight: FontWeight.bold),
                            enabledBorder: UnderlineInputBorder(
                                borderSide: BorderSide(
                                    color: Theme.of(context).accentColor,
                                    width: 1.0)),
                            focusedBorder: UnderlineInputBorder(
                                borderSide: BorderSide(
                                    color: Theme.of(context).accentColor,
                                    width: 1.0)),
                            prefixIcon: const Icon(
                              Icons.supervisor_account,
                              color: Colors.blue,
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.fromLTRB(10, 4, 10, 0),
                        child: ButtonTheme(
                            minWidth: 500,
                            height: 40,
                            child: new RaisedButton(
                              child: const Text(
                                'Save Changes',
                                style: TextStyle(
                                  color: Colors.grey,
                                  fontWeight: FontWeight.w900,
                                ),
                              ),
                              color: Colors.grey[200],
                              shape: new RoundedRectangleBorder(
                                borderRadius: new BorderRadius.circular(5.0),
                              ),
                              onPressed: () {},
                            )),
                      ),
                    ]);
                  }),
              Padding(
                  padding: EdgeInsets.fromLTRB(10, 20, 10, 0),
                  child: Text(
                    "Privacy Settings",
                    style: TextStyle(
                      fontSize: 20.0,
                      fontWeight: FontWeight.w600,
                    ),
                  )),
              Padding(
                  padding: EdgeInsets.fromLTRB(12, 3, 12, 0),
                  child: Text(
                    "It's a good idea to use a strong password that you don't use elsewhere. Once your click the button an email will be send toy our mail to change the password.",
                    style: TextStyle(
                      fontSize: 15.0,
                    ),
                  )),
              Padding(
                padding: EdgeInsets.fromLTRB(10, 2, 10, 0),
                child: ButtonTheme(
                    minWidth: 500,
                    height: 40,
                    child: new RaisedButton(
                      child: const Text(
                        'Click to change the Password',
                        style: TextStyle(
                          color: Colors.grey,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                      color: Colors.grey[200],
                      shape: new RoundedRectangleBorder(
                        borderRadius: new BorderRadius.circular(5.0),
                      ),
                      onPressed: () {},
                    )),
              ),
              Padding(
                  padding: EdgeInsets.fromLTRB(10, 25, 10, 0),
                  child: Text(
                    "Notifications Settings",
                    style: TextStyle(
                      fontSize: 20.0,
                      fontWeight: FontWeight.w600,
                    ),
                  )),
              Padding(
                  padding: EdgeInsets.fromLTRB(12, 3, 12, 0),
                  child: Text(
                    "Travelo will be send push notifications about comments, replies that related to your post",
                    style: TextStyle(
                      fontSize: 15.0,
                    ),
                  )),
              Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Padding(
                      padding: EdgeInsets.fromLTRB(12, 0, 10, 0),
                      child: Text(
                        "Allow to received the notifications",
                        style: TextStyle(
                          fontSize: 15.0,
                        ),
                      )),
                  Padding(
                    padding: EdgeInsets.only(right: 10),
                    child: Switch(
                        value: true,
                        activeColor: Colors.black,
                        onChanged: null),
                  )
                ],
              ),
              SizedBox(
                height: 20,
              )
            ],
          ),
        )));
  }
}
