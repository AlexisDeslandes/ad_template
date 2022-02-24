part of '../router.dart';

class BlocEventBuilder extends Equatable {
  const BlocEventBuilder({required this.type, required this.event});

  final Type type;
  final dynamic event;

  @override
  List<Object?> get props => [type, event];
}
