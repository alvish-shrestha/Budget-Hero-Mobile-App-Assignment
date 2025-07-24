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
import 'package:budgethero/features/goal/data/data_source/remote_datasource/goal_remote_datasource.dart';
import 'package:budgethero/features/goal/data/repository/remote_repository/goal_remote_repository.dart';
import 'package:budgethero/features/goal/domain/repository/goal_repository.dart';
import 'package:budgethero/features/goal/domain/use_case/add_goal_usecase.dart';
import 'package:budgethero/features/goal/domain/use_case/contribute_to_goal_usecase.dart';
import 'package:budgethero/features/goal/domain/use_case/delete_goal_usecase.dart';
import 'package:budgethero/features/goal/domain/use_case/get_all_goals_usecase.dart';
import 'package:budgethero/features/goal/domain/use_case/update_goal_usecase.dart';
import 'package:budgethero/features/goal/presentation/view_model/goal_view_model.dart';

import 'package:budgethero/features/home/presentation/view_model/dashboard_view_model.dart';
import 'package:budgethero/features/splash_screen/presentation/view_model/splash_screen_view_model.dart';
import 'package:budgethero/features/stats/data/data_source/remote_datasource/stats_remote_datasource.dart';
import 'package:budgethero/features/stats/data/repository/remote_repository/stats_remote_repository.dart';
import 'package:budgethero/features/stats/domain/repository/stats_repository.dart';
import 'package:budgethero/features/stats/domain/use_case/get_stats_usecase.dart';
import 'package:budgethero/features/stats/presentation/view_model/stats_view_model.dart';

import 'package:budgethero/features/transaction/data/data_source/local_datasource/transaction_local_datasource.dart';
import 'package:budgethero/features/transaction/data/data_source/remote_datasource/transaction_remote_datasource.dart';
import 'package:budgethero/features/transaction/data/repository/local_repository/transaction_local_repository.dart';
import 'package:budgethero/features/transaction/data/repository/remote_repository/transaction_remote_repository.dart';
import 'package:budgethero/features/transaction/data/sync/sync_service.dart';
import 'package:budgethero/features/transaction/domain/repository/transaction_repository.dart';
import 'package:budgethero/features/transaction/domain/use_case/delete_transaction_usecase.dart';
import 'package:budgethero/features/transaction/domain/use_case/get_all_transaction_usecase.dart';
import 'package:budgethero/features/transaction/domain/use_case/add_transaction_usecase.dart';
import 'package:budgethero/features/transaction/domain/use_case/update_transaction_usecase.dart';
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
  await _initSyncModule();
  await _initStatsModule();
  await _initGoalsModule();
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

// ========================= Auth Module =======================================
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

// ======================= Transaction Module ==================================
Future<void> _initTransactionModule() async {
  serviceLocator.registerFactory(
    () =>
        TransactionLocalDatasource(hiveService: serviceLocator<HiveService>()),
  );

  serviceLocator.registerFactory(
    () => TransactionRemoteDatasource(apiService: serviceLocator<ApiService>()),
  );

  serviceLocator.registerFactory(
    () => TransactionLocalRepository(
      localDatasource: serviceLocator<TransactionLocalDatasource>(),
    ),
  );

  serviceLocator.registerFactory<ITransactionRepository>(
    () => TransactionRemoteRepository(
      remoteDatasource: serviceLocator<TransactionRemoteDatasource>(),
    ),
  );

  serviceLocator.registerFactory(
    () => GetAllTransactionsUsecase(
      repository: serviceLocator<ITransactionRepository>(),
    ),
  );

  serviceLocator.registerFactory(
    () => AddTransactionUsecase(
      repository: serviceLocator<ITransactionRepository>(),
    ),
  );

  serviceLocator.registerFactory(
    () => DeleteTransactionUsecase(
      repository: serviceLocator<ITransactionRepository>(),
    ),
  );

  serviceLocator.registerFactory(
    () => UpdateTransactionUsecase(
      repository: serviceLocator<ITransactionRepository>(),
    ),
  );

  // serviceLocator.registerFactory(
  //   () => GetAllTransactionsUsecase(
  //     repository: serviceLocator<TransactionRemoteRepository>(),
  //   ),
  // );

  // serviceLocator.registerFactory(
  //   () => AddTransactionUsecase(
  //     repository: serviceLocator<TransactionRemoteRepository>(),
  //   ),
  // );

  // serviceLocator.registerFactory(
  //   () => DeleteTransactionUsecase(
  //     repository: serviceLocator<TransactionRemoteRepository>(),
  //   ),
  // );

  // serviceLocator.registerFactory(
  //   () => UpdateTransactionUsecase(
  //     repository: serviceLocator<TransactionRemoteRepository>(),
  //   ),
  // );

  serviceLocator.registerFactory(
    () => TransactionViewModel(
      addTransactionUsecase: serviceLocator<AddTransactionUsecase>(),
      getAllTransactionsUsecase: serviceLocator<GetAllTransactionsUsecase>(),
      deleteTransactionUsecase: serviceLocator<DeleteTransactionUsecase>(),
      updateTransactionUsecase: serviceLocator<UpdateTransactionUsecase>(),
    ),
  );
}

// ======================= Dashboard Module ====================================
Future<void> _initDashboardModule() async {
  serviceLocator.registerFactory(
    () => DashboardViewModel(
      loginViewModel: serviceLocator<LoginViewModel>(),
      getAllTransactionsUsecase: serviceLocator<GetAllTransactionsUsecase>(),
      deleteTransactionUsecase: serviceLocator<DeleteTransactionUsecase>(),
      updateTransactionUsecase: serviceLocator<UpdateTransactionUsecase>(),
    ),
  );
}

// ======================== Splash Module ======================================

Future<void> _initSplashModule() async {
  serviceLocator.registerFactory(() => SplashScreenViewModel());
}

// ========================= Sync Module =======================================
Future<void> _initSyncModule() async {
  serviceLocator.registerSingleton<SyncService>(
    SyncService(
      hiveService: serviceLocator<HiveService>(),
      remoteDatasource: serviceLocator<TransactionRemoteDatasource>(),
    ),
  );
}

// ======================= Stats Module ========================================
Future<void> _initStatsModule() async {
  // Remote Data Source
  serviceLocator.registerFactory<IStatsRemoteDatasource>(
    () => StatsRemoteDatasource(apiService: serviceLocator<ApiService>()),
  );

  // Remote Repository
  serviceLocator.registerFactory<IStatsRepository>(
    () => StatsRemoteRepository(
      remoteDatasource: serviceLocator<IStatsRemoteDatasource>(),
    ),
  );

  // Use Case
  serviceLocator.registerFactory(
    () => GetStatsUsecase(repository: serviceLocator<IStatsRepository>()),
  );

  // ViewModel
  serviceLocator.registerFactory(
    () => StatsViewModel(getStatsUsecase: serviceLocator<GetStatsUsecase>()),
  );
}

// ============================= Goal Module ===================================
Future<void> _initGoalsModule() async {
  // Remote Data Source
  serviceLocator.registerFactory<IGoalRemoteDatasource>(
    () => GoalRemoteDatasource(apiService: serviceLocator<ApiService>()),
  );

  // Remote Repository
  serviceLocator.registerFactory<IGoalRepository>(
    () => GoalRemoteRepository(
      remoteDatasource: serviceLocator<IGoalRemoteDatasource>(),
    ),
  );

  // Use Cases
  serviceLocator.registerFactory(
    () => GetAllGoalsUsecase(repository: serviceLocator<IGoalRepository>()),
  );

  serviceLocator.registerFactory(
    () => AddGoalUsecase(repository: serviceLocator<IGoalRepository>()),
  );

  serviceLocator.registerFactory(
    () => UpdateGoalUsecase(repository: serviceLocator<IGoalRepository>()),
  );

  serviceLocator.registerFactory(
    () => DeleteGoalUsecase(repository: serviceLocator<IGoalRepository>()),
  );

  serviceLocator.registerFactory(
    () =>
        ContributeToGoalUsecase(repository: serviceLocator<IGoalRepository>()),
  );

  // ViewModel
  serviceLocator.registerFactory(
    () => GoalViewModel(
      getAllGoals: serviceLocator<GetAllGoalsUsecase>(),
      addGoal: serviceLocator<AddGoalUsecase>(),
      updateGoal: serviceLocator<UpdateGoalUsecase>(),
      deleteGoal: serviceLocator<DeleteGoalUsecase>(),
      contributeGoal: serviceLocator<ContributeToGoalUsecase>(),
    ),
  );
}
