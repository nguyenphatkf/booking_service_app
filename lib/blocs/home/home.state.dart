import '../../models/service.model.dart';

abstract class HomeState {}

class HomeInitial extends HomeState {}

class HomeLoading extends HomeState {}

class HomeLoaded extends HomeState {
  final List<Service> services;
  HomeLoaded(this.services);
}

class HomeError extends HomeState {
  final String message;
  HomeError(this.message);
}
