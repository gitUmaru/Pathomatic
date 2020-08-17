import 'package:flutter/material.dart';
import '../back_end/globals.dart' as globals;

class PatientIdentifier extends StatefulWidget {
  PatientIdentifier({
    Key key,
    @required this.data,
  }) : super(key: key);

  final String data;

  @override
  _PatientIdentifierState createState() => _PatientIdentifierState();
}

class _PatientIdentifierState extends State<PatientIdentifier> {

  @override
  void dispose() {
    globals.patientID.dispose();
    globals.email.dispose();
    globals.name.dispose();
    globals.hospital.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomPadding: false,
      appBar: AppBar(
        title: Text('Unique Patient Identifier'),
      ),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(16.0, 0, 16, 30),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            new Flexible(
                child: new TextFormField(
                    controller: globals.patientID,
                    decoration: new InputDecoration(
                        labelText: 'Please enter a unique patient identifier',
                        fillColor: Colors.white,
                        border: new OutlineInputBorder(
                          borderRadius: new BorderRadius.circular(25.0),
                          borderSide: new BorderSide(),
                        )))),
            Text(""),
            Text(""),
            new Flexible(
                child: new TextFormField(
                    controller: globals.email,
                    decoration: new InputDecoration(
                        labelText: 'Please enter your name',
                        fillColor: Colors.white,
                        border: new OutlineInputBorder(
                          borderRadius: new BorderRadius.circular(25.0),
                          borderSide: new BorderSide(),
                        )))),
            Text(""),
            Text(""),
            new Flexible(
                child: new TextFormField(
                    controller: globals.email,
                    decoration: new InputDecoration(
                        labelText: 'Please enter your email',
                        fillColor: Colors.white,
                        border: new OutlineInputBorder(
                          borderRadius: new BorderRadius.circular(25.0),
                          borderSide: new BorderSide(),
                        )))),
            Text(""),
            Text(""),
            new Flexible(
                child: new TextFormField(
                    controller: globals.hospital,
                    decoration: new InputDecoration(
                        labelText: 'Please enter your hospital',
                        fillColor: Colors.white,
                        border: new OutlineInputBorder(
                          borderRadius: new BorderRadius.circular(25.0),
                          borderSide: new BorderSide(),
                        )))),
            Text(""),
            Text(""),
            Text(
              "Note that for every new patient will require you to restart the app and enter a new patient identifier.",
              style: TextStyle(height: 1.5, fontSize: 15.0),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).pushNamed(
            '/dashboard',
            arguments: globals.name.text,
          );
        },
        tooltip: 'Go next',
        child: Icon(Icons.arrow_forward_ios),
      ),
    );
  }
}
