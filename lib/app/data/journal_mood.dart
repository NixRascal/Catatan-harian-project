import 'package:flutter/material.dart';

class JournalMood {
  const JournalMood({
    required this.emoji,
    required this.label,
    required this.description,
    required this.color,
  });

  final String emoji;
  final String label;
  final String description;
  final Color color;
}

class JournalMoods {
  JournalMoods._();

  static const calm = JournalMood(
    emoji: '\u{1F60A}',
    label: 'Tenang',
    description: 'Kamu paling sering merasa ruangmu cukup.',
    color: Color(0xFFFFD8B5),
  );

  static const all = [
    JournalMood(
      emoji: '\u2728',
      label: 'Bersyukur',
      description: 'Momen kecil terasa cukup berarti.',
      color: Color(0xFFFFF4CC),
    ),
    calm,
    JournalMood(
      emoji: '\u2601\uFE0F',
      label: 'Ringan',
      description: 'Pikiran berjalan pelan dan lapang.',
      color: Color(0xFFE4EDF5),
    ),
    JournalMood(
      emoji: '\u{1F319}',
      label: 'Reflektif',
      description: 'Kamu sedang dekat dengan isi kepala.',
      color: Color(0xFFEDE4FF),
    ),
    JournalMood(
      emoji: '\u{1F327}\uFE0F',
      label: 'Sendu',
      description: 'Ada hal yang butuh ditenangkan.',
      color: Color(0xFFDDEAFE),
    ),
    JournalMood(
      emoji: '\u{1F973}',
      label: 'Bahagia',
      description: 'Hari ini punya alasan untuk dirayakan.',
      color: Color(0xFFFFE4EA),
    ),
    JournalMood(
      emoji: '\u{1F914}',
      label: 'Penasaran',
      description: 'Ada ide yang minta dicatat.',
      color: Color(0xFFE7EEFE),
    ),
    JournalMood(
      emoji: '\u{1F60E}',
      label: 'Percaya diri',
      description: 'Energi hari ini terasa mantap.',
      color: Color(0xFFDDF4E6),
    ),
  ];

  static JournalMood byEmoji(String? emoji) {
    return all.firstWhere(
      (mood) => mood.emoji == emoji,
      orElse: () => calm,
    );
  }

  static JournalMood byLabel(String? label) {
    return all.firstWhere(
      (mood) => mood.label == label,
      orElse: () => calm,
    );
  }

  static List<String> get emojis => all.map((mood) => mood.emoji).toList();
}
