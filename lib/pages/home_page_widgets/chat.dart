import 'dart:async';

import 'package:chat_socketio/models/chat_message.dart';
import 'package:chat_socketio/pages/home_page_widgets/input_chat.dart';
import 'package:chat_socketio/pages/home_page_widgets/message_item.dart';
import 'package:chat_socketio/utils/consts.dart';
import 'package:chat_socketio/utils/socket_client.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/state_manager.dart';


class Chat extends StatefulWidget {
  Chat({Key key}) : super(key: key);

  @override
  _ChatState createState() => _ChatState();
}

class _ChatState extends State<Chat> {

  ScrollController _scrollController = ScrollController();
  bool _isEndScroll = false;
  StreamSubscription _subscription;
  ValueNotifier<int> _counter = ValueNotifier(0);

  @override
  void initState() {
    super.initState();
    _subscription = SocketClient.instance.messages.listen((_) {
      if(_.length > 0 && !_.last.sender) {
        if(_isEndScroll){
          _goToEnd();
        }
      } else if(_scrollController.position.maxScrollExtent > 0) {
        _counter.value++;
      }
    });
  }

  @override
  void dispose() {
    _subscription?.cancel();
    super.dispose();
  }

  void _goToEnd() {
    Future.delayed(Duration(milliseconds: 200), () {
      final offset = _scrollController.position.maxScrollExtent;
      _scrollController.animateTo(
        offset,
        duration: Duration(milliseconds: 500),
        curve: Curves.linear
      );
      _counter.value = 0;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: Stack(
          children: <Widget>[
            Container(
              width: double.infinity,
              height: double.infinity,
              padding: EdgeInsets.all(10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Expanded(
                    child: Obx(
                      () {
                        final messages = SocketClient.instance.messages;
                        return NotificationListener(
                          child: ListView.builder(
                            controller: _scrollController,
                            itemBuilder: (_, index){
                              final ChatMessage message = messages[index];
                              return MessageItem(message: message,);
                            },
                            itemCount: messages.length
                          ),
                          onNotification: (t) {
                            if(t is ScrollEndNotification) {
                              this._isEndScroll = _scrollController.offset >=
                                  _scrollController.position.maxScrollExtent;
                            }
                            return false;
                          } ,
                        );
                      }
                    )
                  ),
                  Obx((){ // shows when user is typing ..........
                    final typingUser = SocketClient.instance.typingUsers;
                    if(typingUser != null) {
                      return Text(
                        typingUser,
                        style: TextStyle(
                          color: placeholderColor
                        ),
                      );
                    }
                    // esto para que se agregue un elemento al final y se muestre el ultimo moment
                    return Container(height: 0);
                  }),
                  InputChat(
                    onSent: this._goToEnd,
                  )
                ],
              ),
            ),
            ValueListenableBuilder<int>(
              valueListenable: _counter,
              builder: (_, int counter, __){
                if(counter == 0) {
                  return Container();
                }
                return Positioned(
                  right: 10,
                  bottom: 75,
                  child: FloatingActionButton(
                    onPressed: _goToEnd,
                    backgroundColor: Colors.white,
                    child: Text(
                      counter.toString()
                    ),
                  )
                );
              }
            )
          ],
        ),
      ),
    );
  }
}