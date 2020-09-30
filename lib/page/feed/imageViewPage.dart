import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:boots/helper/constant.dart';
import 'package:boots/helper/utility.dart';
import 'package:boots/model/feedModel.dart';
import 'package:boots/model/user.dart';
import 'package:boots/state/authState.dart';
import 'package:boots/state/feedState.dart';
import 'package:boots/widgets/customWidgets.dart';
import 'package:boots/widgets/tweet/widgets/tweetIconsRow.dart';
import 'package:provider/provider.dart';

class ImageViewPge extends StatefulWidget {
  _ImageViewPgeState createState() => _ImageViewPgeState();
}

class _ImageViewPgeState extends State<ImageViewPge> {
  bool isToolAvailable = true;

  FocusNode _focusNode;
  TextEditingController _textEditingController;

  @override
  void initState() {
    _focusNode = FocusNode();
    _textEditingController = TextEditingController();
    super.initState();
  }

  Widget _body() {
    var state = Provider.of<FeedState>(context);
    return Stack(
      children: <Widget>[
        SingleChildScrollView(
          child: Container(
            color: Colors.black,
            constraints: BoxConstraints(
              maxHeight: fullHeight(context),
            ),
            child: InkWell(
              onTap: () {
                setState(() {
                  isToolAvailable = !isToolAvailable;
                });
              },
              child: _imageFeed(state.tweetDetailModel.last.imagePath),
            ),
          ),
        ),
        !isToolAvailable
            ? Container()
            : Align(
                alignment: Alignment.topLeft,
                child: SafeArea(
                  child: Container(
                      width: 50,
                      height: 50,
                      alignment: Alignment.topLeft,
                      /*decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.green.shade700.withAlpha(200),
                      ),*/
                      child: Wrap(
                        children: <Widget>[
                          GestureDetector(
                            child: Icon(Icons.arrow_back_ios, color: Colors.green),
                            onTap: () => Navigator.pop(context),
                          ),
                        ],
                      )),
                )),
        !isToolAvailable
            ? Container()
            : Align(
                alignment: Alignment.bottomCenter,
                child: Container(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: <Widget>[
                      TweetIconsRow(
                        model: state.tweetDetailModel.last,
                        iconColor: Theme.of(context).colorScheme.onPrimary,
                        iconEnableColor:
                            Theme.of(context).colorScheme.onPrimary,
                      ),
                      Container(
                        color: Colors.black.withAlpha(200),
                        padding:
                            EdgeInsets.only(right: 10, left: 10, bottom: 10),
                        child: TextField(
                          controller: _textEditingController,
                          maxLines: null,
                          style: TextStyle(color: Colors.white),
                          decoration: InputDecoration(
                            fillColor: Colors.blue,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.all(
                                Radius.circular(30.0),
                              ),
                              borderSide: BorderSide(
                                color: Colors.white,
                              ),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.all(
                                Radius.circular(30.0),
                              ),
                              borderSide: BorderSide(
                                color: Colors.white,
                              ),
                            ),
                            suffixIcon: IconButton(
                              onPressed: () {
                                _submitButton();
                              },
                              icon: Icon(Icons.send, color: Colors.white),
                            ),
                            focusColor: Colors.black,
                            contentPadding: EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 10,
                            ),
                            hintText: 'Comment here..',
                            hintStyle: TextStyle(
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
      ],
    );
  }

  Widget _imageFeed(String _image) {
    return _image == null
        ? Container()
        : Container(
            alignment: Alignment.center,
            child: Container(
              child: customNetworkImage(
                _image,
                fit: BoxFit.fitWidth,
              ),
            ),
          );
  }

  void addLikeToTweet() {
    var state = Provider.of<FeedState>(context,listen: false);
    var authState = Provider.of<AuthState>(context,listen: false);
    state.addLikeToTweet(state.tweetDetailModel.last, authState.userId);
  }

  void _submitButton() {
    if (_textEditingController.text == null ||
        _textEditingController.text.isEmpty) {
      return;
    }
    if (_textEditingController.text.length > 280) {
      return;
    }
    var state = Provider.of<FeedState>(context,listen: false);
    var authState = Provider.of<AuthState>(context,listen: false);
    var user = authState.userModel;
    var profilePic = user.profilePic;
    if (profilePic == null) {
      profilePic = dummyProfilePic;
    }
    var name = authState.userModel.displayName ??
        authState.userModel.email.split('@')[0];
    var pic = authState.userModel.profilePic ?? dummyProfilePic;
    var tags = getHashTags(_textEditingController.text);

    User commentedUser = User(
        displayName: name,
        userName: authState.userModel.userName,
        isVerified: authState.userModel.isVerified,
        profilePic: pic,
        userId: authState.userId);

    var postId = state.tweetDetailModel.last.key;

    FeedModel reply = FeedModel(
      description: _textEditingController.text,
      user: commentedUser,
      createdAt: DateTime.now().toUtc().toString(),
      tags: tags,
      userId: commentedUser.userId,
      parentkey: postId,
    );
    state.addcommentToPost(reply);
    FocusScope.of(context).requestFocus(_focusNode);
    setState(() {
      _textEditingController.text = '';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: _body());
  }
}
