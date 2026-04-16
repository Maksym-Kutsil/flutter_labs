class BowlEntry {
  const BowlEntry({
    required this.id,
    required this.title,
    required this.portionGrams,
    required this.note,
  });

  final String id;
  final String title;
  final int portionGrams;
  final String note;

  BowlEntry copyWith({
    String? id,
    String? title,
    int? portionGrams,
    String? note,
  }) {
    return BowlEntry(
      id: id ?? this.id,
      title: title ?? this.title,
      portionGrams: portionGrams ?? this.portionGrams,
      note: note ?? this.note,
    );
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'id': id,
      'title': title,
      'portionGrams': portionGrams,
      'note': note,
    };
  }

  factory BowlEntry.fromJson(Map<String, dynamic> json) {
    return BowlEntry(
      id: json['id'] as String? ?? '',
      title: json['title'] as String? ?? '',
      portionGrams: json['portionGrams'] as int? ?? 0,
      note: json['note'] as String? ?? '',
    );
  }
}
