
import 'package:flutter/material.dart';

class ChatScreen extends StatefulWidget {
  static const routeName = '/chat';
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final messages = <String>[];
  final controller = TextEditingController();

  void sendMessage() {
    final text = controller.text.trim();
    if (text.isEmpty) return;
    setState(() { messages.insert(0, "you: \$text"); });
    controller.clear();
    // mock reply
    Future.delayed(const Duration(milliseconds: 800), () {
      setState(() { messages.insert(0, "intelligence: Mock reply for \$text"); });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(appBar: AppBar(title: const Text('Chat')), body: Column(children: [
      Expanded(child: ListView.builder(reverse: true, padding: const EdgeInsets.all(12), itemCount: messages.length, itemBuilder: (ctx, i) => Align(alignment: Alignment.centerLeft, child: Card(child: Padding(padding: const EdgeInsets.all(8.0), child: Text(messages[i])))))),
      Padding(padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8), child: Row(children: [Expanded(child: TextField(controller: controller, decoration: const InputDecoration(hintText: 'Write your inquiry here'))), const SizedBox(width: 8), ElevatedButton(onPressed: sendMessage, child: const Text('send'))])),
    ]));
  }
}
