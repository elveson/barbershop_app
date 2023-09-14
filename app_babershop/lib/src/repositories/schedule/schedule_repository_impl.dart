import 'dart:developer';

import 'package:app_babershop/src/core/exceptions/repository_exception.dart';
import 'package:app_babershop/src/core/fp/either.dart';
import 'package:app_babershop/src/core/fp/nil.dart';
import 'package:app_babershop/src/core/restClient/rest_client.dart';
import 'package:app_babershop/src/model/schedule_model.dart';
import 'package:app_babershop/src/repositories/schedule/schedule_repository.dart';
import 'package:dio/dio.dart';

class ScheduleRepositoryImpl implements ScheduleRepository {
  final RestClient restClient;

  ScheduleRepositoryImpl({
    required this.restClient,
  });

  @override
  Future<Either<RepositoryException, Nil>> scheduleClient(
      ({
        int barbershopId,
        String clientName,
        DateTime date,
        int userId,
        int time,
      }) scheduleData) async {
    try {
      await restClient.auth.post('/schedules', data: {
        'barbershop_id': scheduleData.barbershopId,
        'user_id': scheduleData.userId,
        'client_name': scheduleData.clientName,
        'date': scheduleData.date.toIso8601String(),
        'time': scheduleData.time,
      });

      return Success(nil);
    } on DioException catch (e, s) {
      log('Erro ao agendar horário', error: e, stackTrace: s);
      return Failure(RepositoryException(message: 'Erro ao agendar horário'));
    }
  }

  @override
  Future<Either<RepositoryException, List<ScheduleModel>>> findScheduleByDate(
      ({DateTime date, int userId}) filter) async {
    try {
      final Response(:List data) =
          await restClient.auth.get('/schedules', queryParameters: {
        'date': filter.date.toIso8601String(),
        'user_id': filter.userId,
      });

      final schedules = data
          .map(
            (e) => ScheduleModel.fromMap(e),
          )
          .toList();

      return Success(schedules);
    } on DioException catch (e, s) {
      log('Erro ao buscar agendamento de uma data', error: e, stackTrace: s);
      return Failure(
        RepositoryException(
          message: 'Erro ao buscar agendamento de uma data',
        ),
      );
    } on ArgumentError catch (e, s) {
      log('Json inválido', error: e, stackTrace: s);
      return Failure(
        RepositoryException(
          message: 'Json inválido',
        ),
      );
    }
  }
}
