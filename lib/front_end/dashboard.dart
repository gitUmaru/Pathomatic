import 'package:flutter/material.dart';
import '../back_end/constants.dart';
import 'package:flutter/cupertino.dart';
import 'package:camera/camera.dart';
import 'home.dart';

List<CameraDescription> cameras;

class DashboardPage extends StatefulWidget {
  DashboardPage({
    Key key,
    @required this.data,
  }) : super(key: key);

  final String data;

  @override
  _DashboardPageState createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
              colors: [Colors.lightBlue, Colors.white],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter),
        ),
        child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Padding(
                padding: EdgeInsets.fromLTRB(30, 175, 0, 30),
                child: Text(
                  "Welcome, ${widget.data} \nPlease select an option:",
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 20.0,
                      fontWeight: FontWeight.w600),
                  textAlign: TextAlign.start,
                ),
              ),
              Padding(
                padding: EdgeInsets.fromLTRB(20, 0, 0, 0),
                child: Row(
                  children: <Widget>[
                    SizedBox(
                      width: 160.0,
                      height: 160.0,
                      child: Card(
                        color: Colors.blueGrey,
                        elevation: 2.0,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30.0)),
                        child: Center(
                            child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            children: <Widget>[
                              IconButton(
                                iconSize: 60,
                                icon: Icon(Icons.camera_alt),
                                onPressed: () {
                                  _handlePhoto(context);
                                },
                              ),
                              SizedBox(
                                height: 10.0,
                              ),
                              Text(
                                "Add Images",
                                style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 20.0),
                              ),
                              SizedBox(
                                height: 5.0,
                              ),
                              Text(
                                "Step 1",
                                style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w100),
                              )
                            ],
                          ),
                        )),
                      ),
                    ),
                    SizedBox(
                      width: 160.0,
                      height: 160.0,
                      child: Card(
                        color: Colors.blueGrey,
                        elevation: 2.0,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30.0)),
                        child: Center(
                            child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            children: <Widget>[
                              IconButton(
                                iconSize: 60,
                                icon: Icon(Icons.filter),
                                onPressed: () {
                                  Navigator.of(context).pushNamed(
                                    '/stichpage',
                                    arguments: 'none',
                                  );
                                },
                              ),
                              SizedBox(
                                height: 10.0,
                              ),
                              Text(
                                "Stich Images",
                                style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 20.0),
                              ),
                              SizedBox(
                                height: 5.0,
                              ),
                              Text(
                                "Step 2",
                                style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w100),
                              )
                            ],
                          ),
                        )),
                      ),
                    ),
                  ],
                ),
              ),
            ]),
      ),
    );
  }
}

// Alert Dialog
Future<void> _handlePhoto(BuildContext context) {
  return showDialog<void>(
    context: context,
    builder: (BuildContext context) {
      return CupertinoAlertDialog(
        title: Text('Please Position Crosshair'),
        content: const Text(
            'Before detecting cancer, ensure your focus area is centered.'),
        actions: <Widget>[
          FlatButton(
            child: Text('OK'),
            onPressed: () {
              Navigator.of(context).pushNamed(
                '/homepage',
                arguments: 'none',
              );
            },
          ),
        ],
      );
    },
  );
}

Future<Null> cameraPage() async {
  WidgetsFlutterBinding.ensureInitialized();
  try {
    cameras = await availableCameras();
  } on CameraException catch (e) {
    print('Error: $e.code\nError Message: $e.message');
  }
  runApp(new CameraApp());
}

class CameraApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'tflite real-time detection',
      theme: ThemeData(
        brightness: Brightness.dark,
      ),
      home: HomePage(cameras),
    );
  }
}
