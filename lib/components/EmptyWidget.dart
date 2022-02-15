import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:recipe_app/utils/Constants.dart';
import 'package:recipe_app/utils/Widgets.dart';

class EmptyWidget extends StatelessWidget {
  final String title;

  EmptyWidget({required this.title});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        commonCachedNetworkImage(EMPTYDATA, fit: BoxFit.cover, height: 150),
        30.height,
        Text(title, style: secondaryTextStyle(size: 18)),
      ],
    ).center();
  }
}
