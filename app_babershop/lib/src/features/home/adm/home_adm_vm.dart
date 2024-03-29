import 'package:app_babershop/src/core/fp/either.dart';
import 'package:app_babershop/src/core/providers/application_providers.dart';
import 'package:app_babershop/src/features/home/adm/home_adm_state.dart';
import 'package:app_babershop/src/model/barbershop_model.dart';
import 'package:app_babershop/src/model/user_model.dart';
import 'package:asyncstate/asyncstate.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'home_adm_vm.g.dart';

@riverpod
class HomeAdmVm extends _$HomeAdmVm {
  @override
  Future<HomeAdmState> build() async {
    final repository = ref.read(userRepositoryProvider);
    final BarbershopModel(id: barbershopId) =
        await ref.read(getMyBarbershopProvider.future);

    final me = await ref.watch(getMeProvider.future);

    final employeesResult = await repository.getEmployee(barbershopId);

    switch (employeesResult) {
      case Success(value: final employeesData):
        final employees = <UserModel>[];

        if (me case UserModelADM(workDays: _?, workHours: _?)) {
          employees.add(me);
        }
        employees.addAll(employeesData);

        return HomeAdmState(
          status: HomeAdmStateStatus.loaded,
          employees: employees,
        );

      case Failure():
        {
          return HomeAdmState(
            status: HomeAdmStateStatus.error,
            employees: [],
          );
        }
    }
  }

  Future<void> logout() => ref.read(logoutProvider.future).asyncLoader();
}
