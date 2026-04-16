import 'package:flutter_test/flutter_test.dart';
import 'package:my_project/application/services/auth_service.dart';
import 'package:my_project/application/services/bowl_entry_service.dart';
import 'package:my_project/domain/models/app_user.dart';
import 'package:my_project/domain/models/bowl_entry.dart';
import 'package:my_project/domain/repositories/auth_repository.dart';
import 'package:my_project/domain/repositories/bowl_entry_repository.dart';
import 'package:my_project/main.dart';

void main() {
  testWidgets('Smart Pet Bowl home smoke test', (WidgetTester tester) async {
    final authService = AuthService(_InMemoryAuthRepository());
    final bowlEntryService = BowlEntryService(_InMemoryBowlEntryRepository());

    await tester.pumpWidget(
      MyApp(
        authService: authService,
        bowlEntryService: bowlEntryService,
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Smart Pet Bowl Login'), findsOneWidget);
    expect(find.text('Create local account'), findsOneWidget);
  });
}

class _InMemoryAuthRepository implements AuthRepository {
  AppUser? _user;
  String? _password;

  @override
  Future<AppUser?> getRegisteredUser() async => _user;

  @override
  Future<AppUser?> login({
    required String email,
    required String password,
  }) async {
    if (_user == null || _password == null) {
      return null;
    }
    if (_user!.email == email && _password == password) {
      return _user;
    }
    return null;
  }

  @override
  Future<void> register({
    required AppUser user,
    required String password,
  }) async {
    _user = user;
    _password = password;
  }

  @override
  Future<void> updateUser(AppUser user) async {
    _user = user;
  }
}

class _InMemoryBowlEntryRepository implements BowlEntryRepository {
  final List<BowlEntry> _entries = <BowlEntry>[];

  @override
  Future<void> addEntry(BowlEntry entry) async {
    _entries.add(entry);
  }

  @override
  Future<void> clearEntries() async {
    _entries.clear();
  }

  @override
  Future<void> deleteEntry(String id) async {
    _entries.removeWhere((entry) => entry.id == id);
  }

  @override
  Future<List<BowlEntry>> getAllEntries() async {
    return _entries;
  }

  @override
  Future<void> updateEntry(BowlEntry entry) async {
    final index = _entries.indexWhere((item) => item.id == entry.id);
    if (index == -1) {
      return;
    }
    _entries[index] = entry;
  }
}
