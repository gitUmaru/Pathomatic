import 'package:flutter/material.dart';

import './patients.dart';

class NewTodoView extends StatefulWidget {
  final Todo item;

  NewTodoView({this.item});

  @override
  _NewTodoViewState createState() => _NewTodoViewState();
}

class _NewTodoViewState extends State<NewTodoView> {
  TextEditingController titleController;

  @override
  void initState() {
    super.initState();

    titleController = new TextEditingController(
        text: widget.item != null ? widget.item.title : null);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.lightBlue,
        elevation: 5,
        title: Text(
          widget.item != null ? 'Edit Patient' : 'New Patient',
          key: Key('new-item-title'),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            TextField(
              controller: titleController,
              autofocus: true,
              onEditingComplete: submit,
              decoration: InputDecoration(
                  icon: new Icon(Icons.person),
                  hintText: "e.g. Jane Doe",
                  labelText: "What is your patient's name?"),
            ),
            SizedBox(
              height: 14.0,
            ),
            RaisedButton(
              color: Colors.lightBlue,
              child: Text(
                'Save',
                style: TextStyle(color: Colors.white),
              ),
              elevation: 8,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(10.0),
                      topRight: Radius.circular(10.0))),
              onPressed: () => submit(),
            )
          ],
        ),
      ),
    );
  }

  void submit() {
    Navigator.of(context).pop(titleController.text);
  }
}
