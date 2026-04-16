import 'package:my_project/domain/models/bowl_entry.dart';

abstract class BowlEntryRepository {
  Future<List<BowlEntry>> getAllEntries();

  Future<void> addEntry(BowlEntry entry);

  Future<void> updateEntry(BowlEntry entry);

  Future<void> deleteEntry(String id);

  Future<void> clearEntries();
}
