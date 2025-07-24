import 'package:budgethero/core/error/failure.dart';
import 'package:budgethero/features/stats/domain/entity/stats_entity.dart';
import 'package:dartz/dartz.dart';

abstract class IStatsRepository {
  Future<Either<Failure, StatsEntity>> getStats();
}
