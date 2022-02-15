import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';

class FixSizedBox extends StatelessWidget {
  final Widget child;

  FixSizedBox({required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: BoxConstraints(maxWidth: 600),
      child: child,
    ).center();
  }
}
