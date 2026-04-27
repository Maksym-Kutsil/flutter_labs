import 'package:equatable/equatable.dart';
import 'package:my_project/domain/models/bowl_entry.dart';

enum BowlEntriesStatus { initial, loading, loaded, error }

class BowlEntriesState extends Equatable {
  const BowlEntriesState({
    this.status = BowlEntriesStatus.initial,
    this.entries = const <BowlEntry>[],
    this.errorMessage,
  });

  final BowlEntriesStatus status;
  final List<BowlEntry> entries;
  final String? errorMessage;

  BowlEntriesState copyWith({
    BowlEntriesStatus? status,
    List<BowlEntry>? entries,
    String? errorMessage,
    bool clearError = false,
  }) {
    return BowlEntriesState(
      status: status ?? this.status,
      entries: entries ?? this.entries,
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
    );
  }

  @override
  List<Object?> get props => <Object?>[status, entries, errorMessage];
}
