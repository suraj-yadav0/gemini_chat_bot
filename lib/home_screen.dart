import 'dart:convert';
import 'dart:math';

import 'package:dash_chat_2/dash_chat_2.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  ChatUser myself = ChatUser(id: '1', firstName: 'Suraj');
  ChatUser bot = ChatUser(id: '2', firstName: 'Gemini');

  List<ChatUser> typing = [];

  List<ChatMessage> allmessages = [];

  final ourUrl =
      'https://generativelanguage.googleapis.com/v1beta/models/gemini-pro:generateContent?key=AIzaSyD_UNxHsJUDiLTNaKmsSXq6xGZKgGIP2SE';

  final header = {'Content-Type ': 'application/json'};

  
  getdata(ChatMessage m) async {
    typing.add(bot);
    allmessages.insert(0, m);
    setState(() {});

    var data = {
      "contents": [
        {
          "parts": [
            {"text": m.text}
          ]
        }
      ]
    };

    await http
        .post(Uri.parse(ourUrl), headers: header, body: jsonEncode(data))
        .then((value) {
          if(value.statusCode == 200) {
var result = jsonDecode(value.body);
print(result['candidates'][0]['content']['parts'][0]['text']);

ChatMessage m1 = ChatMessage(user: bot, createdAt: DateTime.now(),text:result['candidates'][0]['content']['parts'][0]['text'] );

allmessages.insert(0, m1);

          }else {
            print("error occured");
          }
        })
        .catchError((e) {});
        typing.remove(bot);
        setState(() {
  
});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: DashChat(
        typingUsers: typing,
          currentUser: myself,
          onSend: (ChatMessage m) {
            getdata(m);
          },
          messages: allmessages),
    );
  }
}
