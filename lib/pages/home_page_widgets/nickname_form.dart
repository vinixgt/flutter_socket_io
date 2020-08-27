import 'package:chat_socketio/utils/consts.dart';
import 'package:chat_socketio/utils/socket_client.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class NicknameForm extends StatefulWidget {

  const NicknameForm({Key key}): super(key: key);

  @override
  _NicknameFormState createState() => _NicknameFormState();
}

class _NicknameFormState extends State<NicknameForm> {

  String _nickname = '';
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Container(
        width: double.infinity,
        height: double.infinity,
        color: Colors.transparent,
        padding: EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'What\'s your nickname?', 
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 20
              )
            ),
            SizedBox(height: 20),
            CupertinoTextField(
              placeholder: 'Insert your nickname',
              textAlign: TextAlign.center,
              onChanged: (text) {
                this._nickname = text;
              },
              decoration: BoxDecoration(
                color: textfieldBackgroundColor,
                borderRadius: BorderRadius.circular(10)
              ),
              style: TextStyle(color: Colors.white)
            ),
            SizedBox(height: 20),
            CupertinoButton(
              color: accentColor,
              borderRadius: BorderRadius.circular(20),
              onPressed: (){
                if(this._nickname.trim().length > 1) {
                  SocketClient.instance.joinToChat(this._nickname);
                }
              },
              child: Text('Join to chat'),
            ),
          ],
        )
      ),
    );
  }
}