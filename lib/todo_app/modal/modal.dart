
class TodoModal {
  int userId;
  int id;
  String title;
  bool completed;

  TodoModal({
    required this.userId,
    required this.id,
    required this.title,
    required this.completed,
  });

  factory TodoModal.fromMap(Map<String, dynamic> json) => TodoModal(
    userId: json["userId"],
    id: json["id"],
    title: json["title"],
    completed: json["completed"],
  );

  Map<String, dynamic> toMap() => {
    "userId": userId,
    "id": id,
    "title": title,
    "completed": completed,
  };
}
