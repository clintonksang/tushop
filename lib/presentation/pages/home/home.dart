import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import '../../../repository/hive/hive_repo.dart';
import '../../../repository/sync/syncservice.dart';
import '../../widgets/custom_fab.dart';
import '../../widgets/task_card.dart';
import '../../../domains/models/task_model.dart';
import 'task_form.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final TaskSyncService _taskSyncService = TaskSyncService();
  final HiveRepo _hiveRepo = HiveRepo(taskBox: Hive.box<TaskModel>('tasks'));
  final Connectivity _connectivity = Connectivity();

  bool isOnline = true;
  bool isSyncing = false;
  late Box<TaskModel> _taskBox;

  @override
  void initState() {
    super.initState();
    _taskBox = Hive.box<TaskModel>('tasks');
    _initializeApp();
    _setupTaskListener();
  }

  void _setupTaskListener() {
    _taskBox.listenable().addListener(() {
      if (isOnline && !isSyncing) {
        Future.delayed(const Duration(seconds: 1), () {
          _syncPendingTasks();
        });
      }
    });
  }

  Future<void> _initializeApp() async {
    try {
      final result = await _connectivity.checkConnectivity();
      setState(() {
        isOnline = result != ConnectivityResult.none;
      });

      _connectivity.onConnectivityChanged
          .listen((List<ConnectivityResult> results) {
        final nowOnline =
            results.any((result) => result != ConnectivityResult.none);
        setState(() {
          isOnline = nowOnline;
        });
        if (nowOnline) {
          _syncPendingTasks();
        }
      });

      if (isOnline) {
        await _syncPendingTasks();
      }
    } catch (e) {
      print('Error in _initializeApp: $e');
    }
  }

  int get _unsyncedCount =>
      _taskBox.values.where((task) => !task.isSynced).length;

  Future<void> _syncPendingTasks() async {
    if (!isOnline || isSyncing) return;

    setState(() {
      isSyncing = true;
    });

    try {
      print('Starting sync...');
      print('Unsynced tasks: ${_unsyncedCount}');

      await _taskSyncService.syncTasksToFirebase();

      await _taskSyncService.fetchTasksFromFirebase();

      print('Sync completed');
    } catch (e) {
      print('Error during sync: $e');
    } finally {
      if (mounted) {
        setState(() {
          isSyncing = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            const Text('Tasks'),
            const SizedBox(width: 8),
            Icon(
              isOnline ? Icons.wifi : Icons.wifi_off,
              color: isOnline ? Colors.green : Colors.red,
              size: 20,
            ),
            Expanded(
              child: ValueListenableBuilder<Box<TaskModel>>(
                valueListenable: _taskBox.listenable(),
                builder: (context, box, _) {
                  return Text(
                    isSyncing ? ' Syncing...' : ' All tasks synced',
                    style: TextStyle(
                      color: isSyncing ? Colors.blue : Colors.green,
                      fontWeight: FontWeight.bold,
                    ),
                  );
                },
              ),
            ),
          ],
        ),
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _syncPendingTasks,
            tooltip: 'Sync Tasks',
          ),
          IconButton(
            icon: const Icon(Icons.delete_forever),
            onPressed: _clearAllTasks,
            tooltip: 'Clear All Tasks',
          ),
        ],
      ),
      body: Column(
        children: [
          if (isSyncing)
            const LinearProgressIndicator(
              backgroundColor: Color(0xFFE0E0E0),
              valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
            ),
          Expanded(
            child: ValueListenableBuilder<Box<TaskModel>>(
              valueListenable: _taskBox.listenable(),
              builder: (context, box, _) {
                if (box.isEmpty) {
                  return const Center(
                    child: Text('No tasks yet. Create one!'),
                  );
                }

                final tasks = box.values.toList()
                  ..sort((a, b) => b.date.compareTo(a.date));

                return ListView.builder(
                  itemCount: tasks.length,
                  itemBuilder: (context, index) {
                    final task = tasks[index];
                    return TaskCard(
                      key: ValueKey(task.id),
                      taskModel: task,
                      onStatusUpdate: (updatedTask) async {
                        updatedTask.isSynced = false;
                        await _hiveRepo.updateTask(index, updatedTask);

                        if (isOnline) {
                          _syncPendingTasks();
                        }
                      },
                      onEdit: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => TaskFormPage(
                              taskModel: task,
                              taskKey: task.key,
                            ),
                          ),
                        );
                      },
                    );
                  },
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: CustomFAB(
              text: 'Create New Task',
              onPressed: () async {
                final result = await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) =>
                        const TaskFormPage(taskModel: null, taskKey: 0),
                  ),
                );

                if (result == true) {
                  _syncPendingTasks();
                }
              },
            ),
          ),
          SizedBox(
            height: 30,
          )
        ],
      ),
    );
  }

  Future<void> _clearAllTasks() async {
    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Confirm"),
          content: const Text(
              "Are you sure you want to clear all tasks locally and from cloud?"),
          actions: <Widget>[
            TextButton(
              child: const Text("Cancel"),
              onPressed: () => Navigator.of(context).pop(),
            ),
            TextButton(
              child: const Text("Clear All"),
              onPressed: () async {
                Navigator.of(context).pop();

                setState(() {
                  isSyncing = true;
                });

                await _hiveRepo.clearAllTasks();
                await _taskSyncService.clearAllTasksFromFirebase();

                setState(() {
                  isSyncing = false;
                });
              },
            ),
          ],
        );
      },
    );
  }

  Widget _buildSyncStatus() {
    if (isSyncing) {
      return const Text(
        'Syncing...',
        style: TextStyle(
          color: Colors.blue,
          fontWeight: FontWeight.w500,
        ),
      );
    }

    if (!isOnline) {
      final count = _unsyncedCount;
      return Text(
        '$count items unsynced',
        style: TextStyle(
          color: count > 0 ? Colors.orange : Colors.grey,
          fontWeight: FontWeight.w500,
        ),
      );
    }

    return const Text(
      'Synced',
      style: TextStyle(
        color: Colors.green,
        fontWeight: FontWeight.w500,
      ),
    );
  }
}
