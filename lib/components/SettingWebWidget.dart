import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:recipe_app/models/AppModel.dart';
import 'package:recipe_app/network/RestApis.dart';
import 'package:recipe_app/utils/Colors.dart';
import 'package:recipe_app/utils/Common.dart';
import 'package:recipe_app/utils/Constants.dart';
import 'package:recipe_app/utils/DataProvider.dart';

import '../main.dart';

class SettingWebWidget extends StatefulWidget {
  @override
  SettingWebWidgetState createState() => SettingWebWidgetState();
}

class SettingWebWidgetState extends State<SettingWebWidget> {
  List<AppModel> settingData = getSettingData();
  int selected = 0;

  @override
  void initState() {
    super.initState();
    init();
  }

  void init() async {
    //
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: context.width() * 0.5,
      alignment: Alignment.topCenter,
      child: SingleChildScrollView(
        padding: EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(language!.setting, style: boldTextStyle(size: 24)),
            32.height,
            Wrap(
              spacing: 50,
              runSpacing: 50,
              children: settingData.map(
                (e) {
                  int index = settingData.indexOf(e);
                  return HoverWidget(
                    builder: (_, isHovered) => Container(
                      height: 160,
                      padding: EdgeInsets.symmetric(horizontal: 8),
                      width: context.width() * 0.12,
                      decoration: boxDecorationRoundedWithShadow(
                        16,
                        backgroundColor: isHovered ? primaryColor.withOpacity(0.7) : context.cardColor,
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(settingData[index].icon, size: 32, color: context.iconColor),
                          16.height,
                          Text(settingData[index].name!, style: boldTextStyle()),
                        ],
                      ),
                    ).onTap(() async {
                      if (index == 0) {
                        showInDialog(
                          context,
                          builder: (_) => SizedBox(
                            height: 200,
                            width: 200,
                            child: ThemeWidget(
                              onThemeChanged: (val) {
                                if (val == ThemeModeSystem) {
                                  appStore.setDarkMode(MediaQuery.of(context).platformBrightness == Brightness.dark);
                                } else if (val == ThemeModeLight) {
                                  appStore.setDarkMode(false);
                                } else if (val == ThemeModeDark) {
                                  appStore.setDarkMode(true);
                                }
                                LiveStream().emit(streamRefreshToDo);
                                LiveStream().emit(streamRefreshRecipeIndex, '');

                                finish(context);
                              },
                            ),
                          ),
                        );
                      } else if (index == 1) {
                        showInDialog(context, builder: (_) {
                          return Container(
                            height: 300,
                            width: 300,
                            child: LanguageListWidget(
                              widgetType: WidgetType.LIST,
                              onLanguageChange: (v) async {
                                await appStore.setLanguage(v.languageCode!);

                                LiveStream().emit(streamRefreshLanguage);
                                settingData.clear();
                                settingData = getSettingData();

                                setState(() {});
                                finish(context);
                              },
                            ).paddingSymmetric(vertical: 16),
                          );
                        });
                      } else if (index == 4) {
                        if (PrivacyPolicy.isNotEmpty) {
                          launchUrl(PrivacyPolicy, forceWebView: true);
                        }
                      } else if (index == 5) {
                        if (PrivacyPolicy.isNotEmpty) {
                          launchUrl(PrivacyPolicy, forceWebView: true);
                        }
                      } else if (index == 7) {
                        showConfirmDialogCustom(
                          context,
                          primaryColor: primaryColor,
                          title: language!.doYouWantToLogout,
                          positiveText: language!.yes,
                          negativeText: language!.cancel,
                          onAccept: (c) {
                            logout(context);
                          },
                        );
                      } else {
                        settingData[index].widget.launch(context);
                      }
                    }, splashColor: Colors.transparent, highlightColor: Colors.transparent, hoverColor: Colors.transparent),
                  );
                },
              ).toList(),
            ),
          ],
        ),
      ),
    ).center();
  }
}
