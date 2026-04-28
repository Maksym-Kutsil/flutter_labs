import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_project/application/services/bowl_entry_service.dart';
import 'package:my_project/domain/models/bowl_entry.dart';
import 'package:my_project/presentation/cubits/bowl_entries/bowl_entries_state.dart';

/// Owns the feeding entries list and exposes CRUD operations to the UI.
class BowlEntriesCubit extends Cubit<BowlEntriesState> {
  BowlEntriesCubit(this._service) : super(const BowlEntriesState());

  final BowlEntryService _service;

  Future<void> load() async {
    emit(state.copyWith(status: BowlEntriesStatus.loading, clearError: true));
    try {
      final entries = await _service.getEntries();
      emit(state.copyWith(status: BowlEntriesStatus.loaded, entries: entries));
    } catch (error) {
      emit(
        state.copyWith(
          status: BowlEntriesStatus.error,
          errorMessage: 'Failed to load entries: $error',
        ),
      );
    }
  }

  Future<void> addEntry(BowlEntry entry) async {
    await _service.addEntry(entry);
    await load();
  }

  Future<void> updateEntry(BowlEntry entry) async {
    await _service.updateEntry(entry);
    await load();
  }

  Future<void> deleteEntry(String id) async {
    await _service.deleteEntry(id);
    await load();
  }

  Future<void> clearEntries() async {
    await _service.clearEntries();
    await load();
  }
}
