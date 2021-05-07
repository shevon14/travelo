import 'package:flutter/material.dart';
import 'package:travel_network/ui_curve_design.dart';

class InternetOffiline extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
          appBar: AppBar(
            title: const Text('Travelo'),
            backgroundColor: Color(0xFF4A184C),
          ),
          body: CustomPaint(
            painter: CurvePainter(),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[

                Icon(
                  Icons.signal_wifi_off,
                  color: Colors.amber,
                  size: 100,
                ),

                Text("Connection Failed, Try Again!",
                    style: TextStyle(
                        color: Colors.amber,
                        fontWeight: FontWeight.w800,
                        fontSize: 20)),

                Padding(
                    padding: EdgeInsets.fromLTRB(15, 5, 15, 0),
                    child: Text(
                      "There may be a problem in your internet connection. Page will be automatically reload when you come back online.",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          color: Color(0xFF4A184C),
                          fontWeight: FontWeight.w500),
                    )),
                Padding(padding: EdgeInsets.only(bottom:70))
              ],
            ),
          )),
    );
  }
}
