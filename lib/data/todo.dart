class Todo {
  final int? id;
  final String task;
  final bool completed;

  Todo({
    this.id,
    required this.task,
    this.completed = false,
  });

  // Convert a Todo object into a Map object
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'task': task,
      'completed': completed ? 1 : 0, 
    };
  }

  // Convert a Map object into a Todo object
  static Todo fromMap(Map<String, dynamic> map) {
    return Todo(
      id: map['id'],
      task: map['task'],
      completed: map['completed'] == 1, 
    );
  }
}
