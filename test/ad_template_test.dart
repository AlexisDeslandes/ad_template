import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';

extension PumpApp on WidgetTester {
  Future<void> pumpApp(Widget widget) {
    return pumpWidget(
      MultiBlocProvider(
        providers: const [],
        child: MaterialApp(
          home: widget,
        ),
      ),
    );
  }
}
