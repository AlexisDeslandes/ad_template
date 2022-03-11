part of 'app.dart';

class AdApp<BlocEvent, BlocState,
    MainNavBloc extends Bloc<BlocEvent, BlocState>> extends StatefulWidget {
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
      this.localizationsDelegates = const [],
      this.supportedLocales = const [],
      this.theme,
      this.onPop})
      : super(key: key);

  final String title;
  final ServiceProviderBuilder serviceProviderBuilder;
  final BlocProviderBuilder blocProviderBuilder;
  final RouteInformationParser<BlocEventBuilder> routeInformationParser;
  final MainNavBloc mainNavBloc;
  final GetPages<BlocState> getPages;

  /// Should return the needed blocs used for deep link, using context.
  /// eg: getBlocByTypeCallback: (context) => {UserBloc: () => context.read<UserBloc>()}
  final GetBlocByTypeCallback getBlocByTypeCallback;
  final List<NavigatorObserver> observers;
  final PopPageCallback? onPop;
  final ThemeData? theme;
  final Iterable<LocalizationsDelegate<dynamic>> localizationsDelegates;
  final Iterable<Locale> supportedLocales;

  @override
  State<AdApp<BlocEvent, BlocState, MainNavBloc>> createState() =>
      _AdAppState<BlocEvent, BlocState, MainNavBloc>();
}

class _AdAppState<BlocEvent, BlocState,
        MainNavBloc extends Bloc<BlocEvent, BlocState>>
    extends State<AdApp<BlocEvent, BlocState, MainNavBloc>> {
  late final List<SingleChildWidget> _providers =
      widget.serviceProviderBuilder.getProviders(context);
  late final List<BlocProvider> _blocProviders =
      widget.blocProviderBuilder.getProviders(context);
  late final RouterDelegate<BlocEventBuilder> _routerDelegate =
      AdRouterDelegate<BlocEvent, BlocState, MainNavBloc>(
          setNewRoutePathCallback: (builder) =>
              _setNewRoutePathCallback(context, builder),
          mainNavBloc: widget.mainNavBloc,
          getPages: widget.getPages,
          observers: widget.observers,
          onPopPage: widget.onPop);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        providers: _providers,
        child: MultiBlocProvider(
            providers: _blocProviders,
            child: MaterialApp.router(
              localizationsDelegates: widget.localizationsDelegates,
              supportedLocales: widget.supportedLocales,
              title: widget.title,
              theme: widget.theme,
              routerDelegate: _routerDelegate,
              routeInformationParser: widget.routeInformationParser,
            )));
  }

  Future<void> _setNewRoutePathCallback(
          BuildContext context, BlocEventBuilder builder) async =>
      widget
          .getBlocByTypeCallback(context)[builder.type]
          ?.call()
          .add(builder.event);
}
