part of '../navigation.dart';

class NavigationBloc extends Bloc<NavigationEvent, NavigationState> {
  NavigationBloc(NavigationState initState) : super(initState) {
    on<PopNavigation>(_popNavigation);
    on<PushNavigation>(_pushNavigation);
    on<ChangeModule>(_changeModule);
  }

  FutureOr<void> _popNavigation(
      PopNavigation event, Emitter<NavigationState> emit) {
    final stack = [...state.currentStack]..removeLast();
    emit(state.copyWith(stackByModule: {
      ...state.stackByModule,
      state.navigationModule: stack
    }));
  }

  FutureOr<void> _pushNavigation(
      PushNavigation event, Emitter<NavigationState> emit) {
    final stack = [...state.currentStack, event.navStackElement];
    emit(state.copyWith(stackByModule: {
      ...state.stackByModule,
      state.navigationModule: stack
    }));
  }

  FutureOr<void> _changeModule(
      ChangeModule event, Emitter<NavigationState> emit) {
    final module = event.module;
    emit(state.copyWith(navigationModule: module, stackByModule: {
      ...state.stackByModule,
      module: state.stackByModule[module] ??
          [NavigationStackElement(page: module.homePage)]
    }));
  }
}
