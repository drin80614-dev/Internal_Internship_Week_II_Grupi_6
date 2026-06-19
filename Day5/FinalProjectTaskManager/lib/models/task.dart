/// Represents one task stored by the application.
class Task {
  const Task({
    required this.id,
    required this.title,
    required this.description,
    required this.createdAt,
    this.dueDate,
    this.isCompleted = false,
  });

  final String id;
  final String title;
  final String description;
  final DateTime createdAt;
  final DateTime? dueDate;
  final bool isCompleted;

  /// Creates a changed copy while keeping the original task immutable.
  Task copyWith({
    String? title,
    String? description,
    DateTime? dueDate,
    bool clearDueDate = false,
    bool? isCompleted,
  }) {
    return Task(
      id: id,
      title: title ?? this.title,
      description: description ?? this.description,
      createdAt: createdAt,
      dueDate: clearDueDate ? null : dueDate ?? this.dueDate,
      isCompleted: isCompleted ?? this.isCompleted,
    );
  }
}
