import 'package:flutter/material.dart';
import 'package:moor_flutter/moor_flutter.dart' hide Column;
import 'package:todo_scheduler/screens/add_todo_item.dart';
import 'package:todo_scheduler/screens/calendar_screen.dart';
import './data/moor_database.dart';

void main() =>
    runApp(TodoCalApp(LocalDatabase(FlutterQueryExecutor.inDatabaseFolder(
        path: 'db.sqlite', logStatements: true))));

class ScheduleItem {
  String eventTitle;
  DateTime startTime;
  DateTime endTime;
  bool eventType; // set to true when type = calendar item
  ScheduleItem(this.eventTitle, this.startTime, this.endTime, this.eventType,
      {int});
  @override
  String toString() {
    return '{ ${this.eventTitle}, ${this.startTime}, ${this.endTime}, ${this.eventType} }';
  }

  compareTo(ScheduleItem sched2) {
    if (this.startTime.isBefore(sched2.startTime)) {
      return -1;
    } else if (this.startTime.isAfter(sched2.startTime)) {
      return 1;
    } else {
      return 0;
    }
  }
}

class TodoCalApp extends StatelessWidget {
  final LocalDatabase db;
  TodoCalApp(this.db);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      key: Key("Home Screen"),
      title: 'To-Do Scheduler',
      home: HomeScreen(this.db),
    );
  }
}

class HomeScreen extends StatefulWidget {
  final LocalDatabase db;
  HomeScreen(this.db);

  @override
  _HomeScreenState createState() => _HomeScreenState(this.db);
}

class _HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin {
  LocalDatabase db;
  CalendarItemDao calendarItemDao;
  TodoItemDao todoItemDao;

  List<CalendarItem> currDayCalendarItems = [];
  List<TodoItem> allTodoItems = new List();

  _HomeScreenState(LocalDatabase localDb) {
    this.db = localDb;
    this.calendarItemDao = CalendarItemDao(this.db);
    this.todoItemDao = TodoItemDao(this.db);
  }

  bool _isSameDate(DateTime date1, DateTime date2) {
    return date1.year == date2.year &&
        date1.month == date2.month &&
        date1.day == date2.day;
  }

  Future<List<CalendarItem>> _getAllCurrDayCalendarItems() async {
    List<CalendarItem> result = [];
    List<CalendarItem> allCalendarItems =
        await calendarItemDao.getAllCalendarItems();
    for (CalendarItem item in allCalendarItems) {
      if (_isSameDate(item.date, DateTime.now())) {
        result.add(item);
      }
    }
    return result;
  }

  List<ScheduleItem> finalSchedule = new List();

  Future<List<TodoItem>> _getAllTodoItems() async {
    List<TodoItem> todoItems = await todoItemDao.getAllTodoItems();
    return todoItems;
  }

  String formatMinutes(String minutes) {
    if (minutes.length == 1) {
      minutes += "0";
    }
    return minutes;
  }

  void initState() {
    super.initState();
    _getAllCurrDayCalendarItems().then((response) {
      setState(() {
        currDayCalendarItems = response;
        return 1;
      });
    }).then((res) {
      return _getAllTodoItems();
    }).then((response) {
      setState(() {
        allTodoItems = response;
        return 1;
      });
    }).then((res) => {finalSchedule = getSchedule()});
  }

  List<ScheduleItem> getSchedule() {
    List<ScheduleItem> todaySched = new List();
    currDayCalendarItems.sort((cal1, cal2) => cal1.compareTo(cal2));
    allTodoItems.sort((todo1, todo2) => todo1.compareTo(todo2));
    // TODO: allow user to customize startMarker and end time ("nineAtNight")
    DateTime startMarker = DateTime.parse("2021-04-10 08:00:00");
    DateTime nineAtNight = DateTime.parse("2021-04-10 21:00:00");
    DateTime endMarker = currDayCalendarItems[0].startTime;
    Duration timeDiff = endMarker.difference(startMarker);
    int i = 0;
    while (startMarker.isBefore(nineAtNight) &&
        (currDayCalendarItems.length > i || allTodoItems.isNotEmpty)) {
      if (allTodoItems.isNotEmpty && startMarker.isBefore(endMarker)) {
        timeDiff = endMarker.difference(startMarker);
        while (allTodoItems.isNotEmpty &&
            timeDiff.inMinutes > 10 &&
            (allTodoItems[0].duration < (timeDiff.inMinutes - 10))) {
          DateTime todoStartTime = startMarker.add(new Duration(minutes: 5));
          ScheduleItem newTodo = new ScheduleItem(
              allTodoItems[0].title,
              todoStartTime,
              todoStartTime
                  .add(new Duration(minutes: allTodoItems[0].duration)),
              false);
          todaySched.add(newTodo);
          startMarker = newTodo.endTime;
          timeDiff = endMarker.difference(startMarker);
          allTodoItems.remove(allTodoItems[0]);
        }
      }

      if (currDayCalendarItems.length > i) {
        ScheduleItem newCalEvent = new ScheduleItem(
            currDayCalendarItems[i].title,
            currDayCalendarItems[i].startTime,
            currDayCalendarItems[i].endTime,
            true);
        todaySched.add(newCalEvent);
        startMarker = newCalEvent.endTime;
        if (currDayCalendarItems.length == i + 1) {
          endMarker = nineAtNight;
        } else {
          endMarker = currDayCalendarItems[i + 1].startTime;
        }
        // timeDiff = endMarker.difference(startMarker);
        i++;
      }
    }
    todaySched.sort((sched1, sched2) => sched1.compareTo(sched2));
    return todaySched;
  }

  @override
  dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Scaffold(
        appBar: AppBar(
            key: Key("Home Screen - App Bar"),
            title: Text('TimeFinder',
                style: TextStyle(fontFamily: "Modern Love"))),
        body: SingleChildScrollView(
          child: Center(
              child: Column(
            children: [
              SizedBox(height: 30),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ConstrainedBox(
                    constraints:
                        BoxConstraints.tightFor(width: 150, height: 50),
                    child: ElevatedButton(
                      key: Key("Home Screen - To-Do List Button"),
                      child: Text("To-Do List"),
                      style: ElevatedButton.styleFrom(
                        primary: Colors.deepPurple[400], // background
                        onPrimary: Colors.white, // foreground
                      ),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => AddTodoItemScreen(this.db)),
                        );
                      },
                    ),
                  ),
                  SizedBox(width: 20),
                  ConstrainedBox(
                    constraints:
                        BoxConstraints.tightFor(width: 150, height: 50),
                    child: ElevatedButton(
                      key: Key("Home Screen - Calendar Button"),
                      child: Text("Calendar"),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => CalendarScreen(this.db)),
                        );
                      },
                    ),
                  )
                ],
              ),
              SizedBox(height: 30),
              Text('Today\'s Schedule',
                  style: TextStyle(
                      fontFamily: "Open Sans",
                      fontStyle: FontStyle.italic,
                      fontWeight: FontWeight.w900,
                      fontSize: 20)),
              SizedBox(height: 10),
              ListView.builder(
                  shrinkWrap: true,
                  physics: const ClampingScrollPhysics(),
                  itemCount: finalSchedule.length, //eventsList
                  padding: const EdgeInsets.all(8),
                  key: Key("Home Page - Events List"),
                  itemBuilder: (context, index) {
                    return Card(
                        key: Key('event'),
                        child: ListTile(
                          title: Text(finalSchedule[index].eventTitle,
                              style: TextStyle(color: Colors.white)),
                          subtitle: Text(
                              finalSchedule[index].startTime.hour.toString() +
                                  ":" +
                                  formatMinutes(finalSchedule[index]
                                      .startTime
                                      .minute
                                      .toString()) +
                                  " - " +
                                  finalSchedule[index].endTime.hour.toString() +
                                  ":" +
                                  formatMinutes(finalSchedule[index]
                                      .endTime
                                      .minute
                                      .toString()),
                              style: TextStyle(color: Colors.black)),
                          tileColor: finalSchedule[index].eventType == true
                              ? Colors.blue
                              : Colors.deepPurple[400],
                        ));
                  })
            ],
          )),
        ),
      ),
    );
  }
}
