import 'package:flutter/material.dart';

class PatientPage extends StatefulWidget {
  PatientPage({
    Key key,
    @required this.data,
  }) : super(key: key);

  final String data;

  @override
  _PatientPageState createState() => _PatientPageState();
}

class _PatientPageState extends State<PatientPage> {
  final GlobalKey<AnimatedListState> _key = GlobalKey();

  List<String> _items = [
    "Bill",
    "Bryan",
    "Bob",
    "Boyle",
  ];

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.lightBlue,
          centerTitle: true,
          elevation: 5,
          title: const Text('Patients'),
          leading: IconButton(
            icon: const Icon(Icons.chevron_left),
            onPressed: () {
              Navigator.of(context).pushNamed(
                '/dashboard',
                arguments: 'Checked out the patients',
              );
            },
          ),
        ),
        body: AnimatedList(
          key: _key,
          initialItemCount: _items.length,
          itemBuilder: (context, index, animation) {
            return _buildItem(_items[index], animation, index);
          },
        ),
        floatingActionButton: FloatingActionButton.extended(
          elevation: 8.0,
          backgroundColor: Colors.lightBlue,
          icon: const Icon(Icons.add),
          label: const Text('Add a patient'),
          onPressed: () => _addItem(),
        ),
      ),
    );
  }

  Widget _buildItem(String item, Animation animation, int index) {
    return SizeTransition(
      sizeFactor: animation,
      child: Card(
        elevation: 4,
        child: ListTile(
          title: Text(
            item,
            style: TextStyle(fontWeight: FontWeight.w600),
          ),
          leading: Icon(Icons.person),
          trailing: IconButton(
            icon: Icon(
              Icons.delete,
              color: Colors.redAccent,
            ),
            onPressed: () {
              _removeItem(index);
            },
          ),
        ),
      ),
    );
  }

  void _removeItem(int i) {
    String removedItem = _items.removeAt(i);
    AnimatedListRemovedItemBuilder builder = (context, animation) {
      return _buildItem(removedItem, animation, i);
    };
    _key.currentState.removeItem(i, builder);
  }

  void _addItem() {
    int i = _items.length > 0 ? _items.length : 0;
    _items.insert(i, 'Patient ${_items.length + 1}');
    _key.currentState.insertItem(i);
  }
}
