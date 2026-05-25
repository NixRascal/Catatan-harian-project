import 'package:cloud_firestore/cloud_firestore.dart';

import 'journal_mood.dart';

class JournalEntry {
  const JournalEntry({
    required this.id,
    required this.userId,
    required this.title,
    required this.content,
    required this.mood,
    required this.moodLabel,
    required this.category,
    required this.colorTint,
    required this.isFavorite,
    required this.createdAt,
    this.updatedAt,
  });

  final String id;
  final String userId;
  final String title;
  final String content;
  final String mood;
  final String moodLabel;
  final String category;
  final String colorTint;
  final bool isFavorite;
  final DateTime createdAt;
  final DateTime? updatedAt;

  String get displayTitle => title.trim().isEmpty ? 'Tanpa judul' : title;

  String get preview {
    final normalized = content.replaceAll(RegExp(r'\s+'), ' ').trim();
    if (normalized.length <= 92) return normalized;
    return '${normalized.substring(0, 92).trimRight()}...';
  }

  JournalEntry copyWith({
    String? id,
    String? userId,
    String? title,
    String? content,
    String? mood,
    String? moodLabel,
    String? category,
    String? colorTint,
    bool? isFavorite,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return JournalEntry(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      title: title ?? this.title,
      content: content ?? this.content,
      mood: mood ?? this.mood,
      moodLabel: moodLabel ?? this.moodLabel,
      category: category ?? this.category,
      colorTint: colorTint ?? this.colorTint,
      isFavorite: isFavorite ?? this.isFavorite,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  Map<String, dynamic> toUpdateMap() {
    return {
      'title': title.trim(),
      'content': content.trim(),
      'mood': mood,
      'moodLabel': moodLabel,
      'category': category,
      'colorTint': colorTint,
      'isFavorite': isFavorite,
      'updatedAt': FieldValue.serverTimestamp(),
    };
  }

  static Map<String, dynamic> createMap({
    required String userId,
    required String title,
    required String content,
    required String mood,
    required String moodLabel,
    required String category,
    required String colorTint,
    bool isFavorite = false,
  }) {
    return {
      'userId': userId,
      'title': title.trim(),
      'content': content.trim(),
      'mood': mood,
      'moodLabel': moodLabel,
      'category': category,
      'colorTint': colorTint,
      'isFavorite': isFavorite,
      'createdAt': FieldValue.serverTimestamp(),
      'updatedAt': FieldValue.serverTimestamp(),
    };
  }

  factory JournalEntry.fromDoc(
    QueryDocumentSnapshot<Map<String, dynamic>> doc,
  ) {
    return JournalEntry.fromMap(doc.id, doc.data());
  }

  factory JournalEntry.fromSnapshot(
    DocumentSnapshot<Map<String, dynamic>> doc,
  ) {
    return JournalEntry.fromMap(doc.id, doc.data() ?? const {});
  }

  factory JournalEntry.fromMap(String id, Map<String, dynamic> data) {
    final rawMood = _string(data['mood'], fallback: JournalMoods.calm.emoji);
    final hasKnownMood =
        JournalMoods.all.any((mood) => mood.emoji == rawMood);
    final moodOption = hasKnownMood
        ? JournalMoods.byEmoji(rawMood)
        : JournalMoods.calm;
    return JournalEntry(
      id: id,
      userId: _string(data['userId']),
      title: _string(data['title']),
      content: _string(data['content']),
      mood: moodOption.emoji,
      moodLabel: _string(data['moodLabel'], fallback: moodOption.label),
      category: _string(data['category'], fallback: 'Personal'),
      colorTint: _string(data['colorTint'], fallback: 'peach'),
      isFavorite: data['isFavorite'] == true,
      createdAt: _date(data['createdAt']),
      updatedAt: _nullableDate(data['updatedAt']),
    );
  }

  static String _string(dynamic value, {String fallback = ''}) {
    if (value is String && value.trim().isNotEmpty) return value.trim();
    return fallback;
  }

  static DateTime _date(dynamic value) {
    return _nullableDate(value) ?? DateTime.fromMillisecondsSinceEpoch(0);
  }

  static DateTime? _nullableDate(dynamic value) {
    if (value is Timestamp) return value.toDate();
    if (value is DateTime) return value;
    if (value is String) return DateTime.tryParse(value);
    return null;
  }
}
