import 'package:my_project/data/remote/api_client.dart';
import 'package:my_project/data/remote/bowl_entry_api.dart';
import 'package:my_project/domain/models/bowl_entry.dart';
import 'package:my_project/domain/repositories/bowl_entry_repository.dart';

/// Bowl entry repository that talks to [BowlEntryApi] when the device is
/// online and falls back to the wrapped local repository when network calls
/// fail. Successful network responses are mirrored into the local cache so
/// the same data is available offline.
class CachedBowlEntryRepository implements BowlEntryRepository {
  CachedBowlEntryRepository({
    required BowlEntryApi api,
    required BowlEntryRepository localRepository,
  }) : _api = api,
       _local = localRepository;

  final BowlEntryApi _api;
  final BowlEntryRepository _local;

  @override
  Future<List<BowlEntry>> getAllEntries() async {
    final localEntries = await _local.getAllEntries();
    if (localEntries.isNotEmpty) {
      return localEntries;
    }
    try {
      final remoteEntries = await _api.fetchEntries();
      await _replaceLocalCache(remoteEntries);
      return remoteEntries;
    } on ApiException {
      return localEntries;
    } catch (_) {
      return localEntries;
    }
  }

  @override
  Future<void> addEntry(BowlEntry entry) async {
    // The remote backend does not actually persist mutations, so we treat
    // the API response as a validation step and always keep the locally
    // generated id to avoid id collisions across multiple inserts.
    try {
      await _api.createEntry(entry);
    } on ApiException {
      // Offline / server error: still keep the entry locally below.
    } catch (_) {
      // Same as above for unexpected failures (e.g. timeouts).
    }
    await _local.addEntry(entry);
  }

  @override
  Future<void> updateEntry(BowlEntry entry) async {
    try {
      await _api.updateEntry(entry);
    } on ApiException {
      // Ignore: still update locally.
    } catch (_) {
      // Ignore network errors: still update locally.
    }
    await _local.updateEntry(entry);
  }

  @override
  Future<void> deleteEntry(String id) async {
    try {
      await _api.deleteEntry(id);
    } on ApiException {
      // Ignore: delete locally regardless to keep UI consistent.
    } catch (_) {
      // Ignore network failures, still remove locally.
    }
    await _local.deleteEntry(id);
  }

  @override
  Future<void> clearEntries() => _local.clearEntries();

  Future<void> _replaceLocalCache(List<BowlEntry> entries) async {
    await _local.clearEntries();
    for (final entry in entries) {
      await _local.addEntry(entry);
    }
  }
}
