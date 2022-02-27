part of '../router.dart';

class AdRouterDelegate<Event, State, MainNavBloc extends Bloc<Event, State>>
    extends RouterDelegate<BlocEventBuilder>
    with ChangeNotifier, PopNavigatorRouterDelegateMixin<BlocEventBuilder> {
  AdRouterDelegate(
      {required this.mainNavBloc,
      required this.getPages,
      required this.setNewRoutePathCallback,
      this.onPopPage,
      this.observers = const []});

  final MainNavBloc mainNavBloc;
  final GetPages<State> getPages;
  final PopPageCallback? onPopPage;
  final List<NavigatorObserver> observers;
  final Future<void> Function(BlocEventBuilder builder) setNewRoutePathCallback;
  final GlobalKey<NavigatorState> key = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: mainNavBloc,
      child: BlocBuilder<MainNavBloc, State>(
        builder: (context, state) => Navigator(
            key: navigatorKey,
            observers: observers,
            pages: getPages(state),
            onPopPage: onPopPage),
      ),
    );
  }

  @override
  GlobalKey<NavigatorState>? get navigatorKey => key;

  @override
  Future<void> setNewRoutePath(BlocEventBuilder configuration) =>
      setNewRoutePathCallback(configuration);
}
