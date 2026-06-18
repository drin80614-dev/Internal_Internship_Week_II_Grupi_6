import 'package:flutter/material.dart';

void main() {
  runApp(const TaskExpenseTrackerApp());
}

class TaskExpenseTrackerApp extends StatelessWidget {
  const TaskExpenseTrackerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Task Expense Tracker',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.green),
        useMaterial3: true,
      ),
      home: const TaskTrackerScreen(),
    );
  }
}

class TrackerItem {
  TrackerItem({
    required this.title,
    required this.description,
    this.isDone = false,
  });

  final String title;
  final String description;
  bool isDone;
}

class TaskTrackerScreen extends StatefulWidget {
  const TaskTrackerScreen({super.key});

  @override
  State<TaskTrackerScreen> createState() => _TaskTrackerScreenState();
}

class _TaskTrackerScreenState extends State<TaskTrackerScreen> {
  final List<TrackerItem> _items = [
    TrackerItem(
      title: 'Read Flutter lesson',
      description: 'Review widgets, state, and setState.',
    ),
    TrackerItem(
      title: 'Practice UI layout',
      description: 'Build a small card layout with ListView.',
      isDone: true,
    ),
  ];

  int get _doneCount => _items.where((item) => item.isDone).length;

  void _showMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  Future<void> _openAddItemDialog() async {
    final newItem = await showDialog<TrackerItem>(
      context: context,
      builder: (context) => const AddItemDialog(),
    );

    if (newItem == null) {
      return;
    }

    // Add the new item and refresh the list.
    setState(() {
      _items.add(newItem);
    });
    _showMessage('Item added');
  }

  void _deleteItem(int index) {
    final deletedItem = _items[index];

    setState(() {
      _items.removeAt(index);
    });
    _showMessage('${deletedItem.title} deleted');
  }

  void _toggleItemStatus(int index) {
    setState(() {
      _items[index].isDone = !_items[index].isDone;
    });
    _showMessage('Status changed');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Task Expense Tracker'),
        centerTitle: true,
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _openAddItemDialog,
        icon: const Icon(Icons.add),
        label: const Text('Add item'),
      ),
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            final horizontalPadding = constraints.maxWidth > 720 ? 40.0 : 16.0;

            return Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 760),
                child: Padding(
                  padding: EdgeInsets.fromLTRB(
                    horizontalPadding,
                    20,
                    horizontalPadding,
                    90,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      TrackerSummaryCard(
                        totalCount: _items.length,
                        doneCount: _doneCount,
                      ),
                      const SizedBox(height: 18),
                      ElevatedButton.icon(
                        onPressed: _openAddItemDialog,
                        icon: const Icon(Icons.add_task),
                        label: const Text('Create new task'),
                      ),
                      const SizedBox(height: 18),
                      Expanded(
                        child: _items.isEmpty
                            ? const EmptyTrackerMessage()
                            : ListView.builder(
                                itemCount: _items.length,
                                itemBuilder: (context, index) {
                                  final item = _items[index];

                                  return TrackerItemCard(
                                    item: item,
                                    onStatusChanged: () =>
                                        _toggleItemStatus(index),
                                    onDelete: () => _deleteItem(index),
                                  );
                                },
                              ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

class TrackerSummaryCard extends StatelessWidget {
  const TrackerSummaryCard({
    required this.totalCount,
    required this.doneCount,
    super.key,
  });

  final int totalCount;
  final int doneCount;

  @override
  Widget build(BuildContext context) {
    final activeCount = totalCount - doneCount;

    return Card(
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              'Tracker overview',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: SummaryTile(label: 'Total', value: '$totalCount'),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: SummaryTile(label: 'Active', value: '$activeCount'),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: SummaryTile(label: 'Done', value: '$doneCount'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class SummaryTile extends StatelessWidget {
  const SummaryTile({
    required this.label,
    required this.value,
    super.key,
  });

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 14),
      decoration: BoxDecoration(
        color: Colors.green.shade50,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Text(
            value,
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          Text(label),
        ],
      ),
    );
  }
}

class TrackerItemCard extends StatelessWidget {
  const TrackerItemCard({
    required this.item,
    required this.onStatusChanged,
    required this.onDelete,
    super.key,
  });

  final TrackerItem item;
  final VoidCallback onStatusChanged;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Checkbox(
              value: item.isDone,
              onChanged: (_) => onStatusChanged(),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.title,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      decoration:
                          item.isDone ? TextDecoration.lineThrough : null,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    item.description,
                    style: TextStyle(color: Colors.grey.shade700),
                  ),
                  const SizedBox(height: 10),
                  Chip(
                    label: Text(item.isDone ? 'Done' : 'Active'),
                    backgroundColor:
                        item.isDone ? Colors.green.shade100 : Colors.amber.shade100,
                  ),
                ],
              ),
            ),
            IconButton(
              tooltip: 'Delete item',
              onPressed: onDelete,
              icon: const Icon(Icons.delete_outline),
            ),
          ],
        ),
      ),
    );
  }
}

class EmptyTrackerMessage extends StatelessWidget {
  const EmptyTrackerMessage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text(
        'No items yet. Add your first task.',
        textAlign: TextAlign.center,
        style: TextStyle(fontSize: 18),
      ),
    );
  }
}

class AddItemDialog extends StatefulWidget {
  const AddItemDialog({super.key});

  @override
  State<AddItemDialog> createState() => _AddItemDialogState();
}

class _AddItemDialogState extends State<AddItemDialog> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  bool _isDone = false;

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  String? _validateRequiredText(String? value, String fieldName) {
    if (value == null || value.trim().isEmpty) {
      return '$fieldName is required';
    }

    return null;
  }

  void _submitItem() {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    // Return the completed item to the main tracker screen.
    Navigator.of(context).pop(
      TrackerItem(
        title: _titleController.text.trim(),
        description: _descriptionController.text.trim(),
        isDone: _isDone,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Add new item'),
      content: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: _titleController,
                textInputAction: TextInputAction.next,
                decoration: const InputDecoration(
                  labelText: 'Title',
                  border: OutlineInputBorder(),
                ),
                validator: (value) => _validateRequiredText(value, 'Title'),
              ),
              const SizedBox(height: 14),
              TextFormField(
                controller: _descriptionController,
                minLines: 2,
                maxLines: 3,
                decoration: const InputDecoration(
                  labelText: 'Description',
                  border: OutlineInputBorder(),
                ),
                validator: (value) =>
                    _validateRequiredText(value, 'Description'),
              ),
              const SizedBox(height: 10),
              SwitchListTile(
                contentPadding: EdgeInsets.zero,
                title: const Text('Mark as done'),
                value: _isDone,
                onChanged: (value) {
                  setState(() {
                    _isDone = value;
                  });
                },
              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: _submitItem,
          child: const Text('Add item'),
        ),
      ],
    );
  }
}
