import 'package:chat_socketio/utils/socket_client.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class InputChat extends StatefulWidget {
  const InputChat({Key key}) : super(key: key);

  @override
  _InputChatState createState() => _InputChatState();
}

class _InputChatState extends State<InputChat> {

  final TextEditingController _controller = TextEditingController();
  
  @override
  void dispse() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        Expanded(
          child: CupertinoTextField(
            controller: _controller,
            onChanged: SocketClient.instance.onInputChanged,
          ),
        ),
        CupertinoButton(
          child: Icon(Icons.send),
          onPressed: (){
            final bool sent = SocketClient.instance.sendMessage();
            if(sent) {
              _controller.text='';
            }
          },
        )
      ],
    );
  }
}