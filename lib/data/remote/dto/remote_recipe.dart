import 'package:my_project/domain/models/bowl_entry.dart';

/// Maps the `recipe` payload returned by dummyjson.com onto the [BowlEntry]
/// domain model used by the rest of the app.
class RemoteRecipeMapper {
  const RemoteRecipeMapper._();

  static BowlEntry fromJson(Map<String, dynamic> json) {
    final id = json['id'];
    final name = json['name'] as String? ?? 'Recipe';
    final calories = json['caloriesPerServing'];
    final instructions = json['instructions'];

    final note = instructions is List
        ? instructions.whereType<String>().join(' ')
        : (instructions as String? ?? '');

    return BowlEntry(
      id: '$id',
      title: name,
      portionGrams: calories is int ? calories : int.tryParse('$calories') ?? 0,
      note: note,
    );
  }

  static Map<String, dynamic> toCreateJson(BowlEntry entry) {
    return <String, dynamic>{
      'name': entry.title,
      'caloriesPerServing': entry.portionGrams,
      'instructions': <String>[entry.note],
    };
  }

  static Map<String, dynamic> toUpdateJson(BowlEntry entry) {
    return <String, dynamic>{
      'name': entry.title,
      'caloriesPerServing': entry.portionGrams,
      'instructions': <String>[entry.note],
    };
  }
}
