import 'package:flutter/material.dart';
import '../../domains/models/task_model.dart';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../domains/models/task_model.dart';

class TaskCard extends StatelessWidget {
  final TaskModel taskModel;
  final Future<void> Function(TaskModel) onStatusUpdate;
  final VoidCallback onEdit;

  const TaskCard({
    Key? key,
    required this.taskModel,
    required this.onStatusUpdate,
    required this.onEdit,
  }) : super(key: key);

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'done':
        return Colors.green;
      case 'pending':
        return Colors.amber;
      default:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onEdit, // Navigate to edit the task
      child: Container(
        key: Key('task-container-${taskModel.id}'),
        margin: const EdgeInsets.symmetric(vertical: 2, horizontal: 8),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.1),
              spreadRadius: 1,
              blurRadius: 2,
              offset: const Offset(0, 1),
            ),
          ],
        ),
        child: IntrinsicHeight(
          child: Row(
            children: [
              Container(
                key: Key('task-status-bar-${taskModel.id}'),
                width: 7,
                decoration: BoxDecoration(
                  color: _getStatusColor(taskModel.taskStatus),
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(8),
                    bottomLeft: Radius.circular(8),
                  ),
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                    
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Text(
                              taskModel.title,
                              key: Key('task-title-${taskModel.id}'),
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          Row(
                            children: [
                              TextButton(
                                key: Key('task-edit-${taskModel.id}'),
                                onPressed: onEdit,
                                style: TextButton.styleFrom(
                                  minimumSize: Size.zero,
                                  padding: const EdgeInsets.all(8),
                                ),
                                child: const Text(
                                  'Edit',
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      // Task status, date, and checkbox
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            taskModel.taskStatus,
                            key: Key('task-status-${taskModel.id}'),
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                              color: _getStatusColor(taskModel.taskStatus),
                            ),
                          ),
                          Text(
                            DateFormat('MMM d, yyyy').format(taskModel.date),
                            key: Key('task-date-${taskModel.id}'),
                            style: const TextStyle(
                              fontSize: 14,
                              color: Colors.grey,
                            ),
                          ),
                          IconButton(
                            key: Key('task-checkbox-${taskModel.id}'),
                            onPressed: () async {
                              // Toggle task status
                              final newStatus = taskModel.taskStatus == 'done'
                                  ? 'pending'
                                  : 'done';
                              taskModel.taskStatus = newStatus;
                              await onStatusUpdate(taskModel);
                            },
                            icon: Icon(
                              taskModel.taskStatus == 'done'
                                  ? Icons.check_circle
                                  : Icons.check_circle_outline,
                              color: taskModel.taskStatus == 'done'
                                  ? Colors.green
                                  : Colors.grey,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
