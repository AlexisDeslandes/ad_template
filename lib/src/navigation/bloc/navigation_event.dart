part of '../navigation.dart';

class NavigationEvent extends Equatable {
  const NavigationEvent();

  @override
  List<Object?> get props => [];
}

class PopNavigation extends NavigationEvent {
  const PopNavigation();
}

class PushNavigation extends NavigationEvent {
  const PushNavigation(this.navStackElement);

  final NavigationStackElement navStackElement;

  @override
  List<Object?> get props => [navStackElement];
}

class ChangeModule extends NavigationEvent {
  const ChangeModule(this.module);

  final NavigationModule module;

  @override
  List<Object?> get props => [module];
}
