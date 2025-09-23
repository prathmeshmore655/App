import 'package:flutter/material.dart';
import '../widgets/chat_bubble.dart';
import '../widgets/input_field.dart';
import '../models/message_model.dart';
import '../services/chatbot_service.dart';

class ChatbotScreen extends StatefulWidget {
  const ChatbotScreen({super.key});

  @override
  State<ChatbotScreen> createState() => _ChatbotScreenState();
}

class _ChatbotScreenState extends State<ChatbotScreen> {
  final List<Message> _messages = [];
  final ChatbotService _chatbotService = ChatbotService();

  void _sendMessage(String text) async {
    if (text.isEmpty) return;

    setState(() {
      _messages.add(Message(text: text, isUser: true));
    });

    final botReplyMap = await _chatbotService.getResponse(text);
    String botReplyText = '';

    if (botReplyMap.containsKey('error')) {
      botReplyText = 'Error: ${botReplyMap['error']}';
    } else if (botReplyMap.containsKey('text')) {
      botReplyText = botReplyMap['text'];
    } else if (botReplyMap.containsKey('response')) {
      // If response is a string, use it
      if (botReplyMap['response'] is String) {
        botReplyText = botReplyMap['response'];
      } else {
        botReplyText = botReplyMap['response'].toString();
      }
    } else {
      botReplyText = 'No valid response from server.';
    }

    setState(() {
      _messages.add(Message(text: botReplyText, isUser: false));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("MediSync Chatbot")),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(8),
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                return ChatBubble(message: _messages[index]);
              },
            ),
          ),
          InputField(onSend: _sendMessage),
        ],
      ),
    );
  }
}
