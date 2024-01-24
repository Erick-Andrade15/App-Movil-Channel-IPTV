import 'dart:async';
import 'package:app_movil_channel_iptv/data/models/channel.dart';
import 'package:app_movil_channel_iptv/data/models/user.dart';
import 'package:app_movil_channel_iptv/utils/consts.dart';
import 'package:app_movil_channel_iptv/utils/globals.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:connectivity/connectivity.dart';

class Repository {
  //var
  dynamic response;
  late ClsUsers userData;

  Future<bool> access() async {
    int maxAttempts = 3;
    int currentAttempt = 1;

    while (currentAttempt <= maxAttempts) {
      try {
        var connectivityResult = await Connectivity().checkConnectivity();

        if (connectivityResult != ConnectivityResult.none) {
          debugPrint("Attempting to create ClsChannel:");

          ClsChannel channel = ClsChannel(
            nameChannel: 'CB TV\nUn Canal Diferente',
            streamImg: Const.streamImg,
            urlChannel: 'https://cloudvideo.servers10.com:8081/8030/index.m3u8',
          );

          Globals.globalChannels = channel;

          // Puedes hacer algo con el objeto ClsChannel si lo necesitas
          debugPrint("ClsChannel created successfully.");

          return true;
        } else {
          // Mensaje de error si no hay conexión a Internet
          EasyLoading.showError(
              'No internet connection. Retry attempt $currentAttempt/$maxAttempts...');
        }
      } catch (e) {
        // Mensaje de error para otras excepciones
        EasyLoading.showError(
            'An error occurred while initializing the application. Retry attempt $currentAttempt/$maxAttempts...');

        debugPrint("Error: $e");
      }

      // Esperar antes de realizar el siguiente intento
      await Future.delayed(const Duration(seconds: 5));
      currentAttempt++;
    }

    // Mensaje de error si se supera el número máximo de intentos
    EasyLoading.showError('Max attempts reached. Unable to create ClsChannel.');
    return false;
  }
}
