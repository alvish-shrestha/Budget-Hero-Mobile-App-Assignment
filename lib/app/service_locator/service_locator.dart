import 'package:budgethero/core/network/hive_service.dart';
import 'package:budgethero/features/auth/data/data_source/local_datasource/user_local_datasource.dart';
import 'package:budgethero/features/auth/data/repository/local_repository/user_local_repository.dart';
import 'package:budgethero/features/auth/domain/use_case/login_usecase.dart';
import 'package:budgethero/features/auth/domain/use_case/register_usecase.dart';
import 'package:budgethero/features/auth/presentation/view_model/login_view_model/login_view_model.dart';
import 'package:budgethero/features/auth/presentation/view_model/register_view_model/register_view_model.dart';
import 'package:budgethero/features/splash_screen/presentation/view_model/splash_screen_view_model.dart';
import 'package:get_it/get_it.dart';

final serviceLocator = GetIt.instance;

Future initDependencies() async {
  await _initHiveService();
  await _initAuthModule();
  await _initSplashModule();
}

Future _initHiveService() async {
  serviceLocator.registerLazySingleton(() => HiveService());
}

Future _initAuthModule() async {
  // Data Source
  serviceLocator.registerFactory(() => UserLocalDatasource(
      hiveService: serviceLocator<HiveService>(),
  ));

  // Repository
  serviceLocator.registerFactory(() => UserLocalRepository(
      userLocalDatasource: serviceLocator<UserLocalDatasource>(),
  ));

  // Use Cases
  serviceLocator.registerFactory(() => UserRegisterUsecase(
      userRepository: serviceLocator<UserLocalRepository>(),
  ));

  serviceLocator.registerFactory(() => UserLoginUsecase(
      userRepository: serviceLocator<UserLocalRepository>(),
  ));

  // ViewModel
  serviceLocator.registerLazySingleton(() => RegisterViewModel(
      registerUsecase: serviceLocator<UserRegisterUsecase>(),
  ));

  serviceLocator.registerLazySingleton(() => LoginViewModel());
}

Future _initSplashModule() async {
  serviceLocator.registerFactory(() => SplashScreenViewModel());
}
