import 'package:hive/hive.dart';
import '../../domains/models/task_model.dart';

class HiveRepo {
  static const String taskBoxName = 'tasks';

  final Box<TaskModel> _taskBox;

  // Constructor with dependency injection
  HiveRepo({required Box<TaskModel> taskBox}) : _taskBox = taskBox;

  Future<void> addTask(TaskModel task) async {
    await _taskBox.add(task);
  }

  Future<void> updateTask(int key, TaskModel task) async {
    await _taskBox.put(key, task);
  }

  Future<void> deleteTask(String key) async {
    await _taskBox.delete(key);
  }

  Future<void> clearAllTasks() async {
    await _taskBox.clear();
  }

  List<TaskModel> getAllTasks() {
    final tasks = _taskBox.values.toList();
    tasks.sort((a, b) {
      if (a.taskStatus == 'done' && b.taskStatus != 'done') {
        return 1;
      } else if (a.taskStatus != 'done' && b.taskStatus == 'done') {
        return -1;
      } else {
        return b.date.compareTo(a.date);
      }
    });
    return tasks;
  }
}
