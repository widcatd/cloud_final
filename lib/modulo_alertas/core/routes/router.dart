import 'package:flutter/cupertino.dart';

import '../../features/auth/presentation/pages/login_page.dart';
import '../../features/puntos_de_peligro/presentation/pages/puntos_de_peligro.dart';

class Routes {
  Routes._();
  static const String splash_screem = '/splash_screem';
  static const String login = '/login';
  static const String register = '/register';
  static const String home = '/home';
  static const String puntos_de_peligro = '/';

  static final routes = <String, WidgetBuilder>{
    login: (BuildContext context) => LoginPage(),
    puntos_de_peligro: (BuildContext context) => PuntosDePeligroPage()
  };
}
