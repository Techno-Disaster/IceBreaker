import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flip_card/flip_card.dart';
import 'package:icemate/result.dart';
import 'package:icemate/test.dart';
import 'dart:io';

import 'package:path_provider/path_provider.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: MyHomePage(),
      // MyHomePage(
      //   storage: Storage(),
      // ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  File jsonFile;
  Directory dir;
  String fileName = "cards.json";
  bool fileExists = false;
  Map<String, dynamic> fileContent;
  @override
  void initState() {
    super.initState();
    startTimer();
    getApplicationDocumentsDirectory().then((Directory directory) {
      dir = directory;
      jsonFile = new File(dir.path + "/" + fileName);
      fileExists = jsonFile.existsSync();
      if (fileExists)
        this.setState(
            () => fileContent = json.decode(jsonFile.readAsStringSync()));
    });
  }

  void updateinfo() {
    print(fileContent["name"]);
    if (fileExists)
      this.setState(
          () => fileContent = json.decode(jsonFile.readAsStringSync()));
  }

  String state;
  Future<Directory> appDocDir;
  var showanswer = false;
  int j;
  int score = 0;
  var hi;
  int i = 0;
  bool canceltimer = false;

  int timer = 10;
  String showtimer = '10';
  GlobalKey<FlipCardState> cardKey = GlobalKey<FlipCardState>();
  void startTimer() {
    timer = 10;
    canceltimer = false;

    const sec = Duration(seconds: 1);
    Timer.periodic(
      sec,
      (Timer t) {
        setState(
          () {
            if (timer < 1) {
              t.cancel();
              cardKey.currentState.toggleCard();
              showanswer = true;
            } else if (canceltimer == true) {
              t.cancel();
            } else {
              timer = timer - 1;
            }

            showtimer = timer.toString();
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    var onpressedwrong;
    var onpressedcorrect;
    if (showanswer) {
      onpressedwrong = () {
        score--;
      };
    }
    if (showanswer) {
      onpressedcorrect = () {
        score++;
      };
    }
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "IceBreaker",
        ),
        centerTitle: true,
      ),
      backgroundColor: Colors.white,
      body: Center(
        child: FutureBuilder(
          future: DefaultAssetBundle.of(context).loadString('lib/data.json'),
          builder: (context, snapshot) {
            var data = json.decode(
              snapshot.data.toString(),
            );
            // print(data);
            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                FlipCard(
                  key: cardKey,
                  flipOnTouch: false,
                  direction: FlipDirection.HORIZONTAL,
                  front: Container(
                    height: 300,
                    width: 300,
                    child: RaisedButton(
                      onPressed: () {
                        canceltimer = true;
                        cardKey.currentState.toggleCard();
                        hi = cardKey.currentState;
                      },
                      child: Container(
                        child: Image.network(
                          fileContent["url"],
                        ),
                      ),
                    ),
                  ),
                  back: Container(
                    height: 300,
                    width: 300,
                    child: RaisedButton(
                      onPressed: () => cardKey.currentState.toggleCard(),
                      child: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Text(
                              "This is " + fileContent["name"],
                            ),
                            SizedBox(height: 10),
                            Text(
                              "It's a " + fileContent["type"],
                            ),
                            SizedBox(height: 10),
                            Text(
                              "Just so you know " + fileContent["sidenote"],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 80,
                ),
                Text("Time Left: " + showtimer + " seconds"),
                SizedBox(
                  height: 70,
                ),
                RaisedButton(
                  onPressed: () {
                    showanswer = true;
                    cardKey.currentState.toggleCard();
                    canceltimer = true;
                    setState(() {
                      onpressedwrong = true;
                      onpressedcorrect = true;
                    });
                  },
                  child: Text("SHOW ANSWER"),
                ),
                SizedBox(
                  height: 30,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Container(
                      child: RaisedButton(
                        color: Colors.red,
                        onPressed: onpressedwrong,
                        child: Text(
                          "Wrong",
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                      height: 50,
                      width: 100,
                    ),
                    SizedBox(
                      width: 20,
                    ),
                    Container(
                      child: RaisedButton(
                        color: Colors.green,
                        onPressed: onpressedcorrect,
                        child: Text(
                          "Correct",
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                      height: 50,
                      width: 100,
                    ),
                  ],
                ),
                RaisedButton(
                  onPressed: () {
                    if (i == 4) {
                      Navigator.pushReplacement(
                        context,
                        new MaterialPageRoute(
                          builder: (context) => ResultScreen(score: score),
                        ),
                      );
                    } else {
                      print(hi);
                      setState(() {
                        showanswer = false;
                      });

                      cardKey.currentState.toggleCard();
                      print(score);
                      startTimer();
                      i++;
                    }
                  },
                  child: Text("Next"),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    RaisedButton(
                      child: Text("Add Card"),
                      onPressed: () {
                        Navigator.push(
                          context,
                          new MaterialPageRoute(
                            builder: (context) => TestScreen(),
                          ),
                        );
                      },
                    ),
                    RaisedButton(
                      child: Text("Refresh"),
                      onPressed: () {
                        updateinfo();
                        startTimer();
                      },
                    )
                  ],
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
  }
}
