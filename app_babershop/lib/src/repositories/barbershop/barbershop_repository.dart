import 'package:app_babershop/src/core/exceptions/repository_exception.dart';
import 'package:app_babershop/src/core/fp/either.dart';
import 'package:app_babershop/src/model/barbershop_model.dart';
import 'package:app_babershop/src/model/user_model.dart';

import '../../core/fp/nil.dart';

abstract interface class BarbershopRepository {
  Future<Either<RepositoryException, Nil>> save(
      ({
        String name,
        String email,
        List<String> openingDays,
        List<int> openingHours,
      }) data);

  Future<Either<RepositoryException, BarbershopModel>> getMyBarbershop(
      UserModel userModel);
}
