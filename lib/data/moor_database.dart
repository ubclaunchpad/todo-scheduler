import 'package:flutter/rendering.dart';
import 'package:moor_flutter/moor_flutter.dart';

part 'moor_database.g.dart';

class CalendarItems extends Table {
  IntColumn get id => integer().autoIncrement()();

  TextColumn get title => text().withLength(min: 1)();

  DateTimeColumn get startTime => dateTime()();

  DateTimeColumn get endTime => dateTime()();
}

class TodoItems extends Table {
  IntColumn get id => integer().autoIncrement()();

  TextColumn get title => text().withLength(min: 1)();

  //Duration is measured in seconds (since we are sticking mainly to shorter tasks)
  IntColumn get duration => integer()();

  DateTimeColumn get dateAdded => dateTime()();
}

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
