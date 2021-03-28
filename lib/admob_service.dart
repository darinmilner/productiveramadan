import 'dart:io';

class AdMobService {
  String getAdMobAppId() {
    if (Platform.isAndroid) {
      return "ca-app-pub-3940256099942544~3347511713"; //test ID
    }
    return null;
  }

  String getBannerAdId() {
    return "ca-app-pub-3940256099942544/6300978111"; //Test ID
  }
}
