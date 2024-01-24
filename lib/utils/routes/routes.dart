import 'package:app_movil_channel_iptv/utils/routes/routes_name.dart';
import 'package:app_movil_channel_iptv/views/screens/home_page.dart';
import 'package:app_movil_channel_iptv/views/screens/spash_screen.dart';
import 'package:app_movil_channel_iptv/views/screens/tvlive/tvlive_page.dart';

import 'package:flutter/material.dart';

class Routes {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case RoutesName.onboard:
        return MaterialPageRoute(
            builder: (BuildContext context) => const SplashScreen());

      case RoutesName.home:
        return MaterialPageRoute(
            builder: (BuildContext context) => const HomePage());

      case RoutesName.tvlive:
        return MaterialPageRoute(
            builder: (BuildContext context) => const TvLivePage());

      default:
        return MaterialPageRoute(builder: (_) {
          return const Scaffold(
            body: Center(child: Text('No route defined')),
          );
        });
    }
  }
}
