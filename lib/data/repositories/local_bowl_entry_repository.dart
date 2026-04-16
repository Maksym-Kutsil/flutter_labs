import 'dart:convert';

import 'package:my_project/data/local/key_value_storage.dart';
import 'package:my_project/domain/models/bowl_entry.dart';
import 'package:my_project/domain/repositories/bowl_entry_repository.dart';

class LocalBowlEntryRepository implements BowlEntryRepository {
  LocalBowlEntryRepository(this._storage);

  static const String _entriesKey = 'bowl_entries';

  final KeyValueStorage _storage;

  @override
  Future<void> addEntry(BowlEntry entry) async {
    final entries = await getAllEntries();
    final updatedEntries = <BowlEntry>[...entries, entry];
    await _saveEntries(updatedEntries);
  }

  @override
  Future<void> clearEntries() async {
    await _storage.remove(_entriesKey);
  }

  @override
  Future<void> deleteEntry(String id) async {
    final entries = await getAllEntries();
    final updatedEntries = entries.where((entry) => entry.id != id).toList();
    await _saveEntries(updatedEntries);
  }

  @override
  Future<List<BowlEntry>> getAllEntries() async {
    final rawEntries = await _storage.getString(_entriesKey);
    if (rawEntries == null || rawEntries.isEmpty) {
      return <BowlEntry>[];
    }

    final decoded = jsonDecode(rawEntries) as List<dynamic>;
    return decoded
        .map((item) => BowlEntry.fromJson(item as Map<String, dynamic>))
        .toList();
  }

  @override
  Future<void> updateEntry(BowlEntry entry) async {
    final entries = await getAllEntries();
    final updatedEntries = entries.map((currentEntry) {
      if (currentEntry.id == entry.id) {
        return entry;
      }
      return currentEntry;
    }).toList();
    await _saveEntries(updatedEntries);
  }

  Future<void> _saveEntries(List<BowlEntry> entries) async {
    final encoded = jsonEncode(
      entries.map((entry) => entry.toJson()).toList(),
    );
    await _storage.setString(_entriesKey, encoded);
  }
}
