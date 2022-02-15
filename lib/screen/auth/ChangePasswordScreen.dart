import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:recipe_app/components/FixSizedBox.dart';
import 'package:recipe_app/main.dart';
import 'package:recipe_app/network/RestApis.dart';
import 'package:recipe_app/utils/Colors.dart';
import 'package:recipe_app/utils/Constants.dart';
import 'package:recipe_app/utils/Widgets.dart';

class ChangePasswordScreen extends StatefulWidget {
  @override
  ChangePasswordScreenState createState() => ChangePasswordScreenState();
}

class ChangePasswordScreenState extends State<ChangePasswordScreen> {
  GlobalKey<FormState> formKey = GlobalKey<FormState>();

  BannerAd? myBanner;

  TextEditingController oldPassword = TextEditingController();
  TextEditingController newPassword = TextEditingController();
  TextEditingController confNewPassword = TextEditingController();

  FocusNode newPassFocus = FocusNode();
  FocusNode conPassFocus = FocusNode();

  @override
  void initState() {
    super.initState();
    init();
  }

  void init() async {
    if (isMobile) myBanner = buildBannerAd()..load();
  }

  BannerAd buildBannerAd() {
    return BannerAd(
      adUnitId: kReleaseMode ? mAdMobBannerId : BannerAd.testAdUnitId,
      size: AdSize.fullBanner,
      listener: BannerAdListener(onAdLoaded: (ad) {
        //
      }),
      request: AdRequest(keywords: testDevices),
    );
  }

  Future<void> submit() async {
    if (formKey.currentState!.validate()) {
      Map req = {
        'old_password': oldPassword.text.trim(),
        'new_password': newPassword.text.trim(),
      };
      appStore.setLoading(true);

      await changePassword(req).then((value) {
        snackBar(context, title: value.message.validate());

        appStore.setLoading(false);

        finish(context);
      }).catchError((error) {
        appStore.setLoading(false);

        toast(error.toString());
      });
    }
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  @override
  void dispose() {
    myBanner!.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBarWidget(language!.changePassword, elevation: 0),
      body: Stack(
        fit: StackFit.expand,
        alignment: Alignment.bottomCenter,
        children: [
          SingleChildScrollView(
            padding: EdgeInsets.symmetric(vertical: 32, horizontal: 16),
            child: Form(
              autovalidateMode: AutovalidateMode.onUserInteraction,
              key: formKey,
              child: FixSizedBox(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    AppTextField(
                      controller: oldPassword,
                      nextFocus: newPassFocus,
                      textFieldType: TextFieldType.PASSWORD,
                      textStyle: primaryTextStyle(color: gray),
                      decoration: inputDecorationRecipe(labelTextName: language!.oldPassword),
                    ),
                    8.height,
                    AppTextField(
                      controller: newPassword,
                      focus: newPassFocus,
                      nextFocus: conPassFocus,
                      textFieldType: TextFieldType.PASSWORD,
                      textStyle: primaryTextStyle(color: gray),
                      decoration: inputDecorationRecipe(labelTextName: language!.newPassword),
                    ),
                    8.height,
                    AppTextField(
                      controller: confNewPassword,
                      focus: conPassFocus,
                      textFieldType: TextFieldType.PASSWORD,
                      textStyle: primaryTextStyle(color: gray),
                      validator: (val) {
                        if (val!.isEmpty) return language!.thisFieldIsRequired;
                        if (val != newPassword.text) return language!.notMatchPassword;
                        return null;
                      },
                      decoration: inputDecorationRecipe(labelTextName: language!.confirmPassword),
                    ),
                    32.height,
                    AppButton(
                      text: language!.changePassword,
                      textStyle: boldTextStyle(color: white),
                      color: primaryColor,
                      width: context.width(),
                      onTap: () {
                        if (appStore.isDemoAdmin) {
                          snackBar(context, title: language!.demoUserMsg);
                        } else {
                          submit();
                        }
                      },
                      shapeBorder: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    )
                  ],
                ),
              ),
            ),
          ),
          if (isMobile)
            myBanner != null && !disabled_ads
                ? Positioned(
                    child: AdWidget(ad: myBanner!),
                    bottom: 0,
                    height: AdSize.banner.height.toDouble(),
                    width: context.width(),
                  )
                : SizedBox(),
        ],
      ),
    );
  }
}
