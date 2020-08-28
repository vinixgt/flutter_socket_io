import 'package:chat_socketio/utils/socket_client.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';



class InputChat extends StatefulWidget {
  final VoidCallback onSent;
  const InputChat({Key key, @required this.onSent}) : super(key: key);

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
    return Container(
      margin: EdgeInsets.only(top:0),
      decoration: BoxDecoration(
        color: Color(0xff37474f),
        borderRadius: BorderRadius.circular(30),
      ),
      padding: EdgeInsets.symmetric(
        horizontal: 5,
        vertical: 5
      ),
      child: Row(
        children: <Widget>[
          Expanded(
            child: CupertinoTextField(
              decoration: BoxDecoration(
                color: Colors.transparent,
              ),
              padding: EdgeInsets.symmetric(
                horizontal: 20,
                vertical: 5
              ),
              placeholder: 'Your message here...',
              placeholderStyle: TextStyle(color: Color(0xff819ca9)),
              style: TextStyle(
                color: Colors.white,
              ),
              controller: _controller,
              onChanged: SocketClient.instance.onInputChanged,
            ),
          ),
          CupertinoButton(
            borderRadius: BorderRadius.circular(50),
            color: Color(0xffcfd8dc),
            padding: EdgeInsets.all(5),
            child: Icon(
              Icons.send,
              color: Color(0xff819ca9)
            ),
            onPressed: (){
              final bool sent = SocketClient.instance.sendMessage();
              if(sent) {
                _controller.text='';
                widget.onSent();
              }
            },
          )
        ],
      ),
    );
  }
}