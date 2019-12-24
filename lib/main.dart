import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flip_card/flip_card.dart';
import 'package:icemate/result.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  bool canceltimer = false;

  @override
  void initState() {
    startTimer();
    super.initState();
  }

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

  int score = 0;
  var hi;
  int i = 0;
  @override
  Widget build(BuildContext context) {
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
                    height: 100,
                    width: 100,
                    child: RaisedButton(
                      onPressed: () {
                        canceltimer = true;
                        cardKey.currentState.toggleCard();
                        hi = cardKey.currentState;
                      },
                      child: Text(
                        data[i]["name"],
                      ),
                    ),
                  ),
                  back: Container(
                      height: 100,
                      width: 100,
                      child: RaisedButton(
                        onPressed: () => cardKey.currentState.toggleCard(),
                        child: Text(
                          data[i]["age"],
                        ),
                      )),
                ),
                SizedBox(
                  height: 170,
                ),
                Text(showtimer),
                SizedBox(
                  height: 70,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Container(
                      child: RaisedButton(
                        color: Colors.red,
                        onPressed: () {
                          cardKey.currentState.toggleCard();
                          score--;
                          canceltimer = true;
                        },
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
                        onPressed: () {
                          cardKey.currentState.toggleCard();
                          score++;
                          canceltimer = true;
                        },
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
                SizedBox(
                  height: 70,
                ),
                RaisedButton(
                  onPressed: () {
                    print(hi);

                    cardKey.currentState.toggleCard();
                    print(score);
                    startTimer();
                    i++;
                    if (i == 5) {
                      Navigator.pushReplacement(
                        context,
                        new MaterialPageRoute(
                          builder: (context) => ResultScreen(score: score),
                        ),
                      );
                    }
                  },
                  child: Text("Next"),
                )
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
