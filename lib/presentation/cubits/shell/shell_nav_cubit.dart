import 'package:flutter_bloc/flutter_bloc.dart';

/// Tracks the selected tab inside the authenticated bottom navigation shell.
class ShellNavCubit extends Cubit<int> {
  ShellNavCubit() : super(0);

  void select(int index) {
    if (index == state) {
      return;
    }
    emit(index);
  }
}
