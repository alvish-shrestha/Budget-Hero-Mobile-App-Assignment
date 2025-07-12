import 'package:budgethero/app/constant/api_endpoints.dart';
import 'package:budgethero/core/network/api_service.dart';
import 'package:budgethero/features/transaction/data/dto/get_all_transaction_dto.dart';
import 'package:budgethero/features/transaction/data/model/transaction_api_model.dart';
import 'package:budgethero/features/transaction/domain/entity/transaction_entity.dart';
import 'package:dio/dio.dart';

abstract class ITransactionRemoteDatasource {
  Future<void> addTransaction(TransactionEntity transaction);
  Future<List<TransactionEntity>> getAllTransactions();
  Future<void> deleteTransaction(String transactionId);
  Future<void> updateTransaction(TransactionEntity transaction);
}

class TransactionRemoteDatasource implements ITransactionRemoteDatasource {
  final ApiService _apiService;

  TransactionRemoteDatasource({required ApiService apiService})
    : _apiService = apiService;

  @override
  Future<void> addTransaction(TransactionEntity transaction) async {
    try {
      final transactionApiModel = TransactionApiModel.fromEntity(transaction);

      var response = await _apiService.dio.post(
        ApiEndpoints.addTransaction,
        data: transactionApiModel.toJson(),
      );

      if (response.statusCode == 201) {
        return;
      } else {
        throw Exception('Failed to add transaction: ${response.statusMessage}');
      }
    } on DioException catch (e) {
      throw Exception("Dio error: ${e.message}");
    } catch (e) {
      throw Exception("An unexpected error occured: $e");
    }
  }

  @override
  Future<List<TransactionEntity>> getAllTransactions() async {
    try {
      final response = await _apiService.dio.get(ApiEndpoints.getTransaction);

      if (response.statusCode == 200) {
        final dto = GetAllTransactionDto.fromJson(response.data);
        return dto.data.map((e) => e.toEntity()).toList();
      } else {
        throw Exception(
          'Failed to fetch transactions: ${response.statusMessage}',
        );
      }
    } on DioException catch (e) {
      throw Exception("Dio error: ${e.message}");
    } catch (e) {
      throw Exception("Unexpected error while fetching transactions: $e");
    }
  }

  @override
  Future<void> deleteTransaction(String transactionId) async {
    try {
      final response = await _apiService.dio.delete(
        "${ApiEndpoints.deleteTransaction}/$transactionId",
        // options: Options(headers: {"Authorization": "Bearer $token"}),
      );

      if (response.statusCode == 200) {
        return;
      } else {
        throw Exception(
          'Failed to delete transaction: ${response.statusMessage}',
        );
      }
    } on DioException catch (e) {
      throw Exception("Dio error: ${e.message}");
    } catch (e) {
      throw Exception("Unexpected error while deleting transactions: $e");
    }
  }

  @override
  Future<void> updateTransaction(TransactionEntity transaction) async {
    try {
      final transactionApiModel = TransactionApiModel.fromEntity(transaction);

      final response = await _apiService.dio.put(
        "${ApiEndpoints.updateTransaction}/${transaction.id}",
        data: transactionApiModel.toJson(),
        // options: Options(headers: {"Authorization": "Bearer $token"}),
      );

      if (response.statusCode == 200) {
        return;
      } else {
        throw Exception(
          "Failed to update transaction: ${response.statusMessage}",
        );
      }
    } on DioException catch (e) {
      throw Exception("Dio error: ${e.message}");
    } catch (e) {
      throw Exception("Unexpected error while updating transaction: $e");
    }
  }
}
