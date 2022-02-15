import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:recipe_app/components/FixSizedBox.dart';
import 'package:recipe_app/main.dart';
import 'package:recipe_app/network/RestApis.dart';
import 'package:recipe_app/utils/Colors.dart';
import 'package:recipe_app/utils/Widgets.dart';

class ForgotPasswordScreen extends StatefulWidget {
  @override
  ForgotPasswordScreenState createState() => ForgotPasswordScreenState();
}

class ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  GlobalKey<FormState> formKey = GlobalKey();

  TextEditingController forgotEmailController = TextEditingController();

  @override
  void initState() {
    super.initState();
    init();
  }

  void init() async {
    //
  }

  Future<void> submit() async {
    if (formKey.currentState!.validate()) {
      Map req = {
        'email': forgotEmailController.text.trim(),
      };
      appStore.setLoading(true);

      await forgotPassword(req).then((value) {
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
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBarWidget(language!.forgotPassword),
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Form(
              key: formKey,
              autovalidateMode: AutovalidateMode.onUserInteraction,
              child: FixSizedBox(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    40.height,
                    AppTextField(
                      controller: forgotEmailController,
                      textFieldType: TextFieldType.EMAIL,
                      decoration: inputDecorationRecipe(labelTextName: language!.email),
                    ),
                    16.height,
                    AppButton(
                      shapeBorder: RoundedRectangleBorder(borderRadius: radius(10)),
                      color: primaryColor,
                      width: context.width(),
                      onTap: () {
                        submit();
                      },
                      text: language!.sendYourPassword,
                      textStyle: boldTextStyle(color: white),
                    ),
                  ],
                ).paddingOnly(left: 16, right: 16),
              ),
            ),
          ),
          Observer(builder: (_) => Loader().visible(appStore.isLoader)),
        ],
      ),
    );
  }
}
