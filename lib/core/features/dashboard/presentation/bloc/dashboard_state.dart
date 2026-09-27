part of 'dashboard_bloc.dart';

@immutable
abstract class DashboardState {}

class DashboardInitial extends DashboardState {}

class DashboardLoaded extends DashboardState {
  final DashboardEntity entity;
  DashboardLoaded(this.entity);
}

class DashboardLoading extends DashboardState {}

class DashboardError extends DashboardState {
  final String message;
  DashboardError(this.message);
}
