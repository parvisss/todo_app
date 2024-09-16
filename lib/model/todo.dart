class Todo {
  final String id;
  final String title;
  final DateTime date;  // `DateTime` type for date
  final bool isDone;

  Todo({
    required this.id,
    required this.title,
    required this.date,
    required this.isDone,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'date': date.toIso8601String().split('T')[0],  // Store only date part
      'isDone': isDone ? 1 : 0,  // SQLite uses 0/1 for booleans
    };
  }

  static Todo fromMap(Map<String, dynamic> map) {
    return Todo(
      id: map['id'],
      title: map['title'],
      date: DateTime.parse(map['date']),  // Parse stored date string
      isDone: map['isDone'] == 1,
    );
  }
}
