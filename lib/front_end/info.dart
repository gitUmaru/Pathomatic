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
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        backgroundColor: Colors.lightBlue,
        centerTitle: true,
        elevation: 5,
        automaticallyImplyLeading: false,
        title: Text('Identification'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.fromLTRB(20, 40, 20, 0),
          child: Container(
            child: Column(
              children: <Widget>[
                TextFormField(
                    controller: globals.patientID,
                    decoration: new InputDecoration(
                        labelText: 'Please enter a unique patient identifier',
                        fillColor: Colors.white,
                        border: new OutlineInputBorder(
                          borderRadius: new BorderRadius.circular(25.0),
                          borderSide: new BorderSide(),
                        ))),
                Text(""),
                Text(""),
                TextFormField(
                    controller: globals.name,
                    decoration: new InputDecoration(
                        labelText: 'Please enter your name',
                        fillColor: Colors.white,
                        border: new OutlineInputBorder(
                          borderRadius: new BorderRadius.circular(25.0),
                          borderSide: new BorderSide(),
                        ))),
                Text(""),
                Text(""),
                TextFormField(
                    controller: globals.email,
                    decoration: new InputDecoration(
                        labelText: 'Please enter your email',
                        fillColor: Colors.white,
                        border: new OutlineInputBorder(
                          borderRadius: new BorderRadius.circular(25.0),
                          borderSide: new BorderSide(),
                        ))),
                Text(""),
                Text(""),
                TextFormField(
                    controller: globals.hospital,
                    decoration: new InputDecoration(
                        labelText: 'Please enter your hospital',
                        fillColor: Colors.white,
                        border: new OutlineInputBorder(
                          borderRadius: new BorderRadius.circular(25.0),
                          borderSide: new BorderSide(),
                        ))),
                Text(""),
                Text(""),
                Text(
                  "Note that for every new patient you will be required to restart the app and enter a new patient identifier.",
                  style: TextStyle(height: 1.5, fontSize: 14.0),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        elevation: 8.0,
        backgroundColor: Colors.lightBlue,
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
