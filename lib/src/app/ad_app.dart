part of 'app.dart';

class AdApp extends StatelessWidget {
  const AdApp(
      {Key? key,
      required this.serviceProviderBuilder,
      required this.initNavState,
      required this.blocProviderBuilder,
      required this.title,
      required this.theme})
      : super(key: key);

  final String title;
  final NavigationState initNavState;
  final ServiceProviderBuilder serviceProviderBuilder;
  final BlocProviderBuilder blocProviderBuilder;
  final ThemeData theme;

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        providers: serviceProviderBuilder.getProviders(context),
        child: MultiBlocProvider(
            providers: blocProviderBuilder.getProviders(context),
            child: MaterialApp(
                title: title,
                theme: theme,
                home: AdNavigator(initState: initNavState))));
  }
}
