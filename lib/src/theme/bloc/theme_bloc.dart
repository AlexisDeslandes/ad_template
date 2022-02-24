import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ThemeCubit extends Cubit<ThemeData> {
  ThemeCubit(ThemeData initialState) : super(initialState);

  void setTheme(ThemeData theme) => emit(theme);
}
