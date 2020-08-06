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
      body: Container(),
      bottomNavigationBar: BottomAppBar(
        color: Colors.grey[200],
        child: Row(
          children: [
            IconButton(icon: Icon(Icons.cloud_download), onPressed: () {}),
            Spacer(),
            IconButton(icon: Icon(Icons.file_download), onPressed: () {}),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: Colors.lightBlue,
        foregroundColor: Colors.white,
        onPressed: () {
          // Respond to button press
        },
        icon: Icon(Icons.burst_mode),
        label: Text('Stitch'),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }
}
