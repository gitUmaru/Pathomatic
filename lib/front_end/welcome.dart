import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:animated_background/animated_background.dart';

class WelcomePage extends StatefulWidget {
  @override
  _WelcomePageState createState() => _WelcomePageState();
}

class _WelcomePageState extends State<WelcomePage>
    with TickerProviderStateMixin {
  @override
  Widget build(BuildContext context) {
    return new WillPopScope(
      // prevents the android "back" button from going to welcome page
      onWillPop: () async => false,
      child: Scaffold(
        body: AnimatedBackground(
          behaviour: RandomParticleBehaviour(),
          vsync: this,
          child: new ListView(
            padding: const EdgeInsets.all(25),
            children: <Widget>[
              SizedBox(height: 190.0),
              Column(
                children: <Widget>[
                  Image.asset('assets/images/InitialLogo.png'),
                  SizedBox(
                    height: 30.0,
                  ),
                  new Container(
                      padding: (EdgeInsets.only(
                        left: 35,
                        right: 35,
                      )),
                      child: Column(children: <Widget>[
                        new Form(
                            child: new Column(children: <Widget>[
                          Padding(
                              padding: EdgeInsets.only(top: 10),
                              child: new Container(
                                  width: 149,
                                  child: RaisedButton(
                                      shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(20.0))),
                                      onPressed: () {
                                        _handleBegin(context);
                                      },
                                      textColor: Colors.white,
                                      color: Colors.lightBlue,
                                      padding: EdgeInsets.fromLTRB(5, 2, 5, 0),
                                      child: Padding(
                                          padding:
                                              EdgeInsets.fromLTRB(0, 0, 0, 0),
                                          child: Row(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            children: <Widget>[
                                              Container(
                                                padding: EdgeInsets.fromLTRB(
                                                    10, 4, 4, 4),
                                                child: Text(
                                                  'BEGIN',
                                                  style: TextStyle(
                                                      color: Colors.white,
                                                      fontSize: 28),
                                                ),
                                              ),
                                              Padding(
                                                padding: EdgeInsets.fromLTRB(
                                                    4, 0, 10, 0),
                                                child: Icon(
                                                  Icons.photo_camera,
                                                  color: Colors.white,
                                                  size: 20,
                                                ),
                                              ),
                                            ],
                                          ))))),
                        ])),
                      ])),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// Alert Dialog
Future<void> _handleBegin(BuildContext context) async {
  return showDialog<void>(
    context: context,
    barrierDismissible: false,
    builder: (BuildContext context) {
      return CupertinoAlertDialog(
        title: Text('"Pathomatic" Would Like to Access the Camera'),
        content: Text(
          'To detect cancer, you need to allow access to your phone\'s camera.',
        ),
        actions: <Widget>[
          CupertinoDialogAction(
            child: Text(
              'Don\'t Allow',
              style: TextStyle(color: Colors.red),
            ),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
          CupertinoDialogAction(
            child: Text(
              'Allow',
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
            onPressed: () {
              // Pushing a named route
              Navigator.of(context).pushNamed(
                '/dashboard',
                arguments: 'You have allowed camera access!',
              );
            },
          ),
        ],
      );
    },
  );
}
