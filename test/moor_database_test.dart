import 'package:moor_ffi/moor_ffi.dart';
import 'package:test/test.dart';
import '../lib/data/moor_database.dart';

void main() {
  LocalDatabase localdb;
  TodoItemDao todoItemDao;
  CalendarItemDao calendarItemDao;

  setUp(() {
    localdb = LocalDatabase(VmDatabase.memory());
    todoItemDao = TodoItemDao(localdb);
    calendarItemDao = CalendarItemDao(localdb);
  });

  test('add one todo item', () async {
    TodoItem cleanDishes = new TodoItem(
        title: "clean dishes", duration: 600, dateAdded: DateTime.now());

    await todoItemDao.insertTodoItem(cleanDishes);

    List<TodoItem> todoItems = await todoItemDao.getAllTodoItems();
    expect(todoItems.length, 1);
    expect(todoItems[0].title, "clean dishes");
    expect(todoItems[0].id, 1);
  });

  test('add multiple todo items', () async {
    TodoItem cleanDishes = new TodoItem(
        title: "clean dishes", duration: 600, dateAdded: DateTime.now());

    TodoItem mopFloor = new TodoItem(
        title: "mop the floor", duration: 900, dateAdded: DateTime.now());

    TodoItem writeTests = new TodoItem(
        title: "write tests for launchpad",
        duration: 9999999,
        dateAdded: DateTime.now());

    TodoItem waterFlowers = new TodoItem(
        title: "water the flowers", duration: 120, dateAdded: DateTime.now());

    await todoItemDao.insertTodoItem(cleanDishes);
    await todoItemDao.insertTodoItem(mopFloor);
    await todoItemDao.insertTodoItem(writeTests);
    await todoItemDao.insertTodoItem(waterFlowers);

    List<TodoItem> todoItems = await todoItemDao.getAllTodoItems();
    expect(todoItems.length, 4);

    expect(todoItems[0].title, "clean dishes");
    expect(todoItems[0].id, 1);

    expect(todoItems[1].title, "mop the floor");
    expect(todoItems[1].id, 2);

    expect(todoItems[2].title, "write tests for launchpad");
    expect(todoItems[2].id, 3);

    expect(todoItems[3].title, "water the flowers");
    expect(todoItems[3].id, 4);
  });

  test('update todo item', () async {
    TodoItem cleanDishes = new TodoItem(
        title: "clean dishes", duration: 600, dateAdded: DateTime.now());

    todoItemDao.insertTodoItem(cleanDishes);
    List<TodoItem> todoItems = await todoItemDao.getAllTodoItems();
    expect(todoItems.length, 1);

    expect(todoItems[0].title, "clean dishes");
    expect(todoItems[0].id, 1);

    TodoItem cleanDishesDB = await todoItemDao.getTodo("clean dishes");

    TodoItem cleanCar = new TodoItem(
        id: cleanDishesDB.id,
        title: "clean the car",
        duration: 1800,
        dateAdded: DateTime.now());

    //Updating
    todoItemDao.updateTodoItem(cleanCar);

    todoItems = await todoItemDao.getAllTodoItems();
    expect(todoItems.length, 1);

    expect(todoItems[0].title, "clean the car");
    expect(todoItems[0].id, 1);
  });

  test('delete todo item', () async {
    TodoItem cleanDishes = new TodoItem(
        title: "clean dishes", duration: 600, dateAdded: DateTime.now());

    TodoItem mopFloor = new TodoItem(
        title: "mop the floor", duration: 900, dateAdded: DateTime.now());

    TodoItem writeTests = new TodoItem(
        title: "write tests for launchpad",
        duration: 9999999,
        dateAdded: DateTime.now());

    await todoItemDao.insertTodoItem(cleanDishes);
    await todoItemDao.insertTodoItem(mopFloor);
    await todoItemDao.insertTodoItem(writeTests);

    List<TodoItem> todoItems = await todoItemDao.getAllTodoItems();
    expect(todoItems.length, 3);

    await todoItemDao.deleteTodoItem("clean dishes");

    todoItems = await todoItemDao.getAllTodoItems();

    todoItems.forEach((todoItem) => {print(todoItem.title)});

    expect(todoItems.length, 2);
    expect(todoItems[0].title, "mop the floor");
    expect(todoItems[0].id, 2);
  });

  test('add one calendar item', () async {
    CalendarItem fillOutTaxes = CalendarItem(
        title: "fill out taxes",
        startTime: DateTime.now(),
        endTime: DateTime.now().add(new Duration(minutes: 10)));

    await calendarItemDao.insertCalendarItem(fillOutTaxes);

    List<CalendarItem> calendarItems =
        await calendarItemDao.getAllCalendarItems();

    expect(calendarItems.length, 1);
    expect(calendarItems[0].title, "fill out taxes");
    expect(calendarItems[0].id, 1);
  });

  test('add multiple calendar items', () async {
    CalendarItem fillOutTaxes = CalendarItem(
        title: "fill out taxes",
        startTime: DateTime.now(),
        endTime: DateTime.now().add(new Duration(minutes: 10)));

    CalendarItem workOut = CalendarItem(
        title: "work out",
        startTime: DateTime.now(),
        endTime: DateTime.now().add(new Duration(minutes: 90)));

    CalendarItem cookChicken = CalendarItem(
        title: "cook that chicken",
        startTime: DateTime.now(),
        endTime: DateTime.now().add(new Duration(minutes: 20)));

    await calendarItemDao.insertCalendarItem(fillOutTaxes);
    await calendarItemDao.insertCalendarItem(workOut);
    await calendarItemDao.insertCalendarItem(cookChicken);

    List<CalendarItem> calendarItems =
        await calendarItemDao.getAllCalendarItems();

    expect(calendarItems.length, 3);
    expect(calendarItems[0].id, 1);
    expect(calendarItems[0].title, "fill out taxes");

    expect(calendarItems[1].id, 2);
    expect(calendarItems[1].title, "work out");

    expect(calendarItems[2].id, 3);
    expect(calendarItems[2].title, "cook that chicken");
  });

  test('update calendar item', () async {
    CalendarItem cookChicken = CalendarItem(
        title: "cook that chicken",
        startTime: DateTime.now(),
        endTime: DateTime.now().add(new Duration(minutes: 20)));

    await calendarItemDao.insertCalendarItem(cookChicken);

    List<CalendarItem> calendarItems =
        await calendarItemDao.getAllCalendarItems();

    expect(calendarItems[0].id, 1);
    expect(calendarItems[0].title, "cook that chicken");

    CalendarItem cookChickenDB =
        await calendarItemDao.getCalendarItem("cook that chicken");

    CalendarItem cookBeef = CalendarItem(
        id: cookChickenDB.id,
        title: "cook da beef",
        startTime: DateTime.now(),
        endTime: DateTime.now().add(new Duration(minutes: 30)));

    await calendarItemDao.updateCalendarItem(cookBeef);

    calendarItems = await calendarItemDao.getAllCalendarItems();

    expect(calendarItems[0].id, 1);
    expect(calendarItems[0].title, "cook da beef");
  });

  test('delete calendar item', () async {
    CalendarItem fillOutTaxes = CalendarItem(
        title: "fill out taxes",
        startTime: DateTime.now(),
        endTime: DateTime.now().add(new Duration(minutes: 10)));

    CalendarItem workOut = CalendarItem(
        title: "work out",
        startTime: DateTime.now(),
        endTime: DateTime.now().add(new Duration(minutes: 90)));

    CalendarItem cookChicken = CalendarItem(
        title: "cook that chicken",
        startTime: DateTime.now(),
        endTime: DateTime.now().add(new Duration(minutes: 20)));

    await calendarItemDao.insertCalendarItem(fillOutTaxes);
    await calendarItemDao.insertCalendarItem(workOut);
    await calendarItemDao.insertCalendarItem(cookChicken);

    List<CalendarItem> calendarItems =
        await calendarItemDao.getAllCalendarItems();

    expect(calendarItems.length, 3);
    expect(calendarItems[0].id, 1);
    expect(calendarItems[0].title, "fill out taxes");

    await calendarItemDao.deleteCalendarItem("fill out taxes");

    calendarItems = await calendarItemDao.getAllCalendarItems();

    expect(calendarItems.length, 2);
    expect(calendarItems[0].id, 2);
    expect(calendarItems[0].title, "work out");
  });

  tearDown(() async {
    await localdb.close();
  });
}
