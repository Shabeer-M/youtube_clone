import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

part 'theme_event.dart';
part 'theme_state.dart';

class ThemeBloc extends Bloc<ThemeEvent, ThemeState> {
  static const String _boxName = 'theme_box';
  static const String _key = 'is_dark_mode';

  ThemeBloc() : super(const ThemeState(ThemeMode.system)) {
    on<LoadTheme>(_onLoadTheme);
    on<ToggleTheme>(_onToggleTheme);
  }

  Future<void> _onLoadTheme(LoadTheme event, Emitter<ThemeState> emit) async {
    final box = await Hive.openBox(_boxName);
    final isMaximized = box.get(_key); // Just checking existence/value

    if (isMaximized == null) {
      emit(const ThemeState(ThemeMode.system));
    } else {
      emit(ThemeState(isMaximized ? ThemeMode.dark : ThemeMode.light));
    }
  }

  Future<void> _onToggleTheme(
    ToggleTheme event,
    Emitter<ThemeState> emit,
  ) async {
    final box = await Hive.openBox(_boxName);
    final newMode = state.themeMode == ThemeMode.dark
        ? ThemeMode.light
        : ThemeMode.dark;
    await box.put(_key, newMode == ThemeMode.dark);
    emit(ThemeState(newMode));
  }
}
