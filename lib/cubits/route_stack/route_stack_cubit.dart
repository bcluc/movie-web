import 'package:flutter_bloc/flutter_bloc.dart';

class RouteStackCubit extends Cubit<List<String>> {
  RouteStackCubit() : super(['/bottom_nav']);

  void push(String route) {
    state.add(route);
    // print('route_stack: $state');
  }

  void pop() {
    state.removeLast();
    // print('route_stack: $state');
  }

  String? findPrior(String route) {
    for (int i = 1; i < state.length; ++i) {
      if (state[i] == route) {
        return state[i - 1];
      }
    }
    return null;
  }

  void printRouteStack() {
    String routeStack = '';
    for (var route in state) {
      routeStack += '$route  ';
    }
    print('RouteStack: $routeStack');
  }
}
