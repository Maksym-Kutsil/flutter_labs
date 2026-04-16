import 'package:my_project/domain/models/bowl_entry.dart';
import 'package:my_project/domain/repositories/bowl_entry_repository.dart';

class BowlEntryService {
  BowlEntryService(this._repository);

  final BowlEntryRepository _repository;

  Future<List<BowlEntry>> getEntries() async {
    return _repository.getAllEntries();
  }

  Future<void> addEntry(BowlEntry entry) async {
    await _repository.addEntry(entry);
  }

  Future<void> updateEntry(BowlEntry entry) async {
    await _repository.updateEntry(entry);
  }

  Future<void> deleteEntry(String id) async {
    await _repository.deleteEntry(id);
  }

  Future<void> clearEntries() async {
    await _repository.clearEntries();
  }
}
