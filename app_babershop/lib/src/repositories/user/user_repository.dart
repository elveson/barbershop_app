import 'package:app_babershop/src/core/exceptions/auth_exception.dart';
import 'package:app_babershop/src/core/fp/either.dart';
import 'package:app_babershop/src/core/fp/nil.dart';
import 'package:app_babershop/src/model/user_model.dart';

import '../../core/exceptions/repository_exception.dart';

abstract interface class UserRepository {
  Future<Either<AuthException, String>> login(String email, String password);

  Future<Either<RepositoryException, UserModel>> me();

  Future<Either<RepositoryException, Nil>> registerAdmin(
    ({String name, String email, String password}) userData,
  );

  Future<Either<RepositoryException, List<UserModel>>> getEmployee(
      int barbershopId);

  Future<Either<RepositoryException, Nil>> registerAdmAsEmployee(
      ({
        List<String> workDays,
        List<int> workHours,
      }) userModel);

  Future<Either<RepositoryException, Nil>> registerEmployee(
      ({
        int barbershopId,
        String name,
        String email,
        String password,
        List<String> workDays,
        List<int> workHours,
      }) userModel);
}
