import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:hive/hive.dart';
import '../../domains/models/task_model.dart';

class TaskSyncService {
  final FirebaseFirestore firestore =
      FirebaseFirestore.instance; // Define Firestore instance
  final Connectivity _connectivity = Connectivity();
  final Box<TaskModel> _taskBox = Hive.box<TaskModel>('tasks');

  /// Check if the network is available
  Future<bool> _isNetworkAvailable() async {
    final result = await _connectivity.checkConnectivity();
    return result != ConnectivityResult.none;
  }
 
// In TaskSyncService
  Future<void> syncTasksToFirebase() async {
    if (!await _isNetworkAvailable()) {
      print('No network connection. Sync postponed.');
      return;
    }

    final unsyncedTasks =
        _taskBox.values.where((task) => !task.isSynced).toList();
    print('Found ${unsyncedTasks.length} unsynced tasks');

    for (final task in unsyncedTasks) {
      try {
        await firestore.collection('tasks').doc(task.id).set({
          'id': task.id,
          'title': task.title,
          'taskStatus': task.taskStatus,
          'description': task.description,
          'date': task.date.toIso8601String(),
          'updatedAt': DateTime.now().toIso8601String(),
        });

        // Mark as synced only after successful Firebase update
        task.isSynced = true;
        await task.save();
        print('Successfully synced task: ${task.id}');
      } catch (e) {
        print('Error syncing task ${task.id}: $e');
      }
    }
  }
Future<void> clearAllTasksFromFirebase() async {
  if (!await _isNetworkAvailable()) {
    print('No network connection. Cannot clear tasks from Firebase.');
    return;
  }

  try {
    final batch = firestore.batch();
    var querySnapshot = await firestore.collection('tasks').get();
    for (var doc in querySnapshot.docs) {
      batch.delete(doc.reference);
    }
    await batch.commit();
    print('All tasks cleared from Firebase.');
  } catch (e) {
    print('Error clearing tasks from Firebase: $e');
  }
}

  Stream<List<TaskModel>> streamTasks() {
    return _taskBox.watch().map((event) =>
        _taskBox.values.toList()..sort((a, b) => b.date.compareTo(a.date)));
  }

  Stream<List<TaskModel>> streamTasksFromHive() async* {
    yield* _taskBox.watch().map((event) => _taskBox.values.toList());
  }

  /// Fetch tasks from Firebase and merge with local storage
  Future<void> fetchTasksFromFirebase() async {
    try {
      final querySnapshot = await firestore.collection('tasks').get();

      for (final doc in querySnapshot.docs) {
        final remoteTask = TaskModel(
          id: doc['id'],
          title: doc['title'],
          taskStatus: doc['taskStatus'],
          description: doc['description'],
          date: DateTime.parse(doc['date']),
          updatedAt: DateTime.parse(doc['updatedAt']),
          isSynced: true,
        );
        TaskModel? localTask;
        try {
          localTask = _taskBox.values.firstWhere(
            (task) => task.id == remoteTask.id,
          );
        } catch (e) {
          // Task not found locally
          localTask = null;
        }
        // final localTask = _taskBox.values.firstWhere(
        //   (task) => task.id == remoteTask.id,
        //   orElse: () => null,
        // );

        if (localTask == null) {
          await _taskBox.add(remoteTask);
          print('Task added locally: ${remoteTask.id}');
        } else if (localTask.updatedAt.isBefore(remoteTask.updatedAt)) {
          localTask
            ..title = remoteTask.title
            ..taskStatus = remoteTask.taskStatus
            ..description = remoteTask.description
            ..date = remoteTask.date
            ..updatedAt = remoteTask.updatedAt
            ..isSynced = true;

          await localTask.save();
          print('Task updated locally: ${localTask.id}');
        }
      }

      print('Tasks fetched from Firebase and merged locally!');
    } catch (e) {
      print('Error fetching tasks from Firebase: $e');
    }
  }
}
