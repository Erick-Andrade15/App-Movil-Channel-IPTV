import 'dart:async';

import 'package:app_movil_channel_iptv/data/models/channel.dart';
import 'package:app_movil_channel_iptv/data/models/controls_videoplayer.dart';
import 'package:app_movil_channel_iptv/utils/consts.dart';
import 'package:app_movil_channel_iptv/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_vlc_player/flutter_vlc_player.dart';
import 'package:lottie/lottie.dart';

final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

class ControlsVideoPlayer extends StatefulWidget {
  const ControlsVideoPlayer(
      {super.key,
      required this.controllervlc,
      required this.controlsVideoPlayer});
  final VlcPlayerController controllervlc;
  final ClsControlsVideoPlayer controlsVideoPlayer;

  @override
  State<ControlsVideoPlayer> createState() => _ControlsVideoPlayerState();
}

class _ControlsVideoPlayerState extends State<ControlsVideoPlayer> {
  late ClsControlsVideoPlayer _controlsVideoPlayer;
  late VlcPlayerController _controller;
  Widget appBarTitle = const Text("");

  //--------------------TV--------------------//
  late Future<List<ClsChannel>>? futureChannels;
  late ClsChannel? clsChannel;
  late bool isTvLive = false;

  //--------------------CONTROLS--------------------//
  bool showsControls = false;
  //ASPECT RADIO
  int aspectRatioIndex = 0;
  List<String> aspectRatios = [
    '',
    '16:9',
    '4:3',
    '3:2',
    '1:1',
  ];

  @override
  void initState() {
    super.initState();
    _controller = widget.controllervlc;
    _controlsVideoPlayer = widget.controlsVideoPlayer;

    switch (_controlsVideoPlayer.videoType) {
      case VideoType.movie:
        break;
      case VideoType.series:
        break;
      case VideoType.tvChannel:
        isTvLive = true;
        clsChannel = _controlsVideoPlayer.clsChannel!;
        break;
      case VideoType.simplifiedTV:
        break;
    }
  }

  @override
  void dispose() {
    super.dispose();
  }

  void changeAspectRatio(BuildContext context) {
    aspectRatioIndex = (aspectRatioIndex + 1) % aspectRatios.length;
    String nextAspectRatio = aspectRatios[aspectRatioIndex];
    _controller.setVideoAspectRatio(nextAspectRatio);
    // Variable para controlar si el diálogo ya ha sido cerrado
    bool dialogClosed = false;
    //MOSTRAR SHOWDIALOG DE ASPCT RADIO
    showDialog(
      context: context,
      barrierColor: Colors.transparent, // Color de barrera transparente
      builder: (BuildContext context) {
        return AlertDialog(
            backgroundColor: Colors.transparent, // Fondo transparente
            content: Center(
              child: Text(
                aspectRatios[aspectRatioIndex],
                style: const TextStyle(
                    fontSize: 50,
                    fontWeight: FontWeight.bold,
                    color: Const.colorWhite),
              ),
            ));
      },
    ).then((value) {
      // Este código se ejecutará cuando el diálogo se haya cerrado
      if (!dialogClosed) {
        dialogClosed = true; // Marcar el diálogo como cerrado
        // Realizar acciones adicionales después de cerrar el diálogo aquí
      }
    });

    // Configurar la duración del diálogo
    const duration = Duration(seconds: 1);
    Timer(duration, () {
      if (!dialogClosed) {
        dialogClosed = true; // Marcar el diálogo como cerrado
        Navigator.of(context, rootNavigator: true).pop(); // Cerrar el diálogo
      }
    });
  }

  Widget buildScaffoldTvLive(double widthScreen) {
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: Colors.transparent,
      appBar: showsControls
          ? AppBar(
              automaticallyImplyLeading: false,
              backgroundColor: Colors.transparent,
              elevation: 0.0,
              actions: [
                IconButton(
                  iconSize: 40,
                  onPressed: getCastDevices,
                  icon: const Icon(
                    Icons.cast,
                    color: Colors.white,
                  ),
                ),
                IconButton(
                  iconSize: 40,
                  onPressed: () {
                    changeAspectRatio(context);
                  },
                  icon: const Icon(
                    Icons.aspect_ratio,
                    color: Colors.white,
                  ),
                ),
              ],
            )
          : PreferredSize(
              preferredSize: const Size.fromHeight(0),
              child: Container(),
            ),
      extendBodyBehindAppBar: true,
      body: Visibility(
        visible: showsControls,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            //END BAR
            Flexible(
              flex: 0,
              child: Container(
                color: Colors.black38,
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(25, 0, 25, 0),
                  child: Row(
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Image.asset(
                        Const.streamImg,
                        height: 150.0,
                        width: 150.0,
                        fit: BoxFit.contain,
                      ),
                      Utils.horizontalSpace(10),
                      Center(
                          child: Text(
                        clsChannel!.nameChannel!,
                        style: Const.fontHeaderTextStyle,
                      )),
                    ],
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 50),
      reverseDuration: const Duration(milliseconds: 200),
      child: Builder(
        builder: (ctx) {
          // Variables para determinar las mitades de la pantalla
          switch (_controller.value.playingState) {
            case PlayingState.initializing:
              Timer.periodic(const Duration(seconds: 2), (timer) {
                if (_controller.value.playingState !=
                    PlayingState.initializing) {
                  if (mounted) {
                    setState(() {});
                  }
                  timer.cancel(); // Detener el temporizador
                }
              });
              return Center(
                child: Lottie.asset(Const.aniLoading, height: 100),
              );
            case PlayingState.stopped:
            Timer.periodic(const Duration(seconds: 2), (timer) {
                if (_controller.value.playingState !=
                    PlayingState.stopped) {
                  if (mounted) {
                    setState(() {});
                  }
                  timer.cancel(); // Detener el temporizador
                }
              });
              return Scaffold(
                key: _scaffoldKey,
                backgroundColor: Colors.transparent,
                body: Container(
                  height: double.infinity,
                  margin: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.white, width: 5),
                    borderRadius: BorderRadius.circular(25),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(
                        Icons.warning_amber_outlined,
                        size: 100,
                        color: Colors.white,
                      ),
                      Utils.horizontalSpace(10),
                      const Text(
                        'Video isuue\nTry another channel',
                        textAlign: TextAlign.center,
                        style: Const.fontTitleTextStyle,
                      ),
                    ],
                  ),
                ),
              );

            case PlayingState.buffering:
              Timer.periodic(const Duration(seconds: 2), (timer) {
                if (_controller.value.playingState != PlayingState.buffering) {
                  setState(() {});
                  timer.cancel(); // Detener el temporizador
                }
              });
              return Center(
                child: Lottie.asset(Const.aniLoading, height: 100),
              );
            case PlayingState.paused:
            case PlayingState.playing:
              final double widthScreen = MediaQuery.of(context).size.width;
              return GestureDetector(
                  onTap: () {
                    setState(() {
                      showsControls = !showsControls;
                    });
                  },
                  child: buildScaffoldTvLive(widthScreen));

            case PlayingState.ended:
              WidgetsBinding.instance.addPostFrameCallback((_) {
                Navigator.pop(context);
              });
              return Container();
            case PlayingState.error:
              return Container(
                height: double.infinity,
                margin: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.white, width: 5),
                  borderRadius: BorderRadius.circular(25),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.warning_amber_outlined,
                      size: 100,
                      color: Colors.white,
                    ),
                    Utils.horizontalSpace(10),
                    const Text(
                      'Oops! An error occurred\nwhile playing the media\nTry another channel',
                      textAlign: TextAlign.center,
                      style: Const.fontTitleTextStyle,
                    ),
                  ],
                ),
              );
            default:
              return const SizedBox.shrink();
          }
        },
      ),
    );
  }

  Future<void> replay() async {
    await _controller.stop();
    await _controller.play();
  }

  Future<void> getCastDevices() async {
    try {
      // Inicia el escaneo de lanzamiento
      await _controller.startRendererScanning();
      final castDevices = await _controller.getRendererDevices();
      //print('Available Cast Devices: $castDevices');
      if (castDevices.isNotEmpty) {
        if (!mounted) return;
        final String selectedCastDeviceName = await showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text('Display Devices'),
              content: SizedBox(
                width: double.minPositive,
                height: 150,
                child: ListView.builder(
                  itemCount: castDevices.keys.length + 1,
                  itemBuilder: (context, index) {
                    return ListTile(
                      title: Text(
                        index < castDevices.keys.length
                            ? castDevices.values.elementAt(index).toString()
                            : 'Disconnect',
                      ),
                      leading: index < castDevices.keys.length
                          ? const Icon(Icons.tv)
                          : null,
                      onTap: () {
                        Navigator.pop(
                          context,
                          index < castDevices.keys.length
                              ? castDevices.keys.elementAt(index)
                              : "",
                        );
                      },
                    );
                  },
                ),
              ),
            );
          },
        );
        if (selectedCastDeviceName.isNotEmpty) {
          await _controller.castToRenderer(selectedCastDeviceName);
        }
      } else {
        if (!mounted) return;
        EasyLoading.showError('Oops! No display\ndevices found! 📺😕');
      }
    } finally {
      // Detiene el escaneo de lanzamiento
      await _controller.stopRendererScanning();
      await Future.delayed(const Duration(milliseconds: 1500)); // Espera breve
    }
  }

  Future<void> getAudioTracks() async {
    if (!_controller.value.isPlaying) return;

    final audioTracks = await _controller.getAudioTracks();
    //
    if (audioTracks.isNotEmpty) {
      if (!mounted) return;
      final int? selectedAudioTrackId = await showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Select Audio'),
            content: SizedBox(
              width: double.minPositive,
              height: 150,
              child: ListView.builder(
                itemCount: audioTracks.keys.length + 1,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text(
                      index < audioTracks.keys.length
                          ? audioTracks.values.elementAt(index).toString()
                          : audioTracks.keys.length.toString(),
                    ),
                    onTap: () {
                      Navigator.pop(
                        context,
                        index < audioTracks.keys.length
                            ? audioTracks.keys.elementAt(index)
                            : -1,
                      );
                    },
                  );
                },
              ),
            ),
          );
        },
      );
      await _controller.setAudioTrack(selectedAudioTrackId!);
    }
  }

  Future<void> getSubtitleTracks() async {
    if (!_controller.value.isPlaying) return;

    final subtitleTracks = await _controller.getSpuTracks();
    //
    if (subtitleTracks.isNotEmpty) {
      if (!mounted) return;
      final int selectedSubId = await showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Select Subtitle'),
            content: SizedBox(
              width: double.minPositive,
              height: 150,
              child: ListView.builder(
                itemCount: subtitleTracks.keys.length + 1,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text(
                      index < subtitleTracks.keys.length
                          ? subtitleTracks.values.elementAt(index).toString()
                          : 'Disable',
                    ),
                    onTap: () {
                      Navigator.pop(
                        context,
                        index < subtitleTracks.keys.length
                            ? subtitleTracks.keys.elementAt(index)
                            : -1,
                      );
                    },
                  );
                },
              ),
            ),
          );
        },
      );
      await _controller.setSpuTrack(selectedSubId);
    }
  }
}
