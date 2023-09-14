import 'package:app_babershop/src/core/ui/barbershop_nav_global_key.dart';
import 'package:app_babershop/src/core/ui/barbershop_theme.dart';
import 'package:app_babershop/src/core/ui/widgets/barbershop_loader.dart';
import 'package:app_babershop/src/features/auth/login/login_page.dart';
import 'package:app_babershop/src/features/auth/register/barbershop/barbershop_register_page.dart';
import 'package:app_babershop/src/features/auth/register/user/user_register_page.dart';
import 'package:app_babershop/src/features/employee/register/employee_register_page.dart';
import 'package:app_babershop/src/features/employee/schedule/employee_schedule_page.dart';
import 'package:app_babershop/src/features/home/adm/home_adm_page.dart';
import 'package:app_babershop/src/features/home/employee/home_employee_page.dart';
import 'package:app_babershop/src/features/schedule/schedule_page.dart';
import 'package:app_babershop/src/features/splash/splash_page.dart';
import 'package:asyncstate/widget/async_state_builder.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

class BabershopApp extends StatelessWidget {
  const BabershopApp({super.key});

  @override
  Widget build(BuildContext context) {
    return AsyncStateBuilder(
      customLoader: const BarbershopLoader(),
      builder: (asyncNavigatorObserver) {
        return MaterialApp(
          title: 'DW BarberShop',
          theme: BarbershopTheme.themeData,
          debugShowCheckedModeBanner: false,
          navigatorKey: BarbershopNavGlobalKey.instance.navKey,
          navigatorObservers: [asyncNavigatorObserver],
          routes: {
            '/': (_) => const SplashPage(),
            '/auth/login': (_) => const LoginPage(),
            '/auth/register/user': (_) => const UserRegisterPage(),
            '/auth/register/barbershop': (_) => const BarbershopRegisterPage(),
            '/home/adm': (_) => const HomeAdmPage(),
            '/home/employee': (_) => const HomeEmployeePage(),
            '/employee/register': (_) => const EmployeeRegisterPage(),
            '/employee/schedule': (_) => const EmployeeSchedulePage(),
            '/schedule': (_) => const SchedulePage(),
          },
          localizationsDelegates: const [
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate
          ],
          supportedLocales: const [
            Locale('pt', 'BR'),
          ],
          locale: const Locale('pt', 'BR'),
        );
      },
    );
  }
}
