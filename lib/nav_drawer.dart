import 'dart:ui';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:travel_network/auth_service.dart';
import 'package:travel_network/interests.dart';
import 'package:travel_network/profileHome.dart';
import 'package:travel_network/provider_widget.dart';
import 'package:travel_network/settings.dart';

class NavDrawer extends StatefulWidget {
  @override
  _NavDrawerState createState() => _NavDrawerState();
}

class _NavDrawerState extends State<NavDrawer> {

  final FirebaseAuth _auth = FirebaseAuth.instance;
  FirebaseUser user;

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
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          UserAccountsDrawerHeader(
              // currentAccountPicture: CircleAvatar(
              //   backgroundColor: Colors.white, child: Icon(Icons.location_history),
              // ),
              accountName: Text(
                user.displayName ,
                style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 18),
              ),
              accountEmail: Text(user.email,
                  style: TextStyle(
                    color: Colors.white,
                  )),
              decoration: BoxDecoration(
                  color: Colors.black,
                  image: DecorationImage(
                      fit: BoxFit.fill,
                      image: AssetImage('assets/cover.png')))),
          ListTile(
            leading: Icon(
              Icons.account_circle,
              color: Colors.black,
            ),
            trailing: Icon(
              Icons.arrow_right,
              color: Colors.black54,
            ),
            title: Text('My Home',
                style: TextStyle(
                    color: Colors.black, fontWeight: FontWeight.bold)),
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ProfileHomeView(),
                  ));
            },
          ),
          ListTile(
            leading: Icon(
              Icons.thumb_up,
              color: Colors.black,
            ),
            trailing: Icon(
              Icons.arrow_right,
              color: Colors.black54,
            ),
            title: Text('Interests',
                style: TextStyle(
                    color: Colors.black, fontWeight: FontWeight.bold)),
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => InterestView(),
                  ));
            },
          ),
          ListTile(
            leading: Icon(
              Icons.settings,
              color: Colors.black,
            ),
            trailing: Icon(
              Icons.arrow_right,
              color: Colors.black54,
            ),
            title: Text('Settings',
                style: TextStyle(
                    color: Colors.black, fontWeight: FontWeight.bold)),
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => Settings(),
                  ));
            },
          ),
          ListTile(
            leading: Icon(
              Icons.info,
              color: Colors.black,
            ),
            trailing: Icon(
              Icons.arrow_right,
              color: Colors.black54,
            ),
            title: Text('About',
                style: TextStyle(
                    color: Colors.black, fontWeight: FontWeight.bold)),
            onTap: () {
              // Navigator.push(
              //   context,
              //   CupertinoPageRoute(builder: (context) => MyProfile()),
              // );
            },
          ),
          ListTile(
            leading: Icon(
              Icons.transit_enterexit,
              color: Colors.black,
            ),
            trailing: Icon(
              Icons.arrow_right,
              color: Colors.black54,
            ),
            title: Text('Log Out',
                style: TextStyle(
                    color: Colors.black, fontWeight: FontWeight.bold)),
            onTap: () async {
              // Navigator.push(
              //   context,
              //   CupertinoPageRoute(builder: (context) => MyProfile()),
              // );
               try {
                     AuthService auth = Provider.of(context).auth;
                        await auth.signOut();
                        print("signed out");
                      } catch (e) {
                        print(e);
                      }
            },
          ),
          Padding(padding: EdgeInsets.all(40)),
          ListTile(
            title: Center(
                child: Column(
              children: <Widget>[
                Text(
                  "Trevelo",
                  style: TextStyle(
                      color: Colors.grey,
                      fontWeight: FontWeight.bold,
                      fontSize: 15),
                ),
                Text(
                  "Version 1.0.0",
                  style: TextStyle(
                      color: Colors.grey, fontStyle: FontStyle.italic),
                )
              ],
            )),
          )
        ],
      ),
    );
  }
}
