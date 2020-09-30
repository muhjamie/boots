import 'package:flutter/material.dart';
import 'package:boots/helper/theme.dart';
import 'package:boots/model/user.dart';
import 'package:boots/page/settings/widgets/headerWidget.dart';
import 'package:boots/page/settings/widgets/settingsAppbar.dart';
import 'package:boots/page/settings/widgets/settingsRowWidget.dart';
import 'package:boots/state/authState.dart';
import 'package:provider/provider.dart';

class ContentPrefrencePage extends StatelessWidget {
  const ContentPrefrencePage({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var user = Provider.of<AuthState>(context).userModel ?? User();
    return Scaffold(
      backgroundColor: TwitterColor.white,
      appBar: SettingsAppBar(
        title: 'Content preferences',
        subtitle: user.userName,
      ),
      body: ListView(
        physics: BouncingScrollPhysics(),
        children: <Widget>[
          HeaderWidget('Explore'),
          SettingRowWidget(
            "Trends",
            navigateTo: 'TrendsPage',
          ),
          Divider(height: 0),
          SettingRowWidget(
            "Search settings",
            navigateTo:null,
            ),
         
          HeaderWidget('Languages', secondHeader: true,),
          SettingRowWidget(
            "Recommendations",
            vPadding: 15,
            subtitle: "Select which language you want recommended Tweets, people, and trends to include",
            ),
          HeaderWidget('Safety', secondHeader: true,),
          SettingRowWidget("Blocked accounts"),
          SettingRowWidget("Muted accounts"),

        ],
      ),
    );
  }
}
