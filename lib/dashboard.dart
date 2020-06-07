import 'package:flutter/material.dart';
import './constants.dart';

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
    return WillPopScope(
      // prevents the Android "Back" button from exiting app
      onWillPop: () async => false,
      child: new Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.lightBlue,
          centerTitle: true,
          elevation: 10,
          title: const Text('Dashboard'),
          leading: IconButton(
            icon: const Icon(Icons.check_circle_outline),
            tooltip: 'Select',
            onPressed: () {},
          ),
          actions: <Widget>[
            PopupMenuButton<String>(
              icon: const Icon(Icons.delete),
              onSelected: choiceAction1,
              itemBuilder: (BuildContext context) {
                return Constants.choices.map((String choice) {
                  return PopupMenuItem<String>(
                    value: choice,
                    child: Text(choice),
                  );
                }).toList();
              },
            )
          ],
        ),
        body: Center(
          child: Text(widget.data),
        ),
        floatingActionButton: FloatingActionButton.extended(
          elevation: 8.0,
          backgroundColor: Colors.lightBlue,
          icon: const Icon(Icons.add),
          label: const Text('Add a photo'),
          onPressed: () {},
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
        bottomNavigationBar: BottomAppBar(
          color: Colors.grey[200],
          child: new Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              PopupMenuButton<String>(
                icon: const Icon(Icons.save),
                onSelected: choiceAction2,
                itemBuilder: (BuildContext context) {
                  return MoreConstants.choices2.map((String choice2) {
                    return PopupMenuItem<String>(
                      value: choice2,
                      child: Text(choice2),
                    );
                  }).toList();
                },
              )
            ],
          ),
        ),
      ),
    );
  }
}

void choiceAction1(String choice) {
  if (choice == Constants.DeleteSelected) {
    print('Delete Selected');
  } else if (choice == Constants.DeleteAll) {
    print('Delete All');
  }
}

void choiceAction2(String choice2) {
  if (choice2 == MoreConstants.SaveSelected) {
    print('Save Selected');
  } else if (choice2 == MoreConstants.SaveAll) {
    print('Save All');
  }
}
