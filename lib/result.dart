import 'package:flutter/material.dart';

class ResultScreen extends StatefulWidget {
  final score;
  ResultScreen({this.score});

  @override
  _ResultScreenState createState() => _ResultScreenState(score);
}

class _ResultScreenState extends State<ResultScreen> {
  final score;
  _ResultScreenState(this.score);
  @override
  Widget build(BuildContext context) {
    print(score);
    return Scaffold(
      appBar: AppBar(
        title: Text("Results"),
      ),
      body: Container(
        child: Center(
          child: Text(
            "Your score is " + score.toString() + "/5",
          ),
        ),
      ),
    );
  }
}
