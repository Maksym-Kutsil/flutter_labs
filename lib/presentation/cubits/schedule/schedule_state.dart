import 'package:equatable/equatable.dart';

class ScheduleState extends Equatable {
  const ScheduleState({
    this.weekendSnackEnabled = false,
    this.extraPortion = 15,
  });

  final bool weekendSnackEnabled;
  final int extraPortion;

  ScheduleState copyWith({bool? weekendSnackEnabled, int? extraPortion}) {
    return ScheduleState(
      weekendSnackEnabled: weekendSnackEnabled ?? this.weekendSnackEnabled,
      extraPortion: extraPortion ?? this.extraPortion,
    );
  }

  @override
  List<Object?> get props => <Object?>[weekendSnackEnabled, extraPortion];
}
