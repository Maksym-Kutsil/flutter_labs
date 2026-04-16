import 'package:my_project/data/local/key_value_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SharedPrefsStorage implements KeyValueStorage {
  SharedPrefsStorage._(this._prefs);

  final SharedPreferences _prefs;

  static Future<SharedPrefsStorage> create() async {
    final prefs = await SharedPreferences.getInstance();
    return SharedPrefsStorage._(prefs);
  }

  @override
  Future<String?> getString(String key) async {
    return _prefs.getString(key);
  }

  @override
  Future<void> remove(String key) async {
    await _prefs.remove(key);
  }

  @override
  Future<void> setString(String key, String value) async {
    await _prefs.setString(key, value);
  }
}
