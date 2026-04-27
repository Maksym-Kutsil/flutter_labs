import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:my_project/data/local/key_value_storage.dart';
import 'package:my_project/data/remote/api_client.dart';
import 'package:my_project/data/remote/bowl_entry_api.dart';
import 'package:my_project/data/repositories/cached_bowl_entry_repository.dart';
import 'package:my_project/data/repositories/local_bowl_entry_repository.dart';
import 'package:my_project/domain/models/bowl_entry.dart';

void main() {
  group('CachedBowlEntryRepository', () {
    test('caches API recipes locally and returns them', () async {
      final mock = MockClient((request) async {
        return http.Response(
          jsonEncode(<String, dynamic>{
            'recipes': <Map<String, dynamic>>[
              <String, dynamic>{
                'id': 1,
                'name': 'Salmon meal',
                'caloriesPerServing': 220,
                'instructions': <String>['Mix it'],
              },
            ],
          }),
          200,
          headers: <String, String>{'content-type': 'application/json'},
        );
      });
      final storage = _InMemoryStorage();
      final repo = CachedBowlEntryRepository(
        api: BowlEntryApi(ApiClient(client: mock)),
        localRepository: LocalBowlEntryRepository(storage),
      );

      final entries = await repo.getAllEntries();

      expect(entries, hasLength(1));
      expect(entries.first.title, 'Salmon meal');
      final cached = await LocalBowlEntryRepository(storage).getAllEntries();
      expect(cached.first.title, 'Salmon meal');
    });

    test('falls back to local cache when API fails', () async {
      final storage = _InMemoryStorage();
      final local = LocalBowlEntryRepository(storage);
      await local.addEntry(
        const BowlEntry(
          id: 'local-1',
          title: 'Cached entry',
          portionGrams: 50,
          note: '',
        ),
      );
      final mock = MockClient((request) async {
        throw const SocketLikeException();
      });
      final repo = CachedBowlEntryRepository(
        api: BowlEntryApi(ApiClient(client: mock)),
        localRepository: local,
      );

      final entries = await repo.getAllEntries();

      expect(entries, hasLength(1));
      expect(entries.first.id, 'local-1');
    });
  });
}

class _InMemoryStorage implements KeyValueStorage {
  final Map<String, String> _store = <String, String>{};

  @override
  Future<String?> getString(String key) async => _store[key];

  @override
  Future<void> remove(String key) async => _store.remove(key);

  @override
  Future<void> setString(String key, String value) async =>
      _store[key] = value;
}

class SocketLikeException implements Exception {
  const SocketLikeException();
}
