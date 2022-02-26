part of 'common.dart';

typedef VoidCallback = void Function();

typedef GetValue<T> = T Function();

typedef ResourceFactory<Resource> = Resource Function(
    Map<String, dynamic> json);

typedef GetPages<State> = List<Page> Function(State);

typedef GetBlocByTypeCallback = Map<Type, GetValue<Bloc>> Function(
    BuildContext context);
