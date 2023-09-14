import 'dart:developer';

import 'package:app_babershop/src/core/providers/application_providers.dart';
import 'package:app_babershop/src/core/ui/constants.dart';
import 'package:app_babershop/src/core/ui/helpers/messages.dart';
import 'package:app_babershop/src/core/ui/widgets/avatar_widget.dart';
import 'package:app_babershop/src/core/ui/widgets/barbershop_loader.dart';
import 'package:app_babershop/src/core/ui/widgets/hours_panel.dart';
import 'package:app_babershop/src/core/ui/widgets/week_days_panel.dart';
import 'package:app_babershop/src/features/employee/register/employee_register_state.dart';
import 'package:app_babershop/src/features/employee/register/employee_register_vm.dart';
import 'package:app_babershop/src/model/barbershop_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:validatorless/validatorless.dart';

class EmployeeRegisterPage extends ConsumerStatefulWidget {
  const EmployeeRegisterPage({super.key});

  @override
  ConsumerState<EmployeeRegisterPage> createState() =>
      _EmployeeRegisterPageState();
}

class _EmployeeRegisterPageState extends ConsumerState<EmployeeRegisterPage> {
  var registerADM = false;
  final formKey = GlobalKey<FormState>();
  final nameEC = TextEditingController();
  final emailEC = TextEditingController();
  final passwordEC = TextEditingController();

  @override
  void dispose() {
    nameEC.dispose();
    emailEC.dispose();
    passwordEC.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final employeeRegisterVm = ref.watch(employeeRegisterVmProvider.notifier);
    final barbershopAsyncValue = ref.watch(getMyBarbershopProvider);

    ref.listen(
      employeeRegisterVmProvider.select((state) => state.status),
      (_, status) {
        switch (status) {
          case EmployeeRegisterStateStatus.initial:
            break;
          case EmployeeRegisterStateStatus.success:
            Messages.showSuccess('Colaborador cadastrado com sucesso', context);
            Navigator.of(context).pop();
          case EmployeeRegisterStateStatus.error:
            Messages.showError('Erro ao registrar colaborador', context);
        }
      },
    );

    return Scaffold(
      appBar: AppBar(
        title: const Text('Cadastrar colaborador'),
      ),
      body: barbershopAsyncValue.when(
        error: (error, stackTrace) {
          log(
            'Erro ao carregar a página',
            error: error,
            stackTrace: stackTrace,
          );
          return const Center(
              child: Text(
            'Erro ao carregar a página',
            style: TextStyle(
              color: ColorsConstants.red,
            ),
          ));
        },
        loading: () => const BarbershopLoader(),
        data: (barbershopModel) {
          final BarbershopModel(:openingDays, :openingHours) = barbershopModel;
          return SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(15),
              child: Form(
                key: formKey,
                child: Center(
                  child: Column(
                    children: [
                      const AvatarWidget(),
                      const SizedBox(
                        height: 32,
                      ),
                      Row(
                        children: [
                          Checkbox.adaptive(
                            activeColor: ColorsConstants.brown,
                            value: registerADM,
                            onChanged: (value) {
                              setState(() {
                                registerADM = !registerADM;
                                employeeRegisterVm.setRegisterADM(registerADM);
                              });
                            },
                          ),
                          const Expanded(
                            child: Text(
                              'Sou administrador e quero me cadastrar como colaborador',
                              style: TextStyle(fontSize: 14),
                            ),
                          )
                        ],
                      ),
                      Offstage(
                        offstage: registerADM,
                        child: Column(
                          children: [
                            const SizedBox(
                              height: 24,
                            ),
                            TextFormField(
                              controller: nameEC,
                              validator: registerADM
                                  ? null
                                  : Validatorless.required('Nome obrigatório'),
                              decoration: const InputDecoration(
                                labelText: 'Nome',
                              ),
                            ),
                            const SizedBox(
                              height: 24,
                            ),
                            TextFormField(
                              controller: emailEC,
                              validator: registerADM
                                  ? null
                                  : Validatorless.multiple([
                                      Validatorless.required(
                                          'E-mail obrigatório'),
                                      Validatorless.email('E-mail inválido'),
                                    ]),
                              decoration: const InputDecoration(
                                labelText: 'E-mail',
                              ),
                            ),
                            const SizedBox(
                              height: 24,
                            ),
                            TextFormField(
                              controller: passwordEC,
                              validator: registerADM
                                  ? null
                                  : Validatorless.multiple([
                                      Validatorless.required(
                                          'Campo obrigatório'),
                                      Validatorless.min(
                                        6,
                                        'Senha deve conter pelo menos 6 caracteres',
                                      ),
                                    ]),
                              obscureText: true,
                              decoration: const InputDecoration(
                                labelText: 'Senha',
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(
                        height: 24,
                      ),
                      WeekDaysPanel(
                        onDayPressed: employeeRegisterVm.addOrRemoveWorkDays,
                        enabledDays: openingDays,
                      ),
                      const SizedBox(
                        height: 24,
                      ),
                      HoursPanel(
                        startTime: 6,
                        endTime: 23,
                        onHourPressed: employeeRegisterVm.addOrRemoveWorkHours,
                        enabledTimes: openingHours,
                      ),
                      const SizedBox(
                        height: 24,
                      ),
                      ElevatedButton(
                        onPressed: () {
                          switch (formKey.currentState?.validate()) {
                            case false || null:
                              Messages.showError(
                                "Existem campos inválidos",
                                context,
                              );
                            case true:
                              final EmployeeRegisterState(
                                workDays: List(isNotEmpty: hasWorkDays),
                                workHours: List(isNotEmpty: hasWorkHours),
                              ) = ref.watch(employeeRegisterVmProvider);

                              if (!hasWorkDays || !hasWorkHours) {
                                Messages.showError(
                                  "Por favor, selecione os dias da semana e horário de atendimento",
                                  context,
                                );
                                return;
                              } else {
                                employeeRegisterVm.register(
                                  name: nameEC.text,
                                  email: emailEC.text,
                                  password: passwordEC.text,
                                );
                              }
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          minimumSize: const Size.fromHeight(56),
                        ),
                        child: const Text('Cadastrar colaborador'),
                      )
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
