import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:todo_scheduler/screens/calendar_screen.dart';

import 'test_helper.dart';

void main() {
  testWidgets('Calendar Screen Test', (WidgetTester tester) async {
    final calendarScreen = CalendarScreen();
    await tester.pumpWidget(TestHelper.makeTestableWidget(calendarScreen));

    final calendarScreenFinder = find.byKey(Key('calendar_screen'));
    final calendarFinder = find.byKey(Key('calendar_widget'));
    final appBarFinder = find.byKey(Key("calendar_app_bar"));
    final eventFinder = find.byKey(Key('calendar_event'));
    final backIconFinder = find.byKey(Key('calendar_back_to_home_page'));
    final addEventIconFinder = find.byKey(Key('calendar_add_event_icon'));
  });
}
