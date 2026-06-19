import 'package:flutter_test/flutter_test.dart';
import 'package:final_project_task_manager/models/task.dart';
import 'package:final_project_task_manager/services/task_service.dart';

void main() {
  test('task service supports add, update, toggle, and delete', () {
    final service = TaskService();
    final task = Task(
      id: '1',
      title: 'Original task',
      description: '',
      createdAt: DateTime(2026),
    );

    service.addTask(task);
    expect(service.tasks, hasLength(1));

    service.updateTask(task.copyWith(title: 'Updated task'));
    expect(service.tasks.single.title, 'Updated task');

    service.toggleTaskStatus(task.id);
    expect(service.tasks.single.isCompleted, isTrue);

    service.deleteTask(task.id);
    expect(service.tasks, isEmpty);
  });
}
