import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:boots/widgets/group_message_tile.dart';
import 'package:provider/provider.dart';
import 'package:boots/state/communitiesState.dart';

class ChatPage extends StatefulWidget {
  final String communityId;
  final String userId;
  final String userName;
  final String communityName;

  ChatPage({
    this.communityId,
    this.userId,
    this.userName,
    this.communityName
  });

  @override
  _ChatPageState createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {

  Stream<QuerySnapshot> _chats;
  TextEditingController messageEditingController = new TextEditingController();

  Widget _chatMessages(){
    return StreamBuilder(
      stream: _chats,
      builder: (context, snapshot){
        return snapshot.hasData ?  ListView.builder(
            itemCount: snapshot.data.documents.length,
            itemBuilder: (context, index){
              return MessageTile(
                message: snapshot.data.documents[index].data["message"],
                sender: snapshot.data.documents[index].data["sender"],
                sentByMe: widget.userName == snapshot.data.documents[index].data["sender"],
              );
            }
        )
            :
        Container();
      },
    );
  }

  _sendMessage() {
    final state = Provider.of<CommunitiesState>(context, listen: false);
    if (messageEditingController.text.isNotEmpty) {
      Map<String, dynamic> chatMessageMap = {
        "message": messageEditingController.text,
        "sender": widget.userName,
        "senderUserId": '',
        'time': DateTime.now()?.millisecondsSinceEpoch,
      };
      state.sendMessage(widget.communityId, chatMessageMap);
      setState(() {
        messageEditingController.text = "";
      });
    }
  }

  @override
  void initState() {
    super.initState();
    getChats();
  }

  getChats() {
    final state = Provider.of<CommunitiesState>(context, listen: false);
    state.getChats(widget.communityId).then((val) {
      // print(val);
      setState(() {
        _chats = val;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: GestureDetector(
          child: Icon(Icons.arrow_back_ios, size: 20, color: Colors.white,),
          onTap: () => Navigator.pop(context),
        ),
        title: Text(widget.communityName, style: TextStyle(color: Colors.white, fontSize: 20)),
        backgroundColor: Colors.green,
        elevation: 0.0,
      ),
      body: Container(
        child: Stack(
          children: <Widget>[
            _chatMessages(),
            // Container(),
            Container(
              alignment: Alignment.bottomCenter,
              width: MediaQuery.of(context).size.width,
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 15.0, vertical: 10.0),
                color: Colors.grey[200],
                child: Row(
                  children: <Widget>[
                    Expanded(
                      child: TextField(
                        controller: messageEditingController,
                        style: TextStyle(
                            color: Colors.grey[700]
                        ),
                        decoration: InputDecoration(
                            hintText: "Send a message ...",
                            hintStyle: TextStyle(
                              color: Colors.grey[700],
                              fontSize: 16,
                            ),
                            border: InputBorder.none
                        ),
                      ),
                    ),

                    SizedBox(width: 12.0),

                    GestureDetector(
                      onTap: () {
                        _sendMessage();
                      },
                      child: Container(
                        height: 50.0,
                        width: 50.0,
                        decoration: BoxDecoration(
                            color: Colors.green,
                            borderRadius: BorderRadius.circular(50)
                        ),
                        child: Center(child: Icon(Icons.send, color: Colors.white)),
                      ),
                    )
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}