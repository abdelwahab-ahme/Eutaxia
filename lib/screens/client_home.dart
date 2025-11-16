
import 'package:flutter/material.dart';
import '../services/api.dart';

class ClientHome extends StatelessWidget {
  static const routeName = '/client_home';
  const ClientHome({super.key});

  @override
  Widget build(BuildContext context) {
    final fromCtrl = TextEditingController();
    final toCtrl = TextEditingController();
    return Scaffold(
      appBar: AppBar(title: const Text('Home')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(12),
        child: Column(children: [
          Card(child: Padding(padding: const EdgeInsets.all(12), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            const Text('Pick-up location'),
            const SizedBox(height: 8),
            Row(children: [Expanded(child: TextField(controller: fromCtrl, decoration: const InputDecoration(hintText: 'From (address or tap map)'))), const SizedBox(width: 8), ElevatedButton(onPressed: () => Navigator.pushNamed(context, '/map_pick', arguments: 'from'), child: const Text('Map'))]),
          ]))),
          const SizedBox(height: 8),
          Card(child: Padding(padding: const EdgeInsets.all(12), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            const Text('Drop-off location'),
            const SizedBox(height: 8),
            Row(children: [Expanded(child: TextField(controller: toCtrl, decoration: const InputDecoration(hintText: 'To (address or tap map)'))), const SizedBox(width: 8), ElevatedButton(onPressed: () => Navigator.pushNamed(context, '/map_pick', arguments: 'to'), child: const Text('Map'))]),
          ]))),
          const SizedBox(height: 8),
          Card(child: Padding(padding: const EdgeInsets.all(12), child: Row(children: [const Expanded(child: Text('Trip type:', textAlign: TextAlign.right)), const SizedBox(width: 8), ChoiceChip(label: const Text('Normal'), selected: true, onSelected: (_) {}), const SizedBox(width: 8), ChoiceChip(label: const Text('Special Needs'), selected: false, onSelected: (_) {})]))),
          const SizedBox(height: 8),
          Card(child: Padding(padding: const EdgeInsets.all(12), child: Row(children: [const Expanded(child: Text('Type of car:', textAlign: TextAlign.right)), Switch(value: true, onChanged: (v) {}), const Expanded(child: Text('Modern')), const SizedBox(width: 8), const Text('Price system:', textAlign: TextAlign.right), IconButton(onPressed: () {}, icon: const Icon(Icons.speed)), IconButton(onPressed: () {}, icon: const Icon(Icons.attach_money))]))),
          const SizedBox(height: 12),
          Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
            ElevatedButton(onPressed: () => ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Show drivers (mock)'))), child: const Text('Show Drivers')),
            ElevatedButton(onPressed: () => ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Voice Request (mock)'))), child: const Text('Voice Request')),
            ElevatedButton(onPressed: () => Navigator.pushNamed(context, '/chat'), child: const Text('💬 Chatbot')),
          ])
        ]),
      ),
    );
  }
}
