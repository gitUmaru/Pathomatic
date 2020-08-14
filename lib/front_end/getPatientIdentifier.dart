import 'package:flutter/material.dart';

class PatientIdentifier extends StatefulWidget {
    PatientIdentifier({
    Key key,
    @required this.data,
  }) : super(key: key);

  final String data;

  @override
  _PatientIdentifierState createState() => _PatientIdentifierState();
}


String patientIdentifier;
class _PatientIdentifierState extends State<PatientIdentifier> {
  final myController = TextEditingController();

  @override
  void dispose() {
    myController.dispose();
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
        child: Row(
        children: <Widget>[
          TextField(
            controller: myController,
          ),
          Text(
            "Please work...",
          )
        ])
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).pushNamed(
            '/dashboard',
            arguments: myController.text,
          );
        },
        tooltip: 'Show me the value!',
        child: Icon(Icons.arrow_forward_ios),
      ),
    );
    patientIdentifier = myController.text;
  }
}