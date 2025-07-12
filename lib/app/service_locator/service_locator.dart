import 'package:budgethero/core/network/api_service.dart';
import 'package:budgethero/core/network/hive_service.dart';
import 'package:budgethero/core/network/secure_storage.dart';

import 'package:budgethero/features/auth/data/data_source/local_datasource/user_local_datasource.dart';
import 'package:budgethero/features/auth/data/data_source/remote_datasource/user_remote_datasource.dart';
import 'package:budgethero/features/auth/data/repository/local_repository/user_local_repository.dart';
import 'package:budgethero/features/auth/data/repository/remote_repository/user_remote_repository.dart';
import 'package:budgethero/features/auth/domain/use_case/login_usecase.dart';
import 'package:budgethero/features/auth/domain/use_case/register_usecase.dart';
import 'package:budgethero/features/auth/presentation/view_model/login_view_model/login_view_model.dart';
import 'package:budgethero/features/auth/presentation/view_model/register_view_model/register_view_model.dart';

import 'package:budgethero/features/home/presentation/view_model/dashboard_view_model.dart';
import 'package:budgethero/features/splash_screen/presentation/view_model/splash_screen_view_model.dart';

import 'package:budgethero/features/transaction/data/data_source/local_datasource/transaction_local_datasource.dart';
import 'package:budgethero/features/transaction/data/repository/local_repository/transaction_local_repository.dart';
import 'package:budgethero/features/transaction/domain/use_case/delete_transaction_usecase.dart';
import 'package:budgethero/features/transaction/domain/use_case/get_all_transaction_usecase.dart';
import 'package:budgethero/features/transaction/domain/use_case/add_transaction_usecase.dart';
import 'package:budgethero/features/transaction/presentation/view_model/transaction_view_model.dart';

import 'package:get_it/get_it.dart';
import 'package:dio/dio.dart';

final serviceLocator = GetIt.instance;

Future<void> initDependencies() async {
  await _initHiveService();
  await _initApiService();
  await _initAuthModule();
  await _initTransactionModule();
  await _initDashboardModule();
  await _initSplashModule();
}

Future<void> _initHiveService() async {
  final hiveService = HiveService();
  serviceLocator.registerSingleton<HiveService>(hiveService);
  await hiveService.init();
}

Future<void> _initApiService() async {
  serviceLocator.registerLazySingleton(
    () =>
        ApiService(Dio(), getToken: () async => await SecureStorage.getToken()),
  );
}

// -----------------------------------------------------------------------------
// AUTH MODULE
Future<void> _initAuthModule() async {
  serviceLocator.registerFactory(
    () => UserLocalDatasource(hiveService: serviceLocator<HiveService>()),
  );

  serviceLocator.registerFactory(
    () => UserRemoteDatasource(apiService: serviceLocator<ApiService>()),
  );

  serviceLocator.registerFactory(
    () => UserLocalRepository(
      userLocalDatasource: serviceLocator<UserLocalDatasource>(),
    ),
  );

  serviceLocator.registerFactory(
    () => UserRemoteRepository(
      userRemoteDatasource: serviceLocator<UserRemoteDatasource>(),
    ),
  );

  serviceLocator.registerFactory(
    () => UserRegisterUsecase(
      userRepository: serviceLocator<UserRemoteRepository>(),
    ),
  );

  serviceLocator.registerFactory(
    () => UserLoginUsecase(
      userRepository: serviceLocator<UserRemoteRepository>(),
    ),
  );

  serviceLocator.registerFactory(
    () => RegisterViewModel(serviceLocator<UserRegisterUsecase>()),
  );

  serviceLocator.registerFactory(
    () => LoginViewModel(serviceLocator<UserLoginUsecase>()),
  );
}

// -----------------------------------------------------------------------------
// TRANSACTION MODULE
Future<void> _initTransactionModule() async {
  serviceLocator.registerFactory(
    () =>
        TransactionLocalDatasource(hiveService: serviceLocator<HiveService>()),
  );

  serviceLocator.registerFactory(
    () => TransactionLocalRepository(
      localDatasource: serviceLocator<TransactionLocalDatasource>(),
    ),
  );

  serviceLocator.registerFactory(
    () => GetAllTransactionsUsecase(
      repository: serviceLocator<TransactionLocalRepository>(),
    ),
  );

  serviceLocator.registerFactory(
    () => AddTransactionUsecase(
      repository: serviceLocator<TransactionLocalRepository>(),
    ),
  );

  serviceLocator.registerFactory(
    () => DeleteTransactionUsecase(
      repository: serviceLocator<TransactionLocalRepository>(),
    ),
  );

  serviceLocator.registerFactory(
    () => TransactionViewModel(
      addTransactionUsecase: serviceLocator<AddTransactionUsecase>(),
      getAllTransactionsUsecase: serviceLocator<GetAllTransactionsUsecase>(),
      deleteTransactionUsecase: serviceLocator<DeleteTransactionUsecase>(),
    ),
  );
}

// -----------------------------------------------------------------------------
// DASHBOARD MODULE
Future<void> _initDashboardModule() async {
  serviceLocator.registerFactory(
    () => DashboardViewModel(
      loginViewModel: serviceLocator<LoginViewModel>(),
      getAllTransactionsUsecase: serviceLocator<GetAllTransactionsUsecase>(),
      deleteTransactionUsecase: serviceLocator<DeleteTransactionUsecase>(),
    ),
  );
}

// -----------------------------------------------------------------------------
// SPLASH MODULE
Future<void> _initSplashModule() async {
  serviceLocator.registerFactory(() => SplashScreenViewModel());
}
