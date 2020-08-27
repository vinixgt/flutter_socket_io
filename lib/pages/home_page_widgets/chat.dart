import 'package:chat_socketio/models/chat_message.dart';
import 'package:chat_socketio/utils/socket_client.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/state_manager.dart';
import 'package:socket_io_client/socket_io_client.dart';


class Chat extends StatefulWidget {
  Chat({Key key}) : super(key: key);

  @override
  _ChatState createState() => _ChatState();
}

class _ChatState extends State<Chat> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        width: double.infinity,
        height: double.infinity,
        padding: EdgeInsets.all(10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Expanded(
              child: Obx((){
                final messages = SocketClient.instance.messages;
                return ListView.builder(
                  itemBuilder: (_, index){
                    final ChatMessage message = messages[index];
                    return ListTile(
                      title: Text(message.message)
                    );
                  },
                  itemCount: messages.length
                );
              })
            ),
            Obx((){
              final typingUsers = SocketClient.instance.typingUsers;
              return Text(
                typingUsers,
                style: TextStyle(
                  color: Colors.black26
                ),
              );
              }
            ),
            CupertinoTextField(
              onChanged: (text){
                SocketClient.instance.onInputChanged(text);

              },
            )
          ],
        ),
      ),
    );
  }
}