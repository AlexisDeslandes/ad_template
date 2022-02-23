part of '../navigation.dart';

class BlocNavigator extends StatelessWidget {
  const BlocNavigator(
      {Key? key,
      required this.initState,
      this.listener,
      this.listenWhen,
      this.navigatorObserverList = const []})
      : super(key: key);

  final NavigationState initState;
  final BlocWidgetListener<NavigationState>? listener;
  final BlocListenerCondition<NavigationState>? listenWhen;
  final List<NavigatorObserver> navigatorObserverList;

  /// Used on iOS when user swipe back from one page,
  /// it has to call [PopNav] else it triggers a bad app state.
  bool _onPopPage(BuildContext context, Route route, result) {
    final didPop = route.didPop(result);
    if (didPop) context.read<NavigationBloc>().add(const PopNavigation());
    return didPop;
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => NavigationBloc(initState),
      child: BlocConsumer<NavigationBloc, NavigationState>(
          listenWhen: listenWhen,
          listener: (context, state) => listener?.call(context, state),
          buildWhen: (old, current) => old.currentStack != current.currentStack,
          builder: (context, state) => Navigator(
              observers: navigatorObserverList,
              pages: state.currentStack.map((e) => e.page).toList(),
              onPopPage: (route, result) =>
                  _onPopPage(context, route, result))),
    );
  }
}