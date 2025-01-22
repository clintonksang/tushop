import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:hive/hive.dart';
import 'package:tushop/domains/models/task_model.dart';
import 'package:uuid/uuid.dart';
import '../../../repository/hive/hive_repo.dart';

class TaskFormPage extends StatefulWidget {
  final TaskModel? taskModel;
  final int? taskKey;

  const TaskFormPage({
    Key? key,
    this.taskModel,
    this.taskKey,
  }) : super(key: key);

  @override
  State<TaskFormPage> createState() => _TaskFormPageState();
}

class _TaskFormPageState extends State<TaskFormPage> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _titleController;
  late TextEditingController _descriptionController;
  late TextEditingController _dateController;
  DateTime? _selectedDate;
  final HiveRepo _hiveRepo = HiveRepo(taskBox: Hive.box<TaskModel>('tasks'));

  bool get isEdit => widget.taskModel != null && widget.taskKey != null;

  @override
  void initState() {
    super.initState();

    _titleController =
        TextEditingController(text: widget.taskModel?.title ?? '');
    _descriptionController =
        TextEditingController(text: widget.taskModel?.description ?? '');
    _selectedDate = widget.taskModel?.date ?? DateTime.now();
    _dateController = TextEditingController(
      text: DateFormat('MMM d, yyyy').format(_selectedDate!),
    );
  }

  Future<void> _selectDate(BuildContext context) async {
    final pickedDate = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2100),
    );

    if (pickedDate != null) {
      setState(() {
        _selectedDate = pickedDate;
        _dateController.text = DateFormat('MMM d, yyyy').format(pickedDate);
      });
    }
  }

  Future<void> _handleSubmit() async {
    if (_formKey.currentState!.validate()) {
      final task = TaskModel(
        id: widget.taskModel?.id ?? Uuid().v4(),
        title: _titleController.text,
        description: _descriptionController.text,
        date: _selectedDate!,
        taskStatus: widget.taskModel?.taskStatus ?? 'pending',
        updatedAt: DateTime.now(),
        isSynced: false,
      );

      try {
        if (isEdit && widget.taskKey != null) {
          await _hiveRepo.updateTask(widget.taskKey as int, task);
        } else {
          await _hiveRepo.addTask(task);
        }
        Navigator.pop(context);
      } catch (e) {
        print('Error saving task: $e');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(isEdit ? 'Edit Task' : 'Create Task'),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _handleSubmit,
        label: Text(isEdit ? 'Save Changes' : 'Add Task'),
        icon: Icon(Icons.save),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextFormField(
                controller: _titleController,
                decoration: InputDecoration(labelText: 'Task Title'),
                validator: (value) =>
                    value == null || value.isEmpty ? 'Title is required' : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _descriptionController,
                decoration: InputDecoration(labelText: 'Task Description'),
                maxLines: 3,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _dateController,
                decoration: InputDecoration(
                  labelText: 'Task Date',
                  suffixIcon: Icon(Icons.calendar_today),
                ),
                readOnly: true,
                onTap: () => _selectDate(context),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
