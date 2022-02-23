part of '../navigation.dart';

typedef PageBuilder = Page Function(dynamic args);

class NavigationModule extends Equatable {
  const NavigationModule(
      {required this.homePage, required this.name, required this.widget});

  final String name;
  final Widget widget;
  final Page homePage;

  @override
  List<Object?> get props => [name, homePage.runtimeType, widget.runtimeType];
}

class NavigationStackElement extends Equatable {
  const NavigationStackElement({required this.page});

  final Page page;

  @override
  List<Object?> get props => [page];
}

class NavigationState extends Equatable {
  const NavigationState(
      {required this.navigationModule, this.stackByModule = const {}});

  final NavigationModule navigationModule;
  final Map<NavigationModule, List<NavigationStackElement>> stackByModule;

  @override
  List<Object?> get props => [navigationModule, stackByModule];

  List<NavigationStackElement> get currentStack =>
      stackByModule[navigationModule] ?? const [];

  NavigationState copyWith(
          {Map<NavigationModule, List<NavigationStackElement>>? stackByModule,
          NavigationModule? navigationModule}) =>
      NavigationState(
          navigationModule: navigationModule ?? this.navigationModule,
          stackByModule: stackByModule ?? this.stackByModule);
}
