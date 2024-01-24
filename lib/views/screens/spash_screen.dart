import 'dart:async';

import 'package:app_movil_channel_iptv/utils/consts.dart';
import 'package:app_movil_channel_iptv/utils/routes/routes_name.dart';
import 'package:app_movil_channel_iptv/utils/utils.dart';
import 'package:app_movil_channel_iptv/viewmodels/splash_viewmodel.dart';
import 'package:lottie/lottie.dart';
import 'package:flutter/material.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  void changePage() {
    Timer.periodic(
      const Duration(seconds: 4),
      (timer) {
        SplashViewModel().decideNavigation((Future<bool> isLoggedIn) async {
          Navigator.pushReplacementNamed(
              context,
              await isLoggedIn
                  ? RoutesName.tvlive
                  : RoutesName.onboard); //RoutesName.login);
        });
        timer.cancel();
      },
    );
  }

  @override
  void initState() {
    changePage();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final double width = MediaQuery.of(context).size.width;
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Const.colorPurpleDarker,
              Const.colorPurpleMediumDark,
              Const.colorPurpleMedium,
              Const.colorPurpleLight,
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            stops: [0.0, 0.33, 0.66, 1.0],
            tileMode: TileMode.clamp,
          ),
        ),

        // Resto de tu contenido aquí
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Stack(alignment: Alignment.center, children: [
                Lottie.asset(Const.aniSplashLoading, width: width / 3),
                const Image(
                  image: AssetImage(Const.imgLogo),
                  height: 150,
                ),
              ]),
              Utils.verticalSpace(20),
              const Text(
                  textAlign: TextAlign.center,
                  "Coto Brus Televisión Para Costa Rica y el Mundo... 😜",
                  style: Const.fontHeaderTextStyle)
            ],
          ),
        ),
      ),
    );
  }
}