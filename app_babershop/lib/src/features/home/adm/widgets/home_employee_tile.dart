import 'package:app_babershop/src/core/ui/barbersho_icons.dart';
import 'package:app_babershop/src/core/ui/constants.dart';
import 'package:app_babershop/src/model/user_model.dart';
import 'package:flutter/material.dart';

class HomeEmployeeTile extends StatelessWidget {
  final UserModel employee;

  const HomeEmployeeTile({
    super.key,
    required this.employee,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 200,
      height: 100,
      margin: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        border: Border.all(
          color: ColorsConstants.grey,
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: switch (employee.avatar) {
                  final avatar? => NetworkImage(avatar),
                  _ => const AssetImage(
                      ImageConstants.avatar,
                    ),
                } as ImageProvider,
              ),
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  employee.name,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        Navigator.of(context)
                            .pushNamed('/schedule', arguments: employee);
                      },
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                      ),
                      child: const Text('AGENDAR'),
                    ),
                    OutlinedButton(
                      onPressed: () {
                        Navigator.of(context).pushNamed('/employee/schedule',
                            arguments: employee);
                      },
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                      ),
                      child: const Text('VER AGENDA'),
                    ),
                    const Icon(
                      BarbershopIcons.penEdit,
                      size: 16,
                      color: ColorsConstants.brown,
                    ),
                    const Icon(
                      BarbershopIcons.trash,
                      size: 16,
                      color: Colors.red,
                    )
                  ],
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
