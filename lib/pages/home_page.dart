import 'package:chat_socketio/pages/home_page_widgets/nickname_form.dart';
import 'package:chat_socketio/utils/consts.dart';
import 'package:flutter/material.dart';
import 'package:chat_socketio/utils/socket_client.dart';
import 'package:get/state_manager.dart';

import 'home_page_widgets/chat.dart';


class HomePage extends StatefulWidget {
  HomePage({Key key }) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    super.initState();
    SocketClient.instance.init();
    SocketClient.instance.connect();
  }

  @override
  void dispose() {
    SocketClient.instance.disconnect();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xff102027),
      appBar: AppBar(
        backgroundColor: accentColor,
        title: Obx(() {
          final users = SocketClient.instance.numUsers;
          return Text('Users ${users.value}');
        }),
      ),
      body: Obx((){
        final status = SocketClient.instance.status;
        if(status.value == SocketStatus.connecting) {
              return Center(
                child: CircularProgressIndicator(),
              );
            } else if (status.value == SocketStatus.connected) {
              return NicknameForm();
            } else if (status.value == SocketStatus.joinded) { 
              return Chat();
            } else {
              return Center(
                child: Text('Disconnected...'),
              );
            }
      }),
    );
  }
}