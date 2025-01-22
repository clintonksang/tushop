import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:intl/intl.dart';
import 'package:tushop/domains/models/task_model.dart';
import 'package:tushop/presentation/widgets/task_card.dart';

void main() {
  late TaskModel testTask;
  late Future<void> Function(TaskModel) onStatusUpdate;
  late VoidCallback onEdit;

  setUp(() {
    testTask = TaskModel(
      id: '1',
      title: 'Test Task',
      taskStatus: 'pending',
      date: DateTime(2024, 1, 1),
      description: '',
      updatedAt: DateTime(2024, 1, 1),
    );
    onStatusUpdate = (TaskModel task) async {};
    onEdit = () {};
  });

  Widget createWidgetUnderTest() {
    return MaterialApp(
      home: Scaffold(
        body: TaskCard(
          taskModel: testTask,
          onStatusUpdate: (TaskModel task) async {},
          onEdit: onEdit,
        ),
      ),
    );
  }

  group('TaskCard Widget Tests', () {
    testWidgets('renders all task information correctly',
        (WidgetTester tester) async {
      await tester.pumpWidget(createWidgetUnderTest());

      expect(find.text('Test Task'), findsOneWidget);
      expect(find.text('pending'), findsOneWidget);
      expect(find.text(DateFormat('MMM d, yyyy').format(testTask.date)),
          findsOneWidget);
      expect(find.text('Edit'), findsOneWidget);
    });

    testWidgets('status color changes based on task status',
        (WidgetTester tester) async {
      await tester.pumpWidget(createWidgetUnderTest());

      final statusBar = find.byKey(Key('task-status-bar-1'));
      expect(statusBar, findsOneWidget);

      final Container statusBarContainer = tester.widget<Container>(statusBar);
      final BoxDecoration decoration =
          statusBarContainer.decoration as BoxDecoration;

      expect(decoration.color, Colors.amber);

      testTask.taskStatus = 'done';
      await tester.pumpWidget(createWidgetUnderTest());

      final updatedStatusBar = tester.widget<Container>(statusBar);
      final updatedDecoration = updatedStatusBar.decoration as BoxDecoration;

      expect(updatedDecoration.color, Colors.green);
    });

    testWidgets('checkbox icon changes based on task status',
        (WidgetTester tester) async {
      await tester.pumpWidget(createWidgetUnderTest());

      expect(find.byIcon(Icons.check_circle_outline), findsOneWidget);
      expect(find.byIcon(Icons.check_circle), findsNothing);

      testTask.taskStatus = 'done';
      await tester.pumpWidget(createWidgetUnderTest());

      expect(find.byIcon(Icons.check_circle), findsOneWidget);
      expect(find.byIcon(Icons.check_circle_outline), findsNothing);
    });

    testWidgets('calls onStatusUpdate when checkbox is tapped',
        (WidgetTester tester) async {
      bool onStatusUpdateCalled = false;

      await tester.pumpWidget(MaterialApp(
        home: Scaffold(
          body: TaskCard(
            taskModel: testTask,
            onStatusUpdate: (TaskModel task) async {
              onStatusUpdateCalled = true;
            },
            onEdit: onEdit,
          ),
        ),
      ));

      final checkbox = find.byKey(Key('task-checkbox-1'));
      await tester.tap(checkbox);
      await tester.pump();

      expect(onStatusUpdateCalled, true);
    });

    testWidgets('calls onEdit when edit button is tapped',
        (WidgetTester tester) async {
      bool onEditCalled = false;

      await tester.pumpWidget(MaterialApp(
        home: Scaffold(
          body: TaskCard(
            taskModel: testTask,
            onStatusUpdate: onStatusUpdate,
            onEdit: () {
              onEditCalled = true;
            },
          ),
        ),
      ));

      final editButton = find.byKey(Key('task-edit-1'));
      await tester.tap(editButton);
      await tester.pump();

      expect(onEditCalled, true);
    });

    testWidgets('calls onEdit when card is tapped',
        (WidgetTester tester) async {
      bool onEditCalled = false;

      await tester.pumpWidget(MaterialApp(
        home: Scaffold(
          body: TaskCard(
            taskModel: testTask,
            onStatusUpdate: onStatusUpdate,
            onEdit: () {
              onEditCalled = true;
            },
          ),
        ),
      ));

      final taskContainer = find.byKey(Key('task-container-1'));
      await tester.tap(taskContainer);
      await tester.pump();

      expect(onEditCalled, true);
    });
  });
}
