import 'package:flutter/material.dart';

import '../models/task.dart';
import '../services/task_service.dart';
import 'add_edit_task_screen.dart';
import 'task_details_screen.dart';

/// Home screen owns the task list and refreshes it with setState.
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TaskService _taskService = TaskService();

  List<Task> get _tasks => _taskService.tasks;

  void _showMessage(String message) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text(message)));
  }

  Future<void> _addTask() async {
    final task = await Navigator.push<Task>(
      context,
      MaterialPageRoute(builder: (_) => const AddEditTaskScreen()),
    );

    if (task != null && mounted) {
      setState(() => _taskService.addTask(task));
      _showMessage('Task added');
    }
  }

  Future<void> _editTask(Task task) async {
    final updatedTask = await Navigator.push<Task>(
      context,
      MaterialPageRoute(builder: (_) => AddEditTaskScreen(task: task)),
    );

    if (updatedTask != null && mounted) {
      setState(() => _taskService.updateTask(updatedTask));
      _showMessage('Task updated');
    }
  }

  Future<void> _deleteTask(Task task) async {
    final shouldDelete = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Delete task?'),
        content: Text('“${task.title}” will be permanently removed.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, false),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(dialogContext, true),
            child: const Text('Delete'),
          ),
        ],
      ),
    );

    if (shouldDelete == true && mounted) {
      setState(() => _taskService.deleteTask(task.id));
      _showMessage('Task deleted');
    }
  }

  void _toggleTask(Task task) {
    setState(() => _taskService.toggleTaskStatus(task.id));
    _showMessage(
      task.isCompleted ? 'Task marked as active' : 'Task completed',
    );
  }

  Future<void> _openDetails(Task task) async {
    final action = await Navigator.push<TaskDetailsAction>(
      context,
      MaterialPageRoute(builder: (_) => TaskDetailsScreen(task: task)),
    );

    if (!mounted || action == null) {
      return;
    }

    switch (action) {
      case TaskDetailsAction.edit:
        await _editTask(task);
        break;
      case TaskDetailsAction.delete:
        await _deleteTask(task);
        break;
      case TaskDetailsAction.toggleStatus:
        _toggleTask(task);
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    final completedCount = _tasks.where((task) => task.isCompleted).length;

    return Scaffold(
      appBar: AppBar(
        title: const Text('My tasks'),
        centerTitle: false,
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _addTask,
        icon: const Icon(Icons.add),
        label: const Text('Add task'),
      ),
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 760),
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 88),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  _TaskSummary(
                    totalCount: _tasks.length,
                    completedCount: completedCount,
                  ),
                  const SizedBox(height: 18),
                  Expanded(
                    child: _tasks.isEmpty
                        ? _EmptyTaskList(onAddTask: _addTask)
                        : ListView.separated(
                            itemCount: _tasks.length,
                            separatorBuilder: (_, __) =>
                                const SizedBox(height: 10),
                            itemBuilder: (context, index) {
                              final task = _tasks[index];
                              return _TaskCard(
                                task: task,
                                onTap: () => _openDetails(task),
                                onToggle: () => _toggleTask(task),
                                onEdit: () => _editTask(task),
                                onDelete: () => _deleteTask(task),
                              );
                            },
                          ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _TaskSummary extends StatelessWidget {
  const _TaskSummary({required this.totalCount, required this.completedCount});

  final int totalCount;
  final int completedCount;

  @override
  Widget build(BuildContext context) {
    final activeCount = totalCount - completedCount;

    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.primaryContainer,
        borderRadius: BorderRadius.circular(18),
      ),
      child: Row(
        children: [
          Expanded(
            child: _SummaryItem(
              value: '$totalCount',
              label: totalCount == 1 ? 'Task' : 'Tasks',
            ),
          ),
          const SizedBox(height: 38, child: VerticalDivider()),
          Expanded(
            child: _SummaryItem(value: '$activeCount', label: 'Active'),
          ),
          const SizedBox(height: 38, child: VerticalDivider()),
          Expanded(
            child: _SummaryItem(value: '$completedCount', label: 'Completed'),
          ),
        ],
      ),
    );
  }
}

class _SummaryItem extends StatelessWidget {
  const _SummaryItem({required this.value, required this.label});

  final String value;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          value,
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
        ),
        Text(label, style: Theme.of(context).textTheme.bodySmall),
      ],
    );
  }
}

class _EmptyTaskList extends StatelessWidget {
  const _EmptyTaskList({required this.onAddTask});

  final VoidCallback onAddTask;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.checklist_rounded,
              size: 72,
              color: Theme.of(context).colorScheme.primary.withOpacity(0.5),
            ),
            const SizedBox(height: 16),
            Text(
              'No tasks yet',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 6),
            const Text(
              'Add your first task and keep your day organized.',
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 18),
            OutlinedButton.icon(
              onPressed: onAddTask,
              icon: const Icon(Icons.add),
              label: const Text('Create a task'),
            ),
          ],
        ),
      ),
    );
  }
}

class _TaskCard extends StatelessWidget {
  const _TaskCard({
    required this.task,
    required this.onTap,
    required this.onToggle,
    required this.onEdit,
    required this.onDelete,
  });

  final Task task;
  final VoidCallback onTap;
  final VoidCallback onToggle;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  String _formatDate(DateTime date) {
    final month = date.month.toString().padLeft(2, '0');
    final day = date.day.toString().padLeft(2, '0');
    return '${date.year}-$month-$day';
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.white,
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
          child: Row(
            children: [
              Checkbox(
                value: task.isCompleted,
                onChanged: (_) => onToggle(),
                semanticLabel: task.isCompleted
                    ? 'Mark ${task.title} active'
                    : 'Mark ${task.title} completed',
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 6),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        task.title,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.w600,
                              decoration: task.isCompleted
                                  ? TextDecoration.lineThrough
                                  : null,
                              color: task.isCompleted ? Colors.grey : null,
                            ),
                      ),
                      if (task.description.isNotEmpty) ...[
                        const SizedBox(height: 3),
                        Text(
                          task.description,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                      ],
                      if (task.dueDate != null) ...[
                        const SizedBox(height: 5),
                        Row(
                          children: [
                            const Icon(Icons.event_outlined, size: 15),
                            const SizedBox(width: 4),
                            Text(
                              'Due ${_formatDate(task.dueDate!)}',
                              style: Theme.of(context).textTheme.bodySmall,
                            ),
                          ],
                        ),
                      ],
                    ],
                  ),
                ),
              ),
              PopupMenuButton<String>(
                tooltip: 'Task actions',
                onSelected: (value) {
                  if (value == 'edit') {
                    onEdit();
                  } else {
                    onDelete();
                  }
                },
                itemBuilder: (_) => const [
                  PopupMenuItem(
                    value: 'edit',
                    child: ListTile(
                      leading: Icon(Icons.edit_outlined),
                      title: Text('Edit'),
                      contentPadding: EdgeInsets.zero,
                    ),
                  ),
                  PopupMenuItem(
                    value: 'delete',
                    child: ListTile(
                      leading: Icon(Icons.delete_outline),
                      title: Text('Delete'),
                      contentPadding: EdgeInsets.zero,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
