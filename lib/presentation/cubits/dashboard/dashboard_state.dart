import 'package:equatable/equatable.dart';

class DashboardState extends Equatable {
  const DashboardState({this.portionToday = 120, this.waterLevel = 70});

  final int portionToday;
  final int waterLevel;

  String get waterLabel {
    if (waterLevel > 65) {
      return 'Comfortable ($waterLevel%)';
    }
    if (waterLevel > 35) {
      return 'Moderate ($waterLevel%)';
    }
    return 'Low ($waterLevel%)';
  }

  DashboardState copyWith({int? portionToday, int? waterLevel}) {
    return DashboardState(
      portionToday: portionToday ?? this.portionToday,
      waterLevel: waterLevel ?? this.waterLevel,
    );
  }

  @override
  List<Object?> get props => <Object?>[portionToday, waterLevel];
}
