import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_project/presentation/cubits/dashboard/dashboard_state.dart';

class DashboardCubit extends Cubit<DashboardState> {
  DashboardCubit() : super(const DashboardState());

  static const int _stepGrams = 10;
  static const int _waterStep = 10;

  void feed() {
    emit(state.copyWith(portionToday: state.portionToday + _stepGrams));
  }

  void useWater() {
    final next = (state.waterLevel - _waterStep).clamp(0, 100);
    emit(state.copyWith(waterLevel: next));
  }

  void refillWater() {
    emit(state.copyWith(waterLevel: 100));
  }
}
