import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_project/application/services/connectivity_service.dart';

/// Tracks the device's online/offline status using [ConnectivityService].
class ConnectivityCubit extends Cubit<bool> {
  ConnectivityCubit(this._service) : super(true) {
    _subscription = _service.onlineStream.listen(_onChange);
    unawaited(refresh());
  }

  final ConnectivityService _service;
  StreamSubscription<bool>? _subscription;

  Future<void> refresh() async {
    final isOnline = await _service.isOnline();
    if (isClosed) {
      return;
    }
    _onChange(isOnline);
  }

  void _onChange(bool isOnline) {
    if (isClosed || isOnline == state) {
      return;
    }
    emit(isOnline);
  }

  @override
  Future<void> close() async {
    await _subscription?.cancel();
    return super.close();
  }
}
