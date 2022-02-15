import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:recipe_app/models/AppModel.dart';
import 'package:recipe_app/utils/Colors.dart';
import 'package:recipe_app/utils/DataProvider.dart';

import '../main.dart';

class AdminSettingWebWidget extends StatefulWidget {
  @override
  AdminSettingWebWidgetState createState() => AdminSettingWebWidgetState();
}

class AdminSettingWebWidgetState extends State<AdminSettingWebWidget> {
  List<AppModel> adminSettingData = getAdminSettingData();

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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(language!.adminSetting, style: boldTextStyle(size: 24)),
          32.height,
          Wrap(
            spacing: 50,
            runSpacing: 50,
            children: List.generate(
              adminSettingData.length,
              (index) => HoverWidget(
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
                      Icon(adminSettingData[index].icon, size: 32, color: context.iconColor),
                      16.height,
                      Text(adminSettingData[index].name!, style: boldTextStyle()),
                    ],
                  ),
                ).onTap(() {
                  adminSettingData[index].widget!.launch(context);
                }),
              ),
            ),
          ),
        ],
      ),
    ).center().paddingSymmetric(vertical: 45);
  }
}
