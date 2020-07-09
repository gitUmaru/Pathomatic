import 'package:flutter/material.dart';

import 'new_patient.dart';
import 'patients.dart';

class PatientPage extends StatefulWidget {
  PatientPage({
    Key key,
    @required this.data,
  }) : super(key: key);

  final String data;

  @override
  _PatientPageState createState() => _PatientPageState();
}

class _PatientPageState extends State<PatientPage>
    with TickerProviderStateMixin {
  List<Todo> items = new List<Todo>();

  GlobalKey<AnimatedListState> animatedListKey = GlobalKey<AnimatedListState>();

  AnimationController emptyListController;

  @override
  void initState() {
    emptyListController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 200),
    );

    emptyListController.forward();

    super.initState();
  }

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
              icon: const Icon(Icons.arrow_back),
              onPressed: () {
                Navigator.of(context).pushNamed(
                  '/dashboard',
                  arguments: 'Checked out the patients',
                );
              },
            ),
          ),
          floatingActionButton: FloatingActionButton.extended(
            elevation: 8.0,
            backgroundColor: Colors.lightBlue,
            icon: const Icon(Icons.add),
            label: const Text('Add a patient'),
            onPressed: () => goToNewItemView(),
          ),
          body: renderBody()),
    );
  }

  Widget renderBody() {
    if (items.length > 0) {
      return buildListView();
    } else {
      return emptyList();
    }
  }

  Widget emptyList() {
    return Center(
        child: FadeTransition(
            opacity: emptyListController, child: Text('No Patients')));
  }

  Widget buildListView() {
    return AnimatedList(
      key: animatedListKey,
      initialItemCount: items.length,
      itemBuilder: (BuildContext context, int index, animation) {
        return SizeTransition(
          sizeFactor: animation,
          child: buildItem(items[index], index),
        );
      },
    );
  }

  Widget buildItem(Todo item, int index) {
    return Dismissible(
      key: Key('${item.hashCode}'),
      background: Container(color: Colors.red[700]),
      onDismissed: (direction) => removeItemFromList(item, index),
      direction: DismissDirection.startToEnd,
      child: buildListTile(item, index),
    );
  }

  Widget buildListTile(item, index) {
    return ListTile(
      onTap: () => changeItemCompleteness(item),
      onLongPress: () => goToEditItemView(item),
      title: Text(
        item.title,
        key: Key('item-$index'),
        style: TextStyle(
            color: item.completed ? Colors.grey : Colors.black,
            decoration: item.completed ? TextDecoration.lineThrough : null),
      ),
      trailing: Icon(
        item.completed ? Icons.check_box : Icons.check_box_outline_blank,
        key: Key('completed-icon-$index'),
      ),
    );
  }

  void changeItemCompleteness(Todo item) {
    setState(() {
      item.completed = !item.completed;
    });
  }

  void goToNewItemView() {
    // Here we are pushing the new view into the Navigator stack. By using a

    // MaterialPageRoute we get standard behaviour of a Material app, which will

    // show a back button automatically for each platform on the left top corner

    Navigator.of(context).push(MaterialPageRoute(builder: (context) {
      return NewTodoView();
    })).then((title) {
      if (title != null) {
        addItem(Todo(title: title));
      }
    });
  }

  void addItem(Todo item) {
    // Insert an item into the top of our list, on index zero

    items.insert(0, item);

    if (animatedListKey.currentState != null)
      animatedListKey.currentState.insertItem(0);
  }

  void goToEditItemView(Todo item) {
    // We re-use the NewTodoView and push it to the Navigator stack just like

    // before, but now we send the title of the item on the class constructor

    // and expect a new title to be returned so that we can edit the item

    Navigator.of(context).push(MaterialPageRoute(builder: (context) {
      return NewTodoView(item: item);
    })).then((title) {
      if (title != null) {
        editItem(item, title);
      }
    });
  }

  void editItem(Todo item, String title) {
    item.title = title;
  }

  void removeItemFromList(Todo item, int index) {
    animatedListKey.currentState.removeItem(index, (context, animation) {
      return SizedBox(
        width: 0,
        height: 0,
      );
    });

    deleteItem(item);
  }

  void deleteItem(Todo item) {
    // We don't need to search for our item on the list because Dart objects

    // are all uniquely identified by a hashcode. This means we just need to

    // pass our object on the remove method of the list

    items.remove(item);

    if (items.isEmpty) {
      emptyListController.reset();

      setState(() {});

      emptyListController.forward();
    }
  }
}
