import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_project/presentation/cubits/schedule/schedule_state.dart';

class ScheduleCubit extends Cubit<ScheduleState> {
  ScheduleCubit() : super(const ScheduleState());

  void setWeekendSnackEnabled(bool value) {
    emit(state.copyWith(weekendSnackEnabled: value));
  }

  void setExtraPortion(int value) {
    emit(state.copyWith(extraPortion: value));
  }
}
