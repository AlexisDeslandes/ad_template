part of 'app.dart';

class AdApp<Event, State, MainNavBloc extends Bloc<Event, State>>
    extends StatelessWidget {
  const AdApp(
      {Key? key,
      required this.serviceProviderBuilder,
      required this.blocProviderBuilder,
      required this.title,
      required this.routeInformationParser,
      required this.mainNavBloc,
      required this.getPages,
      required this.getBlocByTypeCallback,
      this.observers = const [],
      this.theme,
      this.onPop})
      : super(key: key);

  final String title;
  final ServiceProviderBuilder serviceProviderBuilder;
  final BlocProviderBuilder blocProviderBuilder;
  final RouteInformationParser<BlocEventBuilder> routeInformationParser;
  final MainNavBloc mainNavBloc;
  final GetPages<State> getPages;
  /// Should return the needed blocs used for deep link, using context.
  /// eg: getBlocByTypeCallback: (context) => {UserBloc: () => context.read<UserBloc>()}
  final GetBlocByTypeCallback getBlocByTypeCallback;
  final List<NavigatorObserver> observers;
  final PopPageCallback? onPop;
  final ThemeData? theme;

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        providers: serviceProviderBuilder.getProviders(context),
        child: MultiBlocProvider(
            providers: [
              BlocProvider.value(value: ThemeCubit(theme ?? ThemeData.light())),
              ...blocProviderBuilder.getProviders(context)
            ],
            child: BlocBuilder<ThemeCubit, ThemeData>(
              builder: (context, state) => MaterialApp.router(
                title: title,
                theme: state,
                routerDelegate: AdRouterDelegate<Event, State, MainNavBloc>(
                    setNewRoutePathCallback: (builder) =>
                        _setNewRoutePathCallback(context, builder),
                    mainNavBloc: mainNavBloc,
                    getPages: getPages,
                    observers: observers,
                    onPopPage: onPop),
                routeInformationParser: routeInformationParser,
              ),
            )));
  }

  Future<void> _setNewRoutePathCallback(
          BuildContext context, BlocEventBuilder builder) async =>
      getBlocByTypeCallback(context)[builder.type]?.call().add(builder.event);
}
