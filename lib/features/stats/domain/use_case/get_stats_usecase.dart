import 'package:budgethero/core/error/failure.dart';
import 'package:budgethero/features/stats/domain/entity/stats_entity.dart';
import 'package:budgethero/features/stats/domain/repository/stats_repository.dart';
import 'package:budgethero/app/use_case/use_case.dart';
import 'package:dartz/dartz.dart';

class GetStatsUsecase implements UseCaseWithoutParams<StatsEntity> {
  final IStatsRepository repository;

  GetStatsUsecase({required this.repository});

  @override
  Future<Either<Failure, StatsEntity>> call() {
    return repository.getStats();
  }
}
