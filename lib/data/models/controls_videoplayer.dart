import 'package:app_movil_channel_iptv/data/models/channel.dart';

class ClsControlsVideoPlayer {
  final VideoType videoType;
  //TV
  final ClsChannel? clsChannel;

  ClsControlsVideoPlayer({
    required this.videoType,
    this.clsChannel,
  });
}

enum VideoType {
  simplifiedTV,
  tvChannel,
  movie,
  series,
}
