import 'package:app_babershop/src/core/providers/application_providers.dart';
import 'package:app_babershop/src/core/ui/constants.dart';
import 'package:app_babershop/src/core/ui/widgets/avatar_widget.dart';
import 'package:app_babershop/src/core/ui/widgets/barbershop_loader.dart';
import 'package:app_babershop/src/features/home/adm/widgets/home_header.dart';
import 'package:app_babershop/src/features/home/employee/home_employee_provider.dart';
import 'package:app_babershop/src/model/user_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class HomeEmployeePage extends ConsumerWidget {
  const HomeEmployeePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userModelAsync = ref.watch(getMeProvider);
    return Scaffold(
        body: userModelAsync.when(
      error: (error, stackTrace) {
        return const Center(
          child: Text('Erro ao carregar Página'),
        );
      },
      loading: () => const BarbershopLoader(),
      data: (user) {
        final UserModel(:id, :name) = user;
        return CustomScrollView(
          slivers: [
            const SliverToBoxAdapter(
              child: HomeHeader(
                hideFilter: true,
              ),
            ),
            SliverFillRemaining(
              hasScrollBody: false,
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  children: [
                    const AvatarWidget(hideUploadButton: true),
                    const SizedBox(
                      height: 24,
                    ),
                    Text(
                      name,
                      style: const TextStyle(
                          fontSize: 20, fontWeight: FontWeight.w500),
                    ),
                    const SizedBox(
                      height: 30,
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width * 0.7,
                      height: 108,
                      decoration: BoxDecoration(
                        border: Border.all(color: ColorsConstants.grey),
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Consumer(
                            builder: (context, ref, child) {
                              final totalAsync =
                                  ref.watch(getTotalSchedulesTodayProvider(id));
                              return totalAsync.when(
                                error: (error, stackTrace) {
                                  return const Center(
                                    child: Text(
                                        'Erro ao carregar total de agendamentos'),
                                  );
                                },
                                loading: () => const BarbershopLoader(),
                                skipLoadingOnRefresh: false,
                                data: (totalSchedule) {
                                  return Text(
                                    '$totalSchedule',
                                    style: const TextStyle(
                                        fontSize: 32,
                                        fontWeight: FontWeight.w600,
                                        color: ColorsConstants.brown),
                                  );
                                },
                              );
                            },
                          ),
                          const Text(
                            "Hoje",
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 30,
                    ),
                    ElevatedButton(
                      onPressed: () async {
                        await Navigator.of(context)
                            .pushNamed('/schedule', arguments: user);
                        ref.invalidate(getTotalSchedulesTodayProvider);
                      },
                      style: ElevatedButton.styleFrom(
                        minimumSize: const Size.fromHeight(56),
                        backgroundColor: ColorsConstants.brown,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: const Text('AGENDAR CLIENTE'),
                    ),
                    const SizedBox(
                      height: 24,
                    ),
                    OutlinedButton(
                      onPressed: () {
                        Navigator.of(context)
                            .pushNamed('/employee/schedule', arguments: user);
                      },
                      style: OutlinedButton.styleFrom(
                        minimumSize: const Size.fromHeight(56),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: const Text('VER AGENDAMENTOS'),
                    ),
                  ],
                ),
              ),
            )
          ],
        );
      },
    ));
  }
}
