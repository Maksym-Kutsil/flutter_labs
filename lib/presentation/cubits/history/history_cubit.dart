import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_project/presentation/cubits/history/history_event.dart';
import 'package:my_project/presentation/cubits/history/history_state.dart';

class HistoryCubit extends Cubit<HistoryState> {
  HistoryCubit() : super(const HistoryState());

  void setFilter(String filter) {
    emit(state.copyWith(filter: filter));
  }

  void clear() {
    emit(state.copyWith(events: const <HistoryEvent>[]));
  }

  void restore() {
    emit(state.copyWith(events: kDefaultHistoryEvents));
  }
}
