import 'dart:async';

import 'package:chat_gpt_sdk/chat_gpt_sdk.dart';
import 'package:flutter/material.dart';
import 'package:velocity_x/velocity_x.dart';

import 'chat_message.dart';
class Chatscreen extends StatefulWidget {
  const Chatscreen({Key? key}) : super(key: key);

  @override
  State<Chatscreen> createState() => _ChatscreenState();
}

class _ChatscreenState extends State<Chatscreen> {

  final TextEditingController _controller = TextEditingController();
  final List<ChatMessage> _messages = [];
  ChatGPT? chatGPT;

  StreamSubscription? _subscription;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    chatGPT = ChatGPT.instance;
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _subscription?.cancel();
    super.dispose();
  }

  //Link for api - https://beta.openai.com/acount/api-keys

  void _sendMessage() {
    ChatMessage _message = ChatMessage(text: _controller.text, sender: "user");

    setState(() {
      _messages.insert(0, _message);
    });

    _controller.clear();

    final request = CompleteReq(prompt: message.text, model: kTranslateModelV3, max_tokens: 300);

    _subscription = chatGPT!
        .builder("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",
        orgId: "")
    .onCompleteStream(request: request)
    .listen((response) {
      Vx.log(response!.choices[0].text);
      ChatMessage botMessage = ChatMessage(
          text: response!.choices[0].text, sender: "bot");

      setState(() {
        _messages.insert(0, botMessage);
      });

    });


  }

  Widget _buildTextComposer(){
    return Row(children: [
      Expanded(
          child: TextField(
            controller: _controller,
            onSubmitted: (value) => _sendMessage(),
            decoration: const InputDecoration.collapsed(hintText: "Send a message"),
          ),
      ),
      IconButton(
        icon: const Icon(Icons.send),
        onPressed: () => _sendMessage(),
      )
    ],
    ).px16();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("ChatGPT"),),
      body: SafeArea(
      child: Column(
        children: [
          Flexible(
              child: ListView.builder(
            reverse: true,
            padding: Vx.m8,
            itemCount: _messages.length,
            itemBuilder: (context, index){
              return _messages[index];
            },
          )),
          Container(
            decoration: BoxDecoration(
              color: context.cardColor,
            ),
            child: _buildTextComposer(),
          )
        ],
      ),
      )
    );
  }
}
