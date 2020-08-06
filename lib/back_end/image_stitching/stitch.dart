import 'package:flutter/material.dart';

class Stitchpage extends StatefulWidget {
  Stitchpage({Key key}) : super(key: key);

  @override
  _StitchpageState createState() => _StitchpageState();
}

class _StitchpageState extends State<Stitchpage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.lightBlue,
        elevation: 5,
        title: Text('Image Stitching'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: <Widget>[
            FloatingActionButton.extended(
              backgroundColor: const Color(0xff03dac6),
              foregroundColor: Colors.black,
              onPressed: () {
                // Respond to button press
              },
              icon: Icon(Icons.cloud_download),
              label: Text('Display'),
            ),
            FloatingActionButton.extended(
              backgroundColor: const Color(0xff03dac6),
              foregroundColor: Colors.black,
              onPressed: () {
                // Respond to button press
              },
              icon: Icon(Icons.burst_mode),
              label: Text('Stitch'),
            ),
            FloatingActionButton.extended(
              backgroundColor: const Color(0xff03dac6),
              foregroundColor: Colors.black,
              onPressed: () {
                // Respond to button press
              },
              icon: Icon(Icons.file_download),
              label: Text('Save'),
            ),
          ],
        ),
      ),
    );
  }
}
