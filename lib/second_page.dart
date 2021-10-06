import 'dart:core';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/rendering.dart';

//Second page that displays percentage
class ShowWaterPercentage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Water Level App"),),
      body: DisplayWaterPercentage(),
    );
  }
}

class DisplayWaterPercentage extends StatefulWidget {
  @override
  _DisplayWaterPercentageState createState() {
    return _DisplayWaterPercentageState();
  }
}

class _DisplayWaterPercentageState extends State<DisplayWaterPercentage> {
  Widget build(BuildContext context) {
    return Stack(
        children: <Widget> [

          RetrieveWaterPercentage(),

          Container(
              child: Align(
                  alignment: Alignment(0.0, 0.8),
                  child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        primary: Colors.blue,
                        onPrimary: Colors.white,
                      ),
                      onPressed: () {
                        _navigateToPrevPage(context);
                      },
                      child: Text("Prev Page")
                  )
              )
          )
        ]
    );
  }

  void _navigateToPrevPage(BuildContext context) {
    Navigator.pop(context);
  }
}

class RetrieveWaterPercentage extends StatefulWidget {
  @override
  _RetrieveWaterPercentageState createState() => _RetrieveWaterPercentageState();
}

class _RetrieveWaterPercentageState extends State<RetrieveWaterPercentage> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: FirebaseFirestore.instance.collection('waterpercentage').doc('percentage').snapshots(),
        builder: (context, AsyncSnapshot<DocumentSnapshot> snapshot) {
          if(snapshot.hasError) {
            return Container(
                child: Align(
                  alignment: Alignment(0.0, 0.6),
                  child: Text("Something went wrong", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 30, color: Colors.grey),),
                )
            );
          }

          if(snapshot.connectionState == ConnectionState.waiting) {
            return Container(
                child: Align(
                  alignment: Alignment(0.0, 0.6),
                  child: Text("Loading", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 30, color: Colors.grey),),
                )
            );
          }

          return Stack(
              children: <Widget> [
                Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children:[
                      if (int.parse('${snapshot.data!['percentage']}') == 0)
                        Align(
                          alignment: Alignment(0.0, 0.0),
                          child: Image.asset('images/0percent.png'),
                        ),
                      if (int.parse('${snapshot.data!['percentage']}') > 0 && int.parse('${snapshot.data!['percentage']}') <= 10)
                        Align(
                          alignment: Alignment(0.0, 0.0),
                          child: Image.asset('images/5percent.png'),
                        ),
                      if (int.parse('${snapshot.data!['percentage']}') > 10 && int.parse('${snapshot.data!['percentage']}') <= 20)
                        Align(
                          alignment: Alignment(0.0, 0.0),
                          child: Image.asset('images/10percent.png'),
                        ),
                      if (int.parse('${snapshot.data!['percentage']}') > 20 && int.parse('${snapshot.data!['percentage']}') <= 40)
                        Align(
                          alignment: Alignment(0.0, 0.0),
                          child: Image.asset('images/30percent.png'),
                        ),
                      if (int.parse('${snapshot.data!['percentage']}') > 40 && int.parse('${snapshot.data!['percentage']}') < 50)
                        Align(
                          alignment: Alignment(0.0, 0.0),
                          child: Image.asset('images/40percent.png'),
                        ),
                      if (int.parse('${snapshot.data!['percentage']}') == 50)
                        Align(
                          alignment: Alignment(0.0, 0.0),
                          child: Image.asset('images/50percent.png'),
                        ),
                      if (int.parse('${snapshot.data!['percentage']}') > 50 && int.parse('${snapshot.data!['percentage']}') <= 70)
                        Align(
                          alignment: Alignment(0.0, 0.0),
                          child: Image.asset('images/60percent.png'),
                        ),
                      if (int.parse('${snapshot.data!['percentage']}') > 70 && int.parse('${snapshot.data!['percentage']}') <= 90)
                        Align(
                          alignment: Alignment(0.0, 0.0),
                          child: Image.asset('images/80percent.png'),
                        ),
                      if (int.parse('${snapshot.data!['percentage']}') > 91 && int.parse('${snapshot.data!['percentage']}') <= 99)
                        Align(
                          alignment: Alignment(0.0, 0.0),
                          child: Image.asset('images/90percent.png'),
                        ),
                      if (int.parse('${snapshot.data!['percentage']}') == 100)
                        Align(
                          alignment: Alignment(0.0, 0.0),
                          child: Image.asset('images/100percent.png'),
                        ),
                    ]),

                Container(
                  child: Align(
                    alignment: Alignment(0.0, 0.6),
                    child: Text('${snapshot.data!['percentage']}'+"%", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 30, color: Colors.grey),),
                  ),
                ),
              ]
          );
        }
    );
  }
}