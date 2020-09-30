import 'package:boots/widgets/customWidgets.dart';
import 'package:flutter/material.dart';
import 'package:boots/page/communities/communities_chat_page.dart';

class GroupTile extends StatelessWidget {
  final String communityId;
  final String communityName;
  final String userName;
  final String communityIcon;

  GroupTile({this.communityId, this.communityName, this.userName, this.communityIcon});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (){
        Navigator.push(context, MaterialPageRoute(builder: (context) => ChatPage(communityId: communityId, communityName: communityName, userName: userName,)));
      },
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 5.0, vertical: 10.0),
        child: ListTile(
          leading: CircleAvatar(
            radius: 20,
            backgroundImage: communityIcon == null ? customAdvanceNetworkImage('https://www.pngitem.com/pimgs/m/153-1538773_community-service-png-community-service-logo-png-transparent.png')
                : customAdvanceNetworkImage(communityIcon),
          ),
          title: Text(communityName, style: TextStyle(fontWeight: FontWeight.bold)),
        ),
      ),
    );
  }
}