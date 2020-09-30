import 'package:flutter/material.dart';
import 'package:boots/state/searchState.dart';
import 'package:provider/provider.dart';
import 'package:boots/model/user.dart';
import 'package:boots/helper/utility.dart';
import 'package:boots/helper/theme.dart';
import 'package:boots/helper/constant.dart';
import 'package:boots/widgets/customWidgets.dart';
import 'package:boots/widgets/newWidget/title_text.dart';

class NearbyPage extends StatefulWidget {
  @override
  _NearbyPageState createState() => _NearbyPageState();
}

class _NearbyPageState extends State<NearbyPage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final state = Provider.of<SearchState>(context, listen: false);
      state.resetFilterList();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final state = Provider.of<SearchState>(context);
    final list = state.userlist;
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        leading: GestureDetector(
          child: Icon(Icons.arrow_back_ios, size: 20, color: Colors.white,),
          onTap: () => Navigator.pop(context),
        ),
        elevation: 0.0,
        backgroundColor: Colors.green,
        title: Text('Nearby People', style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold, color: Colors.white)),
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          state.getDataFromDatabase();
          return Future.value(true);
        },
        child: ListView.separated(
          addAutomaticKeepAlives: false,
          physics: BouncingScrollPhysics(),
          itemBuilder: (context, index) => _UserTile(user: list[index]),
          separatorBuilder: (_, index) => Divider(
            height: 0,
          ),
          itemCount: list?.length ?? 0,
        ),
      ),
    );
  }
}



class _UserTile extends StatelessWidget {
  const _UserTile({Key key, this.user}) : super(key: key);
  final User user;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: () {
        kAnalytics.logViewSearchResults(searchTerm: user.userName);
        Navigator.of(context).pushNamed('/ProfilePage/' + user?.userId);
      },
      leading: customImage(context, user.profilePic, height: 40),
      title: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Flexible(
            child: TitleText(user.displayName,
                fontSize: 16,
                fontWeight: FontWeight.w800,
                overflow: TextOverflow.ellipsis),
          ),
          SizedBox(width: 3),
          user.isVerified
              ? customIcon(
            context,
            icon: AppIcon.blueTick,
            istwitterIcon: true,
            iconColor: AppColor.primary,
            size: 13,
            paddingIcon: 3,
          )
              : SizedBox(width: 0),
        ],
      ),
      subtitle: Text(user.userName),
    );
  }
}