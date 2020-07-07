import 'package:flutter/material.dart';
import 'package:flash_chat/constants.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

final _firestore = Firestore.instance;
FirebaseUser loggedInUser;

class ChatScreen extends StatefulWidget {
  static const String id='chat_screen';
  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {

  final _auth = FirebaseAuth.instance;

  String messageText;
  final messageTextController=TextEditingController();

  @override
  void initState() {

    super.initState();
    getCurrentUser();
  }

  void getCurrentUser() async {
    try {
      final user = await _auth.currentUser();
      if (user != null) {
        loggedInUser = user;
        print(loggedInUser.email);
      }
    }
    catch(e){
      print(e);
    }
  }

//  void getMessage() async {
//    final messages = await _firestore.collection('messages').getDocuments();
//    for(var message in messages.documents){
//      print(message.data);
//    }
//  }

//  void getStream() async{
//    await for(var snapshot in _firestore.collection('messages').snapshots()){
//      for(var message in snapshot.documents){
//        print(message.data);
//      }
//    }
//  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: null,
        actions: <Widget>[
          IconButton(
              icon: Icon(Icons.close),
              onPressed: () {
                //Implement logout functionality
                _auth.signOut();
                Navigator.pop(context);
              //getMessage();
                // getStream();
              }),
        ],
        title: Text('⚡️Chat'),
        backgroundColor: Colors.lightBlueAccent,
      ),
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            MessageStream(),
            Container(
              decoration: kMessageContainerDecoration,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Expanded(
                    child: TextField(
                      controller: messageTextController,
                      onChanged: (value) {
                        //Do something with the user input.
                        messageText=value;
                      },
                      decoration: kMessageTextFieldDecoration,
                    ),
                  ),
                  FlatButton(
                    onPressed: () {
                      //Implement send functionality.
                      messageTextController.clear();
                      _firestore.collection('messages').add({
                        'text' : messageText,
                        'sender' : loggedInUser.email,
                        'time': FieldValue.serverTimestamp()
                      });
                    },
                    child: Text(
                      'Send',
                      style: kSendButtonTextStyle,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class MessageBubbble extends StatelessWidget {


  MessageBubbble({this.sender,this.text,this.isMe,this.time});

  final String text;
  final String sender;
  final bool isMe;
  final Timestamp time;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: <Widget>[
          Text(sender,
          style: TextStyle(
            fontSize: 12,
            color: Colors.black54
          ),
          ),
//          Text(
//            ' $sender ${DateTime.fromMillisecondsSinceEpoch(time.seconds * 1000)}',// add this only if you want to show the time along with the email. If you dont want this then don't add this DateTime thing
//            style: TextStyle(color: Colors.black54, fontSize: 12),
//          ),
          Material(
            elevation: 5,
            borderRadius: isMe ? BorderRadius.only(topLeft: Radius.circular(30),bottomLeft: Radius.circular(30),bottomRight: Radius.circular(30)) :
            BorderRadius.only(bottomLeft: Radius.circular(30),bottomRight: Radius.circular(30),topRight: Radius.circular(30)),
            color: isMe ? Colors.lightBlueAccent : Colors.white,
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 10,horizontal: 20),
              child: Text(
                text,
                style: TextStyle(
                    fontSize: 15,
                  color: isMe ? Colors.white : Colors.black
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class MessageStream extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: _firestore.collection('messages').orderBy('time', descending: false).snapshots(),
      // ignore: missing_return
      builder: (context, snapshot){
        if(!snapshot.hasData){
          return Center(
            child: CircularProgressIndicator(
              backgroundColor: Colors.lightBlueAccent,
            ),
          );
        }
        final messages=snapshot.data.documents.reversed;
        List<MessageBubbble> messageBubbles=[];
        for(var message in messages){
          final messageText=message.data['text'];
          final messageSender=message.data['sender'];
          final messageTime = message.data['time'] as Timestamp;
          final currentUser=loggedInUser.email;

          final messageBubble= MessageBubbble(sender: messageSender,text: messageText,isMe: currentUser==messageSender,time: messageTime);
          messageBubbles.add(messageBubble);
        }
        return Expanded(
          child: ListView(
            reverse: true,
            children: messageBubbles,
            padding: EdgeInsets.symmetric(horizontal: 10,vertical: 10),
          ),
        );
      },
    );
  }
}
