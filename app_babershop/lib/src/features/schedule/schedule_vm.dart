import 'package:app_babershop/src/core/fp/either.dart';
import 'package:app_babershop/src/core/providers/application_providers.dart';
import 'package:app_babershop/src/features/schedule/schedule_state.dart';
import 'package:app_babershop/src/model/barbershop_model.dart';
import 'package:app_babershop/src/model/user_model.dart';
import 'package:asyncstate/class/async_loader_handler.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'schedule_vm.g.dart';

@riverpod
class ScheduleVm extends _$ScheduleVm {
  @override
  ScheduleState build() => ScheduleState.initial();

  void hourSelected(int hour) {
    if (hour == state.scheduleHour) {
      state = state.copyWith(
        scheduleHour: () => null,
      );
    } else {
      state = state.copyWith(
        scheduleHour: () => hour,
      );
    }
  }

  void dateSelected(DateTime date) {
    state = state.copyWith(
      scheduleDate: () => date,
    );
  }

  Future<void> register({
    required UserModel userModel,
    required String clientName,
  }) async {
    final asyncLoaderHandler = AsyncLoaderHandler()..start();
    final ScheduleState(:scheduleDate, :scheduleHour) = state;
    final scheduleRepository = ref.read(scheduleRepositoryProvider);
    final BarbershopModel(id: barbershopId) =
        await ref.read(getMyBarbershopProvider.future);

    final dto = (
      barbershopId: barbershopId,
      userId: userModel.id,
      clientName: clientName,
      date: scheduleDate!,
      time: scheduleHour!,
    );

    final scheduleResult = await scheduleRepository.scheduleClient(dto);

    switch (scheduleResult) {
      case Success():
        state = state.copyWith(
          status: ScheduleStateStatus.success,
        );
      case Failure():
        state = state.copyWith(
          status: ScheduleStateStatus.error,
        );
    }

    asyncLoaderHandler.close();
  }
}
