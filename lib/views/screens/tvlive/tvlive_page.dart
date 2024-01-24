import 'dart:async';

import 'package:app_movil_channel_iptv/data/models/channel.dart';
import 'package:app_movil_channel_iptv/data/models/controls_videoplayer.dart';
import 'package:app_movil_channel_iptv/viewmodels/tvlive_viewmodel.dart';
import 'package:app_movil_channel_iptv/views/widgets/video/video_player.dart';
import 'package:flutter/material.dart';


class TvLivePage extends StatefulWidget {
  const TvLivePage({super.key});

  @override
  State<TvLivePage> createState() => _TvLivePageState();
}

class _TvLivePageState extends State<TvLivePage> {
  TvLiveViewModel viewModelTvLive = TvLiveViewModel();

  late Future<ClsChannel>? futureChannelGlobal;

  @override
  void initState() {
    super.initState();
    futureChannelGlobal = Future.value(viewModelTvLive.theChannel());
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: () async {
          bool confirmExit = await showDialog(
            context: context,
            builder: (BuildContext context) {
              return Dialog(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
                child: Container(
                  width: 100,
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Text(
                        '¿Estás seguro?',
                        style: TextStyle(
                          fontSize: 20.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 16.0),
                      const Text(
                        '¿Deseas salir de la aplicación?',
                        style: TextStyle(fontSize: 16.0),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 16.0),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.close),
                            onPressed: () {
                              Navigator.of(context).pop(false);
                            },
                          ),
                          IconButton(
                            icon: const Icon(Icons.check),
                            onPressed: () {
                              Navigator.of(context).pop(true);
                            },
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              );
            },
          );

          // Realiza el pop solo si se confirma la salida
          if (confirmExit == true) {
            return Future.value(true);
          }

          // Indica si se puede realizar el pop
          return Future.value(false);
        },
        child: FutureBuilder<ClsChannel>(
          future: futureChannelGlobal,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                  child: SizedBox(
                width: 50,
                height: 50,
                child: CircularProgressIndicator(),
              ));
            } else {
              var channel = snapshot.data;
              return VideoPlayer(
                  url: channel!.urlChannel!,
                  controls: ClsControlsVideoPlayer(
                    videoType: VideoType.tvChannel,
                    clsChannel: channel,
                  ));
            }
          },
        ));
  }
}
