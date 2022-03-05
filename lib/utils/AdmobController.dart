import 'dart:io';

import 'package:get/get.dart';

import 'package:logger/logger.dart';
import 'package:meta/meta.dart';
import 'package:native_admob_flutter/native_admob_flutter.dart';

import '../utils/Myadmob.dart';

const TEST = false;

class AdmobController extends GetxController {
  // AdmobInterstitial interstitialAd;
  late InterstitialAd interstitialAd;

  late AppOpenAd appOpenAd;

  final bannerController = BannerAdController();

  Logger logger = Logger();

  @override
  void onInit() {
    super.onInit();
    // getInfo();
    logger.i("ADMOB CONTROLLER STARTED");
  }

  void onClose() {
    bannerController.dispose();
  }

  getAdMobAppId() {
    if (Platform.isIOS) {
      return TEST ? MyAdmob.TEST_app_id_ios : MyAdmob.PROD_app_id_ios;
    } else if (Platform.isAndroid) {
      return TEST ? MyAdmob.TEST_app_id_android : MyAdmob.PROD_app_id_android;
    }
    return null;
  }

  getBannerAdId() {
    if (Platform.isIOS) {
      // return ;
      return TEST ? MyAdmob.TEST_banner_id_ios : MyAdmob.PROD_banner_id_ios;
    } else if (Platform.isAndroid) {
      // return ;
      return TEST
          ? MyAdmob.TEST_banner_id_android
          : MyAdmob.PROD_banner_id_android;
    }
    return null;
  }

  getInterstitialAdId() {
    if (Platform.isIOS) {
      return TEST
          ? MyAdmob.TEST_interstitial_id_ios
          : MyAdmob.PROD_interstitial_id_ios;
    } else if (Platform.isAndroid) {
      return TEST
          ? MyAdmob.TEST_interstitial_id_android
          : MyAdmob.PROD_interstitial_id_android;
    }
    return null;
  }

  getOpenAdId() {
    if (Platform.isIOS) {
      return TEST ? MyAdmob.TEST_open_ad_id_ios : MyAdmob.PROD_open_ad_id_ios;
    } else if (Platform.isAndroid) {
      return TEST
          ? MyAdmob.TEST_open_ad_id_android
          : MyAdmob.PROD_open_ad_id_android;
    }
    return null;
  }

  loadInterstitial() {
    interstitialAd = InterstitialAd(unitId: getInterstitialAdId());
    // myInterstitial = InterstitialAd(
    //   adUnitId: getInterstitialAdId(),
    //   request: AdRequest(),
    //   listener: AdListener(),
    // );

    logger.i("interstitial loading..");

    interstitialAd.load();
  }

  showInterstitial() async {
    if (interstitialAd.isLoaded) {
      logger.i("interstitial is loaded");
      interstitialAd.show();
    }
  }

  loadOpenad() {
    appOpenAd = AppOpenAd(timeout: Duration(minutes: 30));

    appOpenAd.load(orientation: AppOpenAd.ORIENTATION_PORTRAIT);
  }

  showAppOpen() async {
    if (!appOpenAd.isAvailable) await appOpenAd.load();
    if (appOpenAd.isAvailable) {
      await appOpenAd.show();
      // Load a new ad right after the other one was closed
      appOpenAd.load();
    }
  }

  showBanner() async {
    bannerController.onEvent.listen((e) {
      final event = e.keys.first;
      // final info = e.values.first;
      switch (event) {
        case BannerAdEvent.loaded:
          // setState(() => _bannerAdHeight = (info as int)?.toDouble());
          break;
        default:
          break;
      }
    });
    bannerController.load();
  }
}
