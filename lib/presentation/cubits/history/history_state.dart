import 'package:equatable/equatable.dart';
import 'package:my_project/presentation/cubits/history/history_event.dart';

class HistoryState extends Equatable {
  const HistoryState({
    this.events = kDefaultHistoryEvents,
    this.filter = 'all',
  });

  final List<HistoryEvent> events;
  final String filter;

  List<HistoryEvent> get visibleEvents {
    if (filter == 'all') {
      return events;
    }
    return events.where((event) => event.kind == filter).toList();
  }

  HistoryState copyWith({List<HistoryEvent>? events, String? filter}) {
    return HistoryState(
      events: events ?? this.events,
      filter: filter ?? this.filter,
    );
  }

  @override
  List<Object?> get props => <Object?>[events, filter];
}
