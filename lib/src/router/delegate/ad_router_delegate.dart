part of '../router.dart';

class AdRouterDelegate<Event, State, MainNavBloc extends Bloc<Event, State>>
    extends RouterDelegate<BlocEventBuilder>
    with ChangeNotifier, PopNavigatorRouterDelegateMixin<BlocEventBuilder> {
  AdRouterDelegate(
      {required this.mainNavBloc,
      required this.getPages,
      this.onPopPage,
      this.observers = const [],
      this.getBlocByType = const {}});

  final MainNavBloc mainNavBloc;
  final GetPages<State> getPages;
  final PopPageCallback? onPopPage;
  final List<NavigatorObserver> observers;
  final Map<Type, GetValue<Bloc>> getBlocByType;

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
  GlobalKey<NavigatorState>? get navigatorKey => GlobalKey();

  @override
  Future<void> setNewRoutePath(BlocEventBuilder configuration) async {
    final bloc = getBlocByType[configuration.type]?.call();
    if (bloc != null) {
      bloc.add(configuration.event);
    }
  }
}
