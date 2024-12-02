class NoteModel {
  final String id;
  final String userId;
  final String title;
  final String description;
  final DateTime createDate;
  final DateTime updateDate;
  final String category;
  final bool isImportant;

  NoteModel({
    required this.id,
    required this.userId,
    required this.title,
    required this.description,
    required this.createDate,
    required this.updateDate,
    required this.category,
    required this.isImportant,
  });

  // convert NoteModel to Map for database
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'user_id': userId,
      'title': title,
      'description': description,
      'create_date': createDate.toIso8601String(),
      'update_date': updateDate.toIso8601String(),
      'category': category,
      'is_important': isImportant,
    };
  }

  // create NoteModel from Map fetched from the database
  factory NoteModel.fromMap(Map<String, dynamic> map) {
    return NoteModel(
      id: map['id'] as String,
      userId: map['user_id'] as String,
      title: map['title'] as String,
      description: map['description'] as String,
      createDate: DateTime.parse(map['create_date'] as String),
      updateDate: DateTime.parse(map['update_date'] as String),
      category: map['category'] as String,
      isImportant: map['is_important'] as bool,
    );
  }

  // add copyWith method for Update
  NoteModel copyWith({
    String? id,
    String? userId,
    String? title,
    String? description,
    DateTime? createDate,
    DateTime? updateDate,
    String? category,
    bool? isImportant,
  }) {
    return NoteModel(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      title: title ?? this.title,
      description: description ?? this.description,
      createDate: createDate ?? this.createDate,
      updateDate: updateDate ?? this.updateDate,
      category: category ?? this.category,
      isImportant: isImportant ?? this.isImportant,
    );
  }
}