// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class SyncedNotesModel {
  int? id;
  final int? number;
  final String title;
  final String content;
  final bool isFavorite;
  final DateTime? createdTime;
  SyncedNotesModel({
    this.id,
    this.number,
    required this.title,
    required this.content,
    required this.isFavorite,
    this.createdTime,
  });

  SyncedNotesModel copyWith({
    int? id,
    int? number,
    String? title,
    String? content,
    bool? isFavorite,
    DateTime? createdTime,
  }) {
    return SyncedNotesModel(
      id: id ?? this.id,
      number: number ?? this.number,
      title: title ?? this.title,
      content: content ?? this.content,
      isFavorite: isFavorite ?? this.isFavorite,
      createdTime: createdTime ?? this.createdTime,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      '_id': id,
      'number': number,
      'title': title,
      'content': content,
      'is_favorite': isFavorite,
      'created_time': createdTime?.millisecondsSinceEpoch,
    };
  }

  factory SyncedNotesModel.fromMap(Map<String, dynamic> map) {
    return SyncedNotesModel(
      id: map['_id'] != null ? map['_id'] as int : null,
      number: map['number'] != null ? map['number'] as int : null,
      title: map['title'] as String,
      content: map['content'] as String,
      isFavorite: map['is_favorite'] == 1 ? true : false,
      createdTime: map['created_time'] != null
          ? DateTime.fromMillisecondsSinceEpoch(map['created_time'] as int)
          : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory SyncedNotesModel.fromJson(String source) =>
      SyncedNotesModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'SyncedNotesModel(id: $id, number: $number, title: $title, content: $content, isFavorite: $isFavorite, createdTime: $createdTime)';
  }

  @override
  bool operator ==(covariant SyncedNotesModel other) {
    if (identical(this, other)) return true;

    return other.id == id &&
        other.number == number &&
        other.title == title &&
        other.content == content &&
        other.isFavorite == isFavorite &&
        other.createdTime == createdTime;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        number.hashCode ^
        title.hashCode ^
        content.hashCode ^
        isFavorite.hashCode ^
        createdTime.hashCode;
  }
}
