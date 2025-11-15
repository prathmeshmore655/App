import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:medisync360/UI/User%20Screens/Chatbot/chatbot_bloc.dart';
import 'package:medisync360/UI/User%20Screens/Chatbot/chatbot_event.dart';
import 'package:medisync360/UI/User%20Screens/Chatbot/chatbot_state.dart';

class ChatbotScreen extends StatefulWidget {
  const ChatbotScreen({super.key});

  @override
  State<ChatbotScreen> createState() => _ChatbotScreenState();
}

class _ChatbotScreenState extends State<ChatbotScreen> {
  final TextEditingController _symptomController = TextEditingController();
  final TextEditingController _daysController = TextEditingController();

  @override
  void initState() {
    super.initState();
    context.read<ChatbotBloc>().add(LoadSymptomsEvent());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Healthcare Chatbot")),
      body: BlocBuilder<ChatbotBloc, ChatbotState>(
        builder: (context, state) {
          if (state is ChatbotLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is ChatbotLoaded) {
            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  TextField(
                    controller: _symptomController,
                    decoration: const InputDecoration(
                      labelText: "Enter symptom",
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 10),
                  ElevatedButton(
                    onPressed: () {
                      context.read<ChatbotBloc>().add(AddSymptomEvent(_symptomController.text.trim()));
                      _symptomController.clear();
                    },
                    child: const Text("Add Symptom"),
                  ),
                  const SizedBox(height: 10),
                  Wrap(
                    children: state.selectedSymptoms
                        .map((symptom) => Chip(label: Text(symptom)))
                        .toList(),
                  ),
                  const SizedBox(height: 20),
                  TextField(
                    controller: _daysController,
                    decoration: const InputDecoration(
                      labelText: "Days of symptoms",
                      border: OutlineInputBorder(),
                    ),
                    keyboardType: TextInputType.number,
                  ),
                  const SizedBox(height: 10),
                  ElevatedButton(
                    onPressed: () {
                      final days = int.tryParse(_daysController.text) ?? 1;
                      context.read<ChatbotBloc>().add(SubmitDiagnosisEvent(days));
                    },
                    child: const Text("Get Diagnosis"),
                  ),
                ],
              ),
            );
          } else if (state is ChatbotDiagnosing) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is ChatbotDiagnosisResult) {
            final res = state.result;
            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: ListView(
                children: [
                  Text("🩺 Disease: ${res.disease}", style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 10),
                  Text("📖 Description:\n${res.description}"),
                  const SizedBox(height: 10),
                  Text("🧍‍♂️ Precautions:"),
                  ...res.precautions.map((p) => ListTile(leading: const Icon(Icons.check), title: Text(p))),
                  const SizedBox(height: 10),
                  if (res.consultDoctor)
                    const Text("⚠️ You should consult a doctor.", style: TextStyle(color: Colors.red)),
                  ElevatedButton(
                    onPressed: () {
                      context.read<ChatbotBloc>().add(LoadSymptomsEvent());
                    },
                    child: const Text("Start New Diagnosis"),
                  )
                ],
              ),
            );
          } else if (state is ChatbotError) {
            return Center(child: Text("Error: ${state.message}"));
          }
          return const Center(child: Text("Loading chatbot..."));
        },
      ),
    );
  }
}
