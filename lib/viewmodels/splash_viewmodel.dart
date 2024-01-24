import 'package:app_movil_channel_iptv/data/repositories/repository.dart';

class SplashViewModel {
  final Repository repository = Repository();

  void decideNavigation(Function onStart) {
    var isLoggedIn = repository.access();
    onStart(isLoggedIn);
  }
}
