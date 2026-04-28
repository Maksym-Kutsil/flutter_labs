import 'package:equatable/equatable.dart';

class SettingsState extends Equatable {
  const SettingsState({
    this.mealReminders = true,
    this.lowLevelAlerts = false,
    this.connected = false,
    this.petName = 'Mittens',
  });

  final bool mealReminders;
  final bool lowLevelAlerts;
  final bool connected;
  final String petName;

  SettingsState copyWith({
    bool? mealReminders,
    bool? lowLevelAlerts,
    bool? connected,
    String? petName,
  }) {
    return SettingsState(
      mealReminders: mealReminders ?? this.mealReminders,
      lowLevelAlerts: lowLevelAlerts ?? this.lowLevelAlerts,
      connected: connected ?? this.connected,
      petName: petName ?? this.petName,
    );
  }

  @override
  List<Object?> get props => <Object?>[
    mealReminders,
    lowLevelAlerts,
    connected,
    petName,
  ];
}
