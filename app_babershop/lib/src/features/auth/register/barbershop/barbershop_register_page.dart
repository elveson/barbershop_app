import 'package:app_babershop/src/core/ui/helpers/form_helper.dart';
import 'package:app_babershop/src/core/ui/helpers/messages.dart';
import 'package:app_babershop/src/core/ui/widgets/hours_panel.dart';
import 'package:app_babershop/src/core/ui/widgets/week_days_panel.dart';
import 'package:app_babershop/src/features/auth/register/barbershop/barbershop_register_state.dart';
import 'package:app_babershop/src/features/auth/register/barbershop/barbershop_register_vm.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:validatorless/validatorless.dart';

class BarbershopRegisterPage extends ConsumerStatefulWidget {
  const BarbershopRegisterPage({super.key});

  @override
  ConsumerState<BarbershopRegisterPage> createState() =>
      _BabershopRegisterPageState();
}

class _BabershopRegisterPageState
    extends ConsumerState<BarbershopRegisterPage> {
  final formKey = GlobalKey<FormState>();
  final nameEC = TextEditingController();
  final emailEC = TextEditingController();

  @override
  void dispose() {
    nameEC.dispose();
    emailEC.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final barbershopRegisterVm =
        ref.watch(barbershopRegisterVmProvider.notifier);

    ref.listen(barbershopRegisterVmProvider, (_, state) {
      switch (state.status) {
        case BarbershopRegisterStateStatus.initial:
          break;
        case BarbershopRegisterStateStatus.success:
          Navigator.of(context)
              .pushNamedAndRemoveUntil('/home/adm', (route) => false);
        case BarbershopRegisterStateStatus.error:
          Messages.showError(
            'Desculpe! Ocorreu um erro ao registrar barbearia',
            context,
          );
      }
    });
    return Scaffold(
      appBar: AppBar(
        title: const Text('Cadastrar estabelecimento'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: SingleChildScrollView(
          child: Form(
            key: formKey,
            child: Column(
              children: [
                const SizedBox(
                  height: 5,
                ),
                TextFormField(
                  controller: nameEC,
                  validator: Validatorless.required('Nome obrigatório'),
                  onTapOutside: (_) => context.unfocus(),
                  decoration: const InputDecoration(label: Text('Nome')),
                ),
                const SizedBox(
                  height: 24,
                ),
                TextFormField(
                  controller: emailEC,
                  validator: Validatorless.multiple([
                    Validatorless.required('E-mail obrigatório'),
                    Validatorless.email('E-mail inválido')
                  ]),
                  decoration: const InputDecoration(label: Text('E-mail')),
                ),
                const SizedBox(
                  height: 24,
                ),
                WeekDaysPanel(
                  onDayPressed: (value) {
                    barbershopRegisterVm.addOrRemoveOpenDay(value);
                  },
                ),
                const SizedBox(
                  height: 24,
                ),
                HoursPanel(
                  startTime: 6,
                  endTime: 23,
                  onHourPressed: (int value) {
                    barbershopRegisterVm.addOrRemoveOpenHour(value);
                  },
                ),
                const SizedBox(
                  height: 24,
                ),
                ElevatedButton(
                  onPressed: () {
                    switch (formKey.currentState?.validate()) {
                      case false || null:
                        Messages.showError('Formulário inválido', context);

                      case true:
                        barbershopRegisterVm.register(
                          nameEC.text,
                          emailEC.text,
                        );
                    }
                  },
                  style: ElevatedButton.styleFrom(
                      minimumSize: const Size.fromHeight(56)),
                  child: const Text('CADASTRAR ESTABELECIMENTO'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
