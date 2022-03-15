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
    Widget app = MaterialApp.router(
      localizationsDelegates: widget.localizationsDelegates,
      supportedLocales: widget.supportedLocales,
      title: widget.title,
      theme: widget.theme,
      routerDelegate: _routerDelegate,
      routeInformationParser: widget.routeInformationParser,
    );

    final serviceProviderBuilder = widget.serviceProviderBuilder;
    final blocProviderBuilder = widget.blocProviderBuilder;
    var wrapApp = (Widget myApp) => myApp;

    if (serviceProviderBuilder.isNotEmpty) {
      wrapApp = (myApp) => MultiProvider(
          providers: serviceProviderBuilder.getProviders(context),
          child: myApp);
    }
    if (blocProviderBuilder.isNotEmpty) {
      wrapApp = (myApp) => wrapApp(MultiBlocProvider(
          providers: blocProviderBuilder.getProviders(context), child: myApp));
    }

    return wrapApp(app);
  }

  Future<void> _setNewRoutePathCallback(
          BuildContext context, BlocEventBuilder builder) async =>
      widget
          .getBlocByTypeCallback(context)[builder.type]
          ?.call()
          .add(builder.event);
}
