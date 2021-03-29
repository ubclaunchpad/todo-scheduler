import 'package:moor/moor.dart' hide Column;

part 'moor_database.g.dart';

@DataClassName("CalendarItem")
class CalendarItems extends Table {
  //autoincrement automatically sets id as the primary key
  IntColumn get id => integer().autoIncrement()();

  TextColumn get title => text().withLength(min: 1)();

  DateTimeColumn get date => dateTime()();

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

@UseMoor(tables: [CalendarItems, TodoItems])
class LocalDatabase extends _$LocalDatabase {
  LocalDatabase(QueryExecutor queryExecutor) : super(queryExecutor);

  /*
  The "version" of the db. Should be incremented whenever changing/adding
  a table definition.
  */
  @override
  int get schemaVersion => 2;
}

//Data Access Object for TodoItems table
// - Where all queries for the TodoItems table will go
@UseDao(tables: [TodoItems])
class TodoItemDao extends DatabaseAccessor<LocalDatabase>
    with _$TodoItemDaoMixin {
  final LocalDatabase db;

  //This constructor allows local db to create an instance of this DAO
  TodoItemDao(this.db) : super(db);

  Future<List<TodoItem>> getAllTodoItems() => select(todoItems).get();

  //Required since instantiating a Todo Item without id will have a null id
  // - The id is only autoincremented after it is inserted into the local db
  // - So to get the id we must insert it into the db & then retrieve it
  Future<TodoItem> getTodo(String title) =>
      (select(todoItems)..where((todoItem) => todoItem.title.equals(title)))
          .getSingle();

  Stream<List<TodoItem>> watchAllTodoItems() => select(todoItems).watch();

  Future<int> insertTodoItem(TodoItem todoItem) =>
      into(todoItems).insert(todoItem);

  //Replaces the pre-existing TodoItem with the same id as the todoItem argument
  Future<bool> updateTodoItem(TodoItem todoItem) =>
      update(todoItems).replace(todoItem);

  //Deleting based on title of TodoItem
  // - Might not be the best implementation
  Future<int> deleteTodoItem(String title) =>
      (delete(todoItems)..where((todoItem) => todoItem.title.equals(title)))
          .go();
}

//Data Access Object for CalendarItems table
// - Where all queries for the CalendarItems table will go
@UseDao(tables: [CalendarItems])
class CalendarItemDao extends DatabaseAccessor<LocalDatabase>
    with _$CalendarItemDaoMixin {
  final LocalDatabase db;

  CalendarItemDao(this.db) : super(db);

  Future<List<CalendarItem>> getAllCalendarItems() =>
      select(calendarItems).get();

  Future<CalendarItem> getCalendarItem(String title) => (select(calendarItems)
        ..where((calendarItem) => calendarItem.title.equals(title)))
      .getSingle();

  Stream<List<CalendarItem>> watchAllCalendarItems() =>
      select(calendarItems).watch();

  Future<int> insertCalendarItem(CalendarItem calendarItem) =>
      into(calendarItems).insert(calendarItem);

  //Replaces the pre-existing Calendar Item with the same id as the calendarItem argument
  Future<bool> updateCalendarItem(CalendarItem calendarItem) =>
      update(calendarItems).replace(calendarItem);

  //Deleting based on title of TodoItem
  // - Might not be the best implementation
  Future<int> deleteCalendarItem(String title) => (delete(calendarItems)
        ..where((calendarItem) => calendarItem.title.equals(title)))
      .go();
}
