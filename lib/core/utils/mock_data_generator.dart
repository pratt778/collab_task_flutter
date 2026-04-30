import 'dart:math';

/// Utility to generate mock task data for UI testing.
class MockDataGenerator {
  static List<Map<String, dynamic>> generateMockTasks({int count = 10}) {
    final statuses = ['todo', 'in_progress', 'done'];
    final labels = ['design', 'urgent', 'bug', 'feature', 'backend'];
    final users = ['user_1', 'user_2', 'user_3'];

    return List.generate(count, (index) {
      final id = 'task_${index + 1}';
      return {
        'id': id,
        'title': 'Task ${index + 1}: ${ _getRandomTitle()}',
        'description': 'This is a description for $id. It contains some details about what needs to be done.',
        'status': statuses[Random().nextInt(statuses.length)],
        'assignees': [users[Random().nextInt(users.length)]],
        'dueDate': DateTime.now().add(Duration(days: Random().nextInt(14))).toIso8601String(),
        'createdAt': DateTime.now().subtract(Duration(days: Random().nextInt(7))).toIso8601String(),
        'updatedAt': DateTime.now().toIso8601String(),
        'labels': [labels[Random().nextInt(labels.length)], labels[Random().nextInt(labels.length)]],
        'checklist': [
          {'id': 'check_${index}_1', 'title': 'Subtask 1', 'completed': Random().nextBool()},
          {'id': 'check_${index}_2', 'title': 'Subtask 2', 'completed': Random().nextBool()},
        ],
      };
    });
  }

  static String _getRandomTitle() {
    final titles = [
      'Design login flow',
      'Set up database',
      'Implement WebSocket',
      'Fix navigation bug',
      'Add dark mode support',
      'Optimize image loading',
      'Write unit tests',
      'Integrate FCM',
      'Update documentation',
      'Review pull request',
    ];
    return titles[Random().nextInt(titles.length)];
  }
}
