import 'package:budgethero/core/error/failure.dart';
import 'package:budgethero/features/stats/data/data_source/remote_datasource/stats_remote_datasource.dart';
import 'package:budgethero/features/stats/domain/entity/stats_entity.dart';
import 'package:budgethero/features/stats/domain/repository/stats_repository.dart';
import 'package:dartz/dartz.dart';

class StatsRemoteRepository implements IStatsRepository {
  final IStatsRemoteDatasource remoteDatasource;

  StatsRemoteRepository({required this.remoteDatasource});

  @override
  Future<Either<Failure, StatsEntity>> getStats() async {
    try {
      final stats = await remoteDatasource.getStats();
      return Right(stats);
    } catch (e) {
      return Left(ApiFailure(message: e.toString()));
    }
  }
}
