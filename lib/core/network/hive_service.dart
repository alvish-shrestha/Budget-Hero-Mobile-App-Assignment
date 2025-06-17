import 'package:budgethero/app/constant/hive/hive_table_constant.dart';
import 'package:budgethero/features/auth/data/model/user_hive_model.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:path_provider/path_provider.dart';

class HiveService {
  Future<void> init() async {
    // initialize the db
    var directory = await getApplicationDocumentsDirectory();
    var path = '${directory.path}user_management.db';

    Hive.init(path);

    //Register Adapters
    Hive.registerAdapter(UserHiveModelAdapter());
  }

  // ===================== User Query =====================
  Future<void> registerUser(UserHiveModel user) async {
    var box = await Hive.openBox<UserHiveModel>(HiveTableConstant.userBox);
    await box.put(user.userId, user);
  }

  // ===================== Login Query =====================
  Future<UserHiveModel?> loginUser(String email, String password) async {
    var box = await Hive.openBox<UserHiveModel>(HiveTableConstant.userBox);

    var user = box.values.firstWhere(
      (user) => user.email == email && user.password == password,
      orElse: () => throw Exception('Invalid email or password'),
    );
    return user;
  }
}
