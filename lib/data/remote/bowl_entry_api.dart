import 'package:my_project/data/remote/api_client.dart';
import 'package:my_project/data/remote/api_endpoints.dart';
import 'package:my_project/data/remote/dto/remote_recipe.dart';
import 'package:my_project/domain/models/bowl_entry.dart';

/// Remote bowl entry endpoints used by [RemoteBowlEntryRepository].
///
/// Backed by the `recipes` resource on dummyjson.com which mocks all the
/// CRUD operations we need (note: the backend does not actually persist
/// mutations; the cached repository keeps a local copy).
class BowlEntryApi {
  BowlEntryApi(this._client);

  static const int _defaultLimit = 10;

  final ApiClient _client;

  Future<List<BowlEntry>> fetchEntries({int limit = _defaultLimit}) async {
    final json = await _client.getJson('${ApiEndpoints.recipes}?limit=$limit');
    final raw = json['recipes'] as List<dynamic>? ?? <dynamic>[];
    return raw
        .whereType<Map<String, dynamic>>()
        .map(RemoteRecipeMapper.fromJson)
        .toList();
  }

  Future<BowlEntry> createEntry(BowlEntry entry) async {
    final json = await _client.postJson(
      ApiEndpoints.addRecipe,
      body: RemoteRecipeMapper.toCreateJson(entry),
    );
    final created = RemoteRecipeMapper.fromJson(json);
    return entry.copyWith(id: created.id);
  }

  Future<BowlEntry> updateEntry(BowlEntry entry) async {
    final json = await _client.putJson(
      ApiEndpoints.recipeById(entry.id),
      body: RemoteRecipeMapper.toUpdateJson(entry),
    );
    final updated = RemoteRecipeMapper.fromJson(json);
    return entry.copyWith(
      title: updated.title,
      portionGrams: updated.portionGrams,
      note: updated.note,
    );
  }

  Future<void> deleteEntry(String id) async {
    await _client.deleteJson(ApiEndpoints.recipeById(id));
  }
}
