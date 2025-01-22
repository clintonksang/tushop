import 'package:flutter_test/flutter_test.dart';
import 'package:hive/hive.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';
import '../../lib/repository/hive/hive_repo.dart';
import '../../lib/domains/models/task_model.dart';
import 'hive_test.mocks.dart';

@GenerateMocks([Box])
void main() {
  late MockBox<TaskModel> mockBox;
  late HiveRepo hiveRepo;

  setUp(() {
    mockBox = MockBox<TaskModel>();
    hiveRepo = HiveRepo(taskBox: mockBox);
  });

  group('HiveRepo Tests', () {
    test('addTask should add a task to Hive', () async {
      final task = TaskModel(
        id: '1',
        title: 'Test Task',
        taskStatus: 'pending',
        description: 'Test Description',
        date: DateTime.now(),
        updatedAt: DateTime.now(),
        isSynced: false,
      );

      when(mockBox.add(task)).thenAnswer((_) async => 1);

      await hiveRepo.addTask(task);

      verify(mockBox.add(task)).called(1);
    });

    test('updateTask should update a task in Hive', () async {
      final task = TaskModel(
        id: '1',
        title: 'Updated Task',
        taskStatus: 'done',
        description: 'Updated Description',
        date: DateTime.now(),
        updatedAt: DateTime.now(),
        isSynced: true,
      );

      await hiveRepo.updateTask(1, task);

      verify(mockBox.put(1, task)).called(1);
    });

    test('clearAllTasks should clear all tasks in Hive', () async {
      when(mockBox.clear()).thenAnswer((_) async => 0);

      await hiveRepo.clearAllTasks();

      verify(mockBox.clear()).called(1);
    });

    test('getAllTasks should return tasks sorted by status and date', () {
      final now = DateTime.now();
      final task1 = TaskModel(
        id: '1',
        title: 'Task 1',
        taskStatus: 'done',
        description: 'Description 1',
        date: now.subtract(const Duration(days: 1)),
        updatedAt: now.subtract(const Duration(days: 1)),
        isSynced: true,
      );
      final task2 = TaskModel(
        id: '2',
        title: 'Task 2',
        taskStatus: 'pending',
        description: 'Description 2',
        date: now,
        updatedAt: now,
        isSynced: false,
      );
      when(mockBox.values).thenReturn([task1, task2]);

      final tasks = hiveRepo.getAllTasks();

      expect(tasks.length, 2);
      expect(tasks.first.id, '2');
      expect(tasks.last.id, '1');
    });
  });
}
