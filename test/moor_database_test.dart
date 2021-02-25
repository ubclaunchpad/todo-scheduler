import 'package:moor_ffi/moor_ffi.dart';
import 'package:test/test.dart';
import '../lib/data/moor_database.dart';

void main() {
  LocalDatabase localdb;
  TodoItemDao todoItemDao;

  setUp(() {
    localdb = LocalDatabase(VmDatabase.memory());
    todoItemDao = TodoItemDao(localdb);
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

  tearDown(() async {
    await localdb.close();
  });
}
