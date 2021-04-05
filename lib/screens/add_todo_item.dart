import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:todo_scheduler/screens/add_calendar_event_screen.dart';
import '../data/moor_database.dart';

/*
class AddTodoItemScreen extends StatelessWidget {
  final LocalDatabase db;

  AddTodoItemScreen(this.db);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Scheduler',
      theme: ThemeData(
        primarySwatch: Colors.purple,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: LayoutBasics(this.db),
    );
  }
}
*/
class AddTodoItemScreen extends StatelessWidget {
  final LocalDatabase db;
  AddTodoItemScreen(this.db);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // TODO: personalize title with user's name
      key: Key("add_todo_item_screen"),
      body: LayoutBasics(this.db),
      //Calendar(title: 'Calendar', db: this.db),
    );
  }
}

class LayoutBasics extends StatefulWidget {
  final LocalDatabase db;

  LayoutBasics(this.db);

  @override
  LayoutBasicsState createState() => LayoutBasicsState(this.db);
}

class LayoutBasicsState extends State<LayoutBasics> {
  final _titleController = TextEditingController();
  final _expDurationController = TextEditingController();
  LocalDatabase db;
  TodoItemDao todoItemDao;

  LayoutBasicsState(LocalDatabase localDb) {
    this.db = localDb;
    this.todoItemDao = TodoItemDao(this.db);
  }

  List<bool> isSelected;
  List<String> urgencyLevel = ['N/A', "ASAP", 'Eventually', 'If there\'s time'];
  int urgencyVal = 0;
  String urgencyOption = "N/A";
  @override
  void initState() {
    isSelected = [false, false, false];
    super.initState();
  }

  void changeText(int val) {
    if (val == 0)
      urgencyOption = 'ASAP';
    else if (val == 1)
      urgencyOption = 'Eventually';
    else if (val == 2) urgencyOption = 'If there\'s time';
  }

  void _addTodoToDB(TodoItem todoItem) async {
    await todoItemDao.insertTodoItem(todoItem);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomPadding: false,
      appBar: AppBar(
        backgroundColor: Colors.deepPurple,
        centerTitle: true,
        title: Text('Add To-Do Item'),
      ),
      body: SingleChildScrollView(
        child: Container(
          color: Colors.white,
          child: SafeArea(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Column(
                    children: [
                      SizedBox(height: 30),
                      new TextFormField(
                        decoration: new InputDecoration(
                          labelText: "Title",
                          fillColor: Colors.deepPurple[50],
                          filled: true,
                          border: new OutlineInputBorder(
                            borderRadius: new BorderRadius.circular(25.0),
                            borderSide: new BorderSide(),
                          ),
                          //fillColor: Colors.green
                        ),
                        validator: (val) {
                          if (val.length == 0) {
                            return "Title cannot be empty";
                          } else {
                            return null;
                          }
                        },
                        keyboardType: TextInputType.emailAddress,
                        style: new TextStyle(
                            fontFamily: "Poppins",
                            fontStyle: FontStyle.italic,
                            fontWeight: FontWeight.w900),
                        controller: _titleController,
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Column(
                    children: [
                      SizedBox(height: 30),
                      new TextFormField(
                        decoration: new InputDecoration(
                          labelText: "Expected Duration",
                          fillColor: Colors.deepPurple[50],
                          filled: true,
                          border: new OutlineInputBorder(
                            borderRadius: new BorderRadius.circular(25.0),
                            borderSide: new BorderSide(),
                          ),
                          //fillColor: Colors.green
                        ),
                        validator: (val) {
                          if (val.length == 0) {
                            return "Duration cannot be empty";
                          } else {
                            return null;
                          }
                        },
                        keyboardType: TextInputType.emailAddress,
                        style: new TextStyle(
                            fontFamily: "Poppins",
                            fontStyle: FontStyle.italic,
                            fontWeight: FontWeight.w900),
                        controller: _expDurationController,
                      ),
                      SizedBox(height: 30),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Column(
                    children: [
                      SizedBox(height: 10),
                      Text("Urgency",
                          style: TextStyle(
                              fontFamily: "Poppins",
                              fontStyle: FontStyle.italic,
                              fontSize: 18)),
                    ],
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Container(
                      color: Colors.deepPurple[50],
                      child: ToggleButtons(
                        isSelected: isSelected,
                        selectedColor: Colors.white,
                        fillColor: Colors.deepPurple,
                        renderBorder: true,
                        borderWidth: 1,
                        borderColor: Colors.black,
                        children: <Widget>[
                          // first toggle button
                          Padding(
                            padding: const EdgeInsets.all(12.0),
                            child: Text(
                              'ASAP',
                              style: new TextStyle(
                                  fontFamily: "Poppins",
                                  fontWeight: FontWeight.w900),
                            ),
                          ),
                          // second toggle button
                          Padding(
                            padding: const EdgeInsets.all(12.0),
                            child: Text(
                              'Eventually',
                              style: new TextStyle(
                                  fontFamily: "Poppins",
                                  fontWeight: FontWeight.w900),
                            ),
                          ),
                          // third toggle button
                          Padding(
                            padding: const EdgeInsets.all(12.0),
                            child: Text(
                              'If there\'s time',
                              style: new TextStyle(
                                  fontFamily: "Poppins",
                                  fontWeight: FontWeight.w900),
                            ),
                          ),
                        ],
                        // logic for button selection below
                        onPressed: (int index) {
                          setState(() {
                            for (int i = 0; i < isSelected.length; i++) {
                              if (i == index) {
                                isSelected[i] = i == index;
                                changeText(index);
                              } else {
                                isSelected[i] = false;
                              }
                            }
                          });
                        },
                      ),
                    ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Column(
                    children: [
                      SizedBox(height: 10),
                      Text("You selected: $urgencyOption",
                          style: TextStyle(
                            fontFamily: "Poppins",
                            fontStyle: FontStyle.italic,
                          )),
                    ],
                  ),
                ),
                Align(
                  alignment: Alignment.bottomRight,
                  child: Column(
                    children: [
                      SizedBox(height: 50),
                      Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: ElevatedButton(
                            //Add to database
                            onPressed: () {
                              TodoItem todoItem = TodoItem(
                                  title: _titleController.text,
                                  duration:
                                      int.parse(_expDurationController.text),
                                  dateAdded: DateTime.now());

                              _addTodoToDB(todoItem);
                            },
                            style: ElevatedButton.styleFrom(
                              elevation: 10,
                              primary: Colors.deepPurple, // background
                              onPrimary: Colors.white, // foreground
                            ),
                            child: Text(' SUBMIT')),
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
