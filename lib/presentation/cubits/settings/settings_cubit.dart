import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_project/presentation/cubits/settings/settings_state.dart';

class SettingsCubit extends Cubit<SettingsState> {
  SettingsCubit() : super(const SettingsState());

  void toggleMealReminders(bool value) {
    emit(state.copyWith(mealReminders: value));
  }

  void toggleLowLevelAlerts(bool value) {
    emit(state.copyWith(lowLevelAlerts: value));
  }

  void toggleConnected() {
    emit(state.copyWith(connected: !state.connected));
  }

  void renamePet(String name) {
    final trimmed = name.trim();
    if (trimmed.isEmpty) {
      return;
    }
    emit(state.copyWith(petName: trimmed));
  }
}
