import 'package:flutter/material.dart';

import '../models/task.dart';

/// Form used for both creating a task and editing an existing one.
class AddEditTaskScreen extends StatefulWidget {
  const AddEditTaskScreen({super.key, this.task});

  final Task? task;

  @override
  State<AddEditTaskScreen> createState() => _AddEditTaskScreenState();
}

class _AddEditTaskScreenState extends State<AddEditTaskScreen> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _titleController;
  late final TextEditingController _descriptionController;
  DateTime? _dueDate;

  bool get _isEditing => widget.task != null;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.task?.title ?? '');
    _descriptionController = TextEditingController(
      text: widget.task?.description ?? '',
    );
    _dueDate = widget.task?.dueDate;
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  Future<void> _selectDueDate() async {
    final now = DateTime.now();
    final selectedDate = await showDatePicker(
      context: context,
      initialDate: _dueDate ?? now,
      firstDate: DateTime(now.year - 1),
      lastDate: DateTime(now.year + 10),
    );

    if (selectedDate != null && mounted) {
      setState(() => _dueDate = selectedDate);
    }
  }

  void _saveTask() {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    final existingTask = widget.task;
    final task = existingTask == null
        ? Task(
            id: DateTime.now().microsecondsSinceEpoch.toString(),
            title: _titleController.text.trim(),
            description: _descriptionController.text.trim(),
            createdAt: DateTime.now(),
            dueDate: _dueDate,
          )
        : existingTask.copyWith(
            title: _titleController.text.trim(),
            description: _descriptionController.text.trim(),
            dueDate: _dueDate,
            clearDueDate: _dueDate == null,
          );

    Navigator.pop(context, task);
  }

  String _formatDate(DateTime date) {
    final month = date.month.toString().padLeft(2, '0');
    final day = date.day.toString().padLeft(2, '0');
    return '${date.year}-$month-$day';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(_isEditing ? 'Edit task' : 'New task')),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 640),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    TextFormField(
                      controller: _titleController,
                      autofocus: !_isEditing,
                      textInputAction: TextInputAction.next,
                      decoration: const InputDecoration(
                        labelText: 'Title *',
                        hintText: 'What needs to be done?',
                        prefixIcon: Icon(Icons.task_alt),
                      ),
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'Please enter a task title';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _descriptionController,
                      minLines: 4,
                      maxLines: 7,
                      decoration: const InputDecoration(
                        labelText: 'Description',
                        hintText: 'Add useful notes (optional)',
                        alignLabelWithHint: true,
                        prefixIcon: Icon(Icons.notes),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Card(
                      color: Colors.white,
                      child: ListTile(
                        leading: const Icon(Icons.event_outlined),
                        title: const Text('Due date'),
                        subtitle: Text(
                          _dueDate == null
                              ? 'No due date'
                              : _formatDate(_dueDate!),
                        ),
                        trailing: _dueDate == null
                            ? const Icon(Icons.chevron_right)
                            : IconButton(
                                tooltip: 'Remove due date',
                                onPressed: () => setState(() => _dueDate = null),
                                icon: const Icon(Icons.close),
                              ),
                        onTap: _selectDueDate,
                      ),
                    ),
                    const SizedBox(height: 28),
                    FilledButton.icon(
                      onPressed: _saveTask,
                      icon: const Icon(Icons.save_outlined),
                      label: Text(_isEditing ? 'Update task' : 'Add task'),
                      style: FilledButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
