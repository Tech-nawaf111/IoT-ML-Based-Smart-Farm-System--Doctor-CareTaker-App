part of 'app_bloc.dart';

enum AppStatus {
  authenticated,
  unauthenticated,
  Pending,
  Approved,
  ToDoctorHome,
  ToCareTakerHome
}

/// possible user states
/// authorized and unauthorized

class AppState extends Equatable {
  const AppState._({
    required this.status,
    this.user = User.empty,
  });

  const AppState.authenticated(User user) : this._(status: AppStatus.authenticated, user: user);
  const AppState.unauthenticated() : this._(status: AppStatus.unauthenticated);
  const AppState.Pending(User user) : this._(status: AppStatus.Pending, user: user);
  const AppState.Approved(User user) : this._(status: AppStatus.Approved, user: user);
  const AppState.ToDoctorHome(User user) : this._(status: AppStatus.ToDoctorHome, user: user);
  const AppState.ToCareTakerHome(User user) : this._(status: AppStatus.ToCareTakerHome, user: user);
  final AppStatus status;
  final User user;

  @override
  List<Object> get props => [status, user];
}
