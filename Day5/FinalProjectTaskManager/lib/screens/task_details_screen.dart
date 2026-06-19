import 'package:flutter/material.dart';

import '../models/task.dart';

enum TaskDetailsAction { edit, delete, toggleStatus }

/// Readable summary of a task with its main actions.
class TaskDetailsScreen extends StatelessWidget {
  const TaskDetailsScreen({super.key, required this.task});

  final Task task;

  String _formatDate(DateTime date) {
    final month = date.month.toString().padLeft(2, '0');
    final day = date.day.toString().padLeft(2, '0');
    return '${date.year}-$month-$day';
  }

  @override
  Widget build(BuildContext context) {
    final statusColor = task.isCompleted ? Colors.green : Colors.orange;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Task details'),
        actions: [
          IconButton(
            tooltip: 'Edit task',
            onPressed: () => Navigator.pop(context, TaskDetailsAction.edit),
            icon: const Icon(Icons.edit_outlined),
          ),
          IconButton(
            tooltip: 'Delete task',
            onPressed: () => Navigator.pop(context, TaskDetailsAction.delete),
            icon: const Icon(Icons.delete_outline),
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 700),
              child: Card(
                color: Colors.white,
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: statusColor.withOpacity(0.12),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          task.isCompleted ? 'Completed' : 'Active',
                          style: TextStyle(
                            color: statusColor,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                      const SizedBox(height: 18),
                      Text(
                        task.title,
                        style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                      const SizedBox(height: 24),
                      _DetailRow(
                        icon: Icons.notes,
                        label: 'Description',
                        value: task.description.isEmpty
                            ? 'No description added'
                            : task.description,
                      ),
                      const Divider(height: 32),
                      _DetailRow(
                        icon: Icons.event_outlined,
                        label: 'Due date',
                        value: task.dueDate == null
                            ? 'No due date'
                            : _formatDate(task.dueDate!),
                      ),
                      const Divider(height: 32),
                      _DetailRow(
                        icon: Icons.add_circle_outline,
                        label: 'Created',
                        value: _formatDate(task.createdAt),
                      ),
                      const SizedBox(height: 30),
                      SizedBox(
                        width: double.infinity,
                        child: FilledButton.icon(
                          onPressed: () => Navigator.pop(
                            context,
                            TaskDetailsAction.toggleStatus,
                          ),
                          icon: Icon(
                            task.isCompleted
                                ? Icons.restart_alt
                                : Icons.check_circle_outline,
                          ),
                          label: Text(
                            task.isCompleted
                                ? 'Mark as active'
                                : 'Mark as completed',
                          ),
                          style: FilledButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 15),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _DetailRow extends StatelessWidget {
  const _DetailRow({
    required this.icon,
    required this.label,
    required this.value,
  });

  final IconData icon;
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, color: Theme.of(context).colorScheme.primary),
        const SizedBox(width: 14),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(label, style: Theme.of(context).textTheme.labelLarge),
              const SizedBox(height: 5),
              Text(value, style: Theme.of(context).textTheme.bodyLarge),
            ],
          ),
        ),
      ],
    );
  }
}
