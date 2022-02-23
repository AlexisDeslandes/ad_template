part of 'app.dart';

/// Bootstrap is responsible for any common setup and calls
/// [runApp] with the widget returned by [builder] in an error zone.
Future<void> bootstrap(GetValue<Widget> builder,
    {GetValue<List<Future>>? getFutures, BlocObserver? blocObserver}) async {
  await BlocOverrides.runZoned(
    () async => await runZonedGuarded(() async {
      WidgetsFlutterBinding.ensureInitialized();
      if (getFutures != null) {
        await Future.wait(getFutures());
      }
      runApp(builder());
    }, (error, stack) => log('$error : $stack')),
    blocObserver: blocObserver,
  );
}
