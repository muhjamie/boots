import 'package:flutter/material.dart';
import 'package:boots/helper/enum.dart';
import 'package:boots/model/feedModel.dart';
import 'package:boots/state/feedState.dart';
import 'package:boots/widgets/tweet/tweet.dart';
import 'package:boots/widgets/tweet/widgets/unavailableTweet.dart';
import 'package:provider/provider.dart';

class ParentTweetWidget extends StatelessWidget {
  ParentTweetWidget(
      {Key key, this.childRetwetkey, this.type, this.isImageAvailable, this.trailing})
      : super(key: key);

  final String childRetwetkey;
  final TweetType type;
  final Widget trailing;
  final bool isImageAvailable;

  void onTweetPressed(BuildContext context, FeedModel model) {
    var feedstate = Provider.of<FeedState>(context, listen: false);
    feedstate.getpostDetailFromDatabase(null, model: model);
    Navigator.of(context).pushNamed('/FeedPostDetail/' + model.key);
  }

  @override
  Widget build(BuildContext context) {
    var feedstate = Provider.of<FeedState>(context, listen: false);
    return FutureBuilder(
        future: feedstate.fetchTweet(childRetwetkey),
        builder: (context, AsyncSnapshot<FeedModel> snapshot) {
          if (snapshot.hasData) {
            return Tweet(
              model: snapshot.data,
              type: TweetType.ParentTweet,
              trailing:trailing
            );
          }
          if ((snapshot.connectionState == ConnectionState.done ||
                  snapshot.connectionState == ConnectionState.waiting) &&
              !snapshot.hasData) {
            return UnavailableTweet(
              snapshot: snapshot,
              type: type,
            );
          } else {
            return SizedBox.shrink();
          }
        },
      );
  }
}