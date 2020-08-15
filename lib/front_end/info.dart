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
  final patientID = TextEditingController();
  final name = TextEditingController();
  final email = TextEditingController();
  // TODO: Do we need this? I think that this would be cool for stats
  // final hospitial = TextEditingController();

  @override
  void dispose() {
    patientID.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Unique Patient Identifier'),
      ),
      body: Padding(
          padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text("Please enter your information and read the prompts carefully."),
            Text(
              'Please enter a unique patient identifier. Note that every new patient will require you to restart the app and enter a new patient identifier.',
            ),
            TextField(
              controller: patientID,
            ),
             Text(
              'Please enter your name',
            ),
            TextField(
              controller: name,
            ),
            Text(
              'Please enter your email',
            ),
            TextField(
              controller: email,
            ),
          ],
        ),
        ),
        floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).pushNamed(
            '/dashboard',
            arguments: globals.patientIdentifier = patientID.text,
          );
        },
        tooltip: 'Go next',
        child: Icon(Icons.arrow_forward_ios),
      ),
    );
  }
}
