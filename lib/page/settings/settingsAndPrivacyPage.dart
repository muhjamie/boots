import 'package:flutter/material.dart';
import 'package:boots/helper/theme.dart';
import 'package:boots/model/user.dart';
import 'package:boots/page/settings/widgets/headerWidget.dart';
import 'package:boots/state/authState.dart';
import 'package:boots/widgets/customAppBar.dart';
import 'package:boots/widgets/customWidgets.dart';
import 'package:boots/widgets/newWidget/customUrlText.dart';
import 'package:provider/provider.dart';
import 'widgets/settingsRowWidget.dart';

class SettingsAndPrivacyPage extends StatelessWidget {
  const SettingsAndPrivacyPage({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var user = Provider.of<AuthState>(context).userModel ?? User();
    return Scaffold(
      backgroundColor: TwitterColor.white,
      appBar: CustomAppBar(
        isBackButton: true,
        title: customTitleText(
          'Settings and privacy',
        ),
      ),
      body: ListView(
        children: <Widget>[
          HeaderWidget(user.userName),
          SettingRowWidget(
            "Account",
            navigateTo: 'AccountSettingsPage',
          ),
          Divider(height: 0),
          SettingRowWidget("Privacy and Policy",
              navigateTo: 'PrivacyAndSaftyPage'),
          SettingRowWidget("Notification", navigateTo: 'NotificationPage'),
          SettingRowWidget("Content prefrences",
              navigateTo: 'ContentPrefrencePage'),
          HeaderWidget(
            'General',
            secondHeader: true,
          ),
          SettingRowWidget("Display and Sound",
              navigateTo: 'DisplayAndSoundPage'),
          SettingRowWidget("Data usage", navigateTo: 'DataUsagePage'),
          SettingRowWidget("Accessibility", navigateTo: 'AccessibilityPage'),
          SettingRowWidget("Proxy", navigateTo: "ProxyPage"),
          SettingRowWidget(
            "About Boots",
            navigateTo: "AboutPage",
          ),
          SettingRowWidget(
            null,
            showDivider: false,
            vPadding: 10,
            subtitle:
                'These settings affect all of your Boots accounts on this devce.',
          )
        ],
      ),
    );
  }
}
