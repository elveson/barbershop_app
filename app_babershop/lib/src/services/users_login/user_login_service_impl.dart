// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:app_babershop/src/core/constants/local_storage_keys.dart';
import 'package:app_babershop/src/core/exceptions/auth_exception.dart';
import 'package:app_babershop/src/core/exceptions/service_exception.dart';
import 'package:app_babershop/src/core/fp/either.dart';
import 'package:app_babershop/src/core/fp/nil.dart';
import 'package:app_babershop/src/repositories/user/user_repository.dart';
import 'package:app_babershop/src/services/users_login/user_login_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserLoginServiceImpl implements UserLoginService {
  final UserRepository userRepository;
  UserLoginServiceImpl({
    required this.userRepository,
  });

  @override
  Future<Either<ServiceException, Nil>> execute(
    String email,
    String password,
  ) async {
    final loginResult = await userRepository.login(email, password);
    switch (loginResult) {
      case Success(value: final accessToken):
        final sp = await SharedPreferences.getInstance();
        sp.setString(LocalStorageKeys.accessToken, accessToken);
        return Success(nil);
      case Failure(:final exception):
        return switch (exception) {
          AuthError() =>
            Failure(ServiceException(message: 'Erro ao realizar login.')),
          AuthUnauthorizedException() =>
            Failure(ServiceException(message: 'Login ou senha inválidos.')),
        };
    }
  }
}
