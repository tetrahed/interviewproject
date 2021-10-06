import 'dart:async';
import 'dart:core';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/rendering.dart';
import 'second_page.dart';

void main() {
  runApp(FirstScreenPage());
}

//main page that has the slider to adjust percentage
class FirstScreenPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text("Water Level App"),
        ),
        body: WaterPercentage(),
      ),
      debugShowCheckedModeBanner: false,
    );
  }
}

class WaterPercentage extends StatefulWidget {
  @override
  _WaterPercentageState createState() {
    return _WaterPercentageState();
  }
}

class _WaterPercentageState extends State<WaterPercentage> {
  Color positiveColor = Colors.blue;
  Color negativeColor = Colors.white;
  double percentage = 0.0;

  double initial = 0.0;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        Container(
          child: Align(
            alignment: Alignment(0.0, -0.3),
            child: Text("Select Water Level", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 30, color: Colors.grey),),
          )
        ),

        Container(
          child: Align(
            alignment: Alignment(0.0, 0.0),
            child: GestureDetector(
                    onPanStart: (DragStartDetails details) {
                      initial = details.globalPosition.dx;
                    },

                    onPanUpdate: (DragUpdateDetails details) {
                      double distance = details.globalPosition.dx - initial;
                      double percentageAddition = distance / 500;

                      setState(() {
                        percentage = (percentage + percentageAddition).clamp(0.0, 100.0);
                      });
                    },

                  onPanEnd: (DragEndDetails details) {
                    initial = 0.0;
                  },

                  child: WaterSlider(
                    percentage,
                    positiveColor,
                    negativeColor,
                  )
            ),
          )
        ),

        Container(
          child: Align(
            alignment: Alignment(0.0, 0.2),
            child: Text(
                percentage.round().toString() + '%',
                style: TextStyle(
                  fontSize: 30.0,
                  color: Colors.grey,
                )
            ),
          ),
        ),

        Container(
            child: Align(
              alignment: Alignment(0.0, 0.4),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  primary: Colors.blue,
                  onPrimary: Colors.white,
                ),
                onPressed: () {
                  _navigateToNextPage(context);
                },
                child: Text("Next Page")
              )
            )
        ),

        Container(
            child: Align(
                alignment: Alignment(0.0, 0.6),
                child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      primary: Colors.blue,
                      onPrimary: Colors.white,
                    ),
                    onPressed: () {
                      setState(() {
                        _updateData(percentage.round().toString());
                      });
                    },
                    child: Text("Push to Firestore")
                )
            )
        ),
      ]
    );
  }

  void _navigateToNextPage(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ShowWaterPercentage(),
      ));
  }

  //interacts with the cloud function to update document in firestore
  Future<Response> _updateData(String percent) {
    return post(Uri.parse('https://us-central1-ansyncinterviewprojectdb.cloudfunctions.net/update'), body: percent);
  }
}

//class for custom slider
class WaterSlider extends StatelessWidget {
  double totalWidth = 500.0;
  double percentage = 0.0;
  Color positiveColor = Colors.white;
  Color negativeColor = Colors.black;

  WaterSlider(double percentage, Color positiveColor, Color negativeColor) {
    this.percentage = percentage;
    this.positiveColor = positiveColor;
    this.negativeColor = negativeColor;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        width: totalWidth + 4.0,
        height: 30.0,
        decoration: BoxDecoration(
            color: negativeColor,
            border: Border.all(
                color: Colors.black,
                width: 2.0
            )
        ),

        child: Row(
            mainAxisSize: MainAxisSize.max,
            children: <Widget>[
              Container(
                color: positiveColor,
                width: (percentage / 100) * totalWidth,
              ),
            ]
        )
    );
  }
}