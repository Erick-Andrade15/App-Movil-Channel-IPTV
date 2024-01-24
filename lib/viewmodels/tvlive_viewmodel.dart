import 'package:app_movil_channel_iptv/data/models/channel.dart';
import 'package:app_movil_channel_iptv/utils/globals.dart';

class TvLiveViewModel {

  Future<ClsChannel> theChannel() async {
    ClsChannel channels = Globals.globalChannels;
    return channels;
  }
 
}
