import 'package:budgethero/features/transaction/data/model/transaction_api_model.dart';
import 'package:json_annotation/json_annotation.dart';

part 'get_all_transaction_dto.g.dart';

@JsonSerializable()
class GetAllTransactionDto {
  final bool success;
  final int? count;
  final List<TransactionApiModel> data;

  const GetAllTransactionDto({
    required this.success,
    required this.count,
    required this.data,
  });

  Map<String, dynamic> toJson() => _$GetAllTransactionDtoToJson(this);

  factory GetAllTransactionDto.fromJson(Map<String, dynamic> json) =>
      _$GetAllTransactionDtoFromJson(json);
}
