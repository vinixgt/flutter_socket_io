import 'package:chat_socketio/models/chat_message.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:overlay_support/overlay_support.dart';
import 'package:socket_io_client/socket_io_client.dart' as Io;




enum SocketStatus { connecting, connected, joinded, disconnected, error }

class SocketClient {

  SocketClient._internal();
  static SocketClient _instance = SocketClient._internal();
  static SocketClient get instance => _instance;

  RxInt _numUsers = 0.obs;
  RxInt get numUsers => _numUsers;
  RxString _inputText = "".obs;

  RxString _userLeft = "".obs;
  RxString get userLeft => _userLeft;

  RxList<ChatMessage> _messages = List<ChatMessage>().obs;
  RxList get messages => _messages;

  RxMap<String, String> _typingUsers = Map<String, String>().obs;
  String get typingUsers {
    return this._typingUsers.values.length > 0 ? '${this._typingUsers.values.last} is typing...' : '';
  }

  Rx<SocketStatus> _status = SocketStatus.connecting.obs;
  Rx<SocketStatus> get status => _status;

  Io.Socket _socket;
  String _nickname;
  Worker _typingworker;


  void init() {

    debounce(this._inputText, (_) {
      this._socket?.emit('stop typing');
      this._typingworker = null;

    }, time: Duration(milliseconds: 500));
  }

  void connect() {
    this._socket = Io.io(
      'https://socketio-chat-h9jt.herokuapp.com',
      <String, dynamic>{
      'transports': ['websocket'],
    });

    this._socket.on('connect', (_) {
      print('we connected to websocket');
      this._status.value = SocketStatus.connected;
    });

    this._socket.on('connect_error', (_) {
      print('Error to connect socket');
      this._status.value = SocketStatus.error;
    });

    this._socket.on('disconnect', (_) {
      print('Disconect $_');
      this._status.value = SocketStatus.disconnected;
    });

    this._socket.on('login', (data) {
      print('login....... $data');
      this._numUsers.value = data['numUsers'];

      this._status.value = SocketStatus.joinded;
    });

    this._socket.on('user joined', (data){
      this._numUsers.value = data['numUsers'];
      print('user joined $data $_numUsers');
    });

    this._socket.on('typing', (data) {
      print('user typing $data');
      this._typingUsers.add(data['username'], data['username']);
    });

    this._socket.on('stop typing', (data) {
      this._typingUsers.remove(data['username']);
    });

    this._socket.on('user left', (data) {
      print('user left $data');
      this._numUsers.value = data['numUsers'] as int;
      showSimpleNotification(
        Text('${data['username']}'),
        background: Colors.red
      );
    });

    this._socket.on('new message', (data) {
      print('message: $data');
      this._messages.add(
        ChatMessage(
          username: data['username'],
          message: data['message'],
          sender: false
        )
      );
    });

  }

  void disconnect(){
    this._socket?.disconnect();
    this._socket = null;
  }

  void joinToChat(String nickname) {
    this._nickname = nickname;
    this._socket?.emit('add user', this._nickname);
  }

  void onInputChanged(String text) {
    if(this._typingworker == null) {
      this._typingworker= once(this._inputText, (_){
        print('start typing');
        this._socket?.emit('typing');
      });
    }
    this._inputText.value = text;
  }
} // class