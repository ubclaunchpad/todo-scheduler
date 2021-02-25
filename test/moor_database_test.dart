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
        id: 44,
        title: "clean dishes",
        duration: 600,
        dateAdded: DateTime.now());

    await todoItemDao.insertTodoItem(cleanDishes);

    List<TodoItem> todoItems = await todoItemDao.getAllTodoItems();
    expect(todoItems.length, 1);
  });

  tearDown(() async {
    await localdb.close();
  });
}
