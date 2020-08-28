import 'package:chat_socketio/models/chat_message.dart';
import 'package:chat_socketio/utils/consts.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class MessageItem extends StatelessWidget {

  final ChatMessage message;

  const MessageItem({Key key, @required this.message}) : super(key: key);

  Widget getUsernameView () {
    return Text(
      message.username,
      style: TextStyle(
        fontSize: 11,
        color: placeholderColor
      ),
    );
  } // getUsername

  @override
  Widget build(BuildContext context) {
    return Wrap(
      alignment: message.sender? WrapAlignment.end : WrapAlignment.start,
      children: <Widget>[
        Column(
          crossAxisAlignment: message.sender ? CrossAxisAlignment.end : CrossAxisAlignment.start,
          children: <Widget>[
            if(!message.sender) getUsernameView(),
            Container(
              constraints: BoxConstraints(
                maxWidth: 300,
              ),
              padding: EdgeInsets.symmetric(
                horizontal: 20,
                vertical: 10
              ),
              child: Text(
                message.message,
              ),
              decoration: BoxDecoration(
                color: message.sender ? accentColor : placeholderColor,
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(20),
                  topRight: Radius.circular(20),
                  topLeft: Radius.circular(message.sender ? 20 : 0),
                  bottomRight: Radius.circular(!message.sender ? 20 : 0)
                )
              ),
            ),
            SizedBox(height: 10),
          ],
        ),
      ],
    );
  }
}