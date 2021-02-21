import 'package:flutter/rendering.dart';
import 'package:moor_flutter/moor_flutter.dart';

part 'moor_database.g.dart';

//Table for Calendar Items
@DataClassName("CalendarItem")
class CalendarItems extends Table {
  //autoincrement automatically sets id as the primary key
  IntColumn get id => integer().autoIncrement()();

  TextColumn get title => text().withLength(min: 1)();

  DateTimeColumn get startTime => dateTime()();

  DateTimeColumn get endTime => dateTime()();
}

//Table for Todo Items
@DataClassName("TodoItem")
class TodoItems extends Table {
  IntColumn get id => integer().autoIncrement()();

  TextColumn get title => text().withLength(min: 1)();

  //Duration is measured in seconds (since we are sticking mainly to shorter tasks)
  IntColumn get duration => integer()();

  DateTimeColumn get dateAdded => dateTime()();
}

//TODO: Set logStatements to false for production
@UseMoor(tables: [CalendarItems, TodoItems])
class LocalDatabase extends _$LocalDatabase {
  LocalDatabase()
      : super((FlutterQueryExecutor.inDatabaseFolder(
            path: 'db.sqlite', logStatements: true)));

  /*
  The "version" of the db. Should be incremented whenever changing/adding
  a table definition.
  */
  @override
  int get schemaVersion => 1;
}

//Data Access Object for TodoItems table
// - Where all queries for the TodoItems table will go
@UseDao(tables: [TodoItems])
class TodoItemDao extends DatabaseAccessor<LocalDatabase>
    with _$TodoItemDaoMixin {
  final LocalDatabase db;

  //This constructor allows local db to create an instance of this DAO
  TodoItemDao(this.db) : super(db);

  //Get all items
  Future<List<TodoItem>> getAllTodoItems() => select(todoItems).get();
  //Watches for changes in the items
  Stream<List<TodoItem>> watchAllTodoItems() => select(todoItems).watch();
  //Inserts an item
  Future<int> insertTodoItem(TodoItem todoItem) =>
      into(todoItems).insert(todoItem);
  //Updates an item
  Future<bool> updateTodoItem(TodoItem todoItem) =>
      update(todoItems).replace(todoItem);
  //Deletes an item
  Future<int> deleteTodoItem(TodoItem todoItem) =>
      delete(todoItems).delete(todoItem);
}

@UseDao(tables: [CalendarItems])
class CalendarItemDao extends DatabaseAccessor<LocalDatabase>
    with _$CalendarItemDaoMixin {
  final LocalDatabase db;

  CalendarItemDao(this.db) : super(db);

  //Get all items
  Future<List<CalendarItem>> getAllCalendarItems() =>
      select(calendarItems).get();
  //Watches for changes in the items
  Stream<List<CalendarItem>> watchAllCalendarItems() =>
      select(calendarItems).watch();
  //Inserts an item
  Future<int> insertCalendarItem(CalendarItem calendarItem) =>
      into(calendarItems).insert(calendarItem);
  //Updates an item
  Future<bool> updateCalendarItem(CalendarItem calendarItem) =>
      update(calendarItems).replace(calendarItem);
  //Deletes an item
  Future<int> deleteCalendarItem(CalendarItem calendarItem) =>
      delete(calendarItems).delete(calendarItem);
}
