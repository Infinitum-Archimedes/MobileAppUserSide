// lib/screens/chat_screen.dart
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class ChatScreen extends StatefulWidget {
  const ChatScreen({Key? key}) : super(key: key);
  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _controller = TextEditingController();
  final List<Map<String, dynamic>> messages = [];
  bool _isLoading = false;

  static const String apiUrl = "https://symptom2disease.onrender.com/predict";

  @override
  void initState() {
    super.initState();
    messages.add({
      'role': 'bot',
      'text':
          'Hi! I’m your health assistant.\n\nTell me your symptoms and I’ll help identify what it might be.\n\nExamples:\n• "I have fever and cough"\n• "Skin itching and red rash"',
    });
  }

  Future<void> _sendMessage(String userText) async {
    if (userText.trim().isEmpty || _isLoading) return;

    final userMessage = userText.trim();
    final symptoms = _extractSymptoms(userMessage);
    print("Extracted symptoms: $symptoms");

    setState(() {
      messages.add({'role': 'user', 'text': userMessage});
      messages.add({'role': 'bot', 'text': 'Analyzing...'});
      _isLoading = true;
    });

    try {
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({"symptoms": symptoms}),
      ).timeout(const Duration(seconds: 30));

      print("Status: ${response.statusCode}");
      print("Response: ${response.body}");

      String botReply;
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final predictions = data['predictions'] as List;

        if (predictions.isEmpty) {
          botReply = "I couldn’t identify any condition.\n\n"
              "Try listing more symptoms or be more specific!";
        } else {
          final top = predictions[0];
          final disease = top['disease'];
          final confidence = (top['confidence'] as num) * 100;

          botReply = "Most likely condition:\n\n"
              "• **$disease**\n"
              "   Confidence: ${confidence.toStringAsFixed(1)}%\n\n"
              "This is NOT a medical diagnosis — just an AI prediction.\n"
              "Please consult a doctor.";
        }
      } else {
        botReply = "Server error ${response.statusCode}\nTry again later.";
      }

      setState(() {
        messages.removeLast();
        messages.add({'role': 'bot', 'text': botReply});
        _isLoading = false;
      });
    } catch (e) {
        setState(() {
          messages.removeLast();
          messages.add({'role': 'bot', 'text': 'No internet or server down.\nTry again in a minute.'});
          _isLoading = false;
        });
    }
  }

  List<String> _extractSymptoms(String text) {
    final Map<String, String> map = {
      'fever': 'high_fever',
      'high fever': 'high_fever',
      'cough': 'cough',
      'headache': 'headache',
      'chills': 'chills',
      'fatigue': 'fatigue',
      'tired': 'fatigue',
      'itching': 'itching',
      'itchy': 'itching',
      'rash': 'skin_rash',
      'skin rash': 'skin_rash',
      'nausea': 'nausea',
      'vomiting': 'vomiting',
      'diarrhea': 'diarrhoea',
      'diarrhoea': 'diarrhoea',
      'joint pain': 'joint_pain',
      'muscle pain': 'muscle_pain',
      'body ache': 'muscle_pain',
      'chest pain': 'chest_pain',
      'shortness of breath': 'breathlessness',
      'dizziness': 'dizziness',
      'loss of smell': 'loss_of_smell',
      'loss of taste': 'loss_of_taste',
      'runny nose': 'runny_nose',
      'sore throat': 'sore_throat',
      'stomach pain': 'abdominal_pain',
      'yellow skin': 'yellowish_skin',
      'dark urine': 'dark_urine',
      'weight loss': 'weight_loss',
    };

    final words = text.toLowerCase().split(RegExp(r'[\s,.;!?]+'));
    final found = <String>{};

    for (final word in words) {
      final clean = word.trim();
      if (map.containsKey(clean)) {
        found.add(map[clean]!);
      }
    }
    return found.toList();
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Scaffold(
      backgroundColor: colorScheme.primaryContainer,
      body: SafeArea(
        child: Column(
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: colorScheme.secondaryContainer,
                border: Border(bottom: BorderSide(color: colorScheme.shadow, width: 1)),
              ),
              child: Center(
                child: Text(
                  'Read Terms & Conditions',
                  style: TextStyle(color: colorScheme.secondary, fontWeight: FontWeight.bold, fontSize: 14),
                ),
              ),
            ),
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: messages.length,
                itemBuilder: (context, i) {
                  final msg = messages[i];
                  final isUser = msg['role'] == 'user';

                  return Align(
                    alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
                    child: Container(
                      margin: const EdgeInsets.symmetric(vertical: 8),
                      padding: const EdgeInsets.all(16),
                      constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.78),
                      decoration: BoxDecoration(
                        color: isUser ? colorScheme.primary : colorScheme.surface,
                        borderRadius: BorderRadius.circular(22),
                        boxShadow: [
                          BoxShadow(color: colorScheme.shadow.withOpacity(0.4), blurRadius: 8, offset: const Offset(0, 3)),
                        ],
                      ),
                      child: Text(
                        msg['text'],
                        style: TextStyle(
                          color: isUser ? colorScheme.onPrimary : colorScheme.onSurface,
                          fontSize: 16,
                          height: 1.4,
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
            Container(
              padding: EdgeInsets.only(
                left: 16,
                right: 16,
                top: 12,
                bottom: MediaQuery.of(context).viewInsets.bottom + 20,
              ),
              decoration: BoxDecoration(
                color: colorScheme.surfaceContainer,
                boxShadow: [BoxShadow(color: colorScheme.shadow.withOpacity(0.3), blurRadius: 10)],
              ),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _controller,
                      enabled: !_isLoading,
                      style: TextStyle(color: colorScheme.onSurface),
                      decoration: InputDecoration(
                        hintText: "Describe your symptoms...",
                        hintStyle: TextStyle(color: colorScheme.onSurface.withOpacity(0.6)),
                        filled: true,
                        fillColor: colorScheme.surface,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30),
                          borderSide: BorderSide.none,
                        ),
                        contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                      ),
                      onSubmitted: (_) => _sendMessage(_controller.text),
                    ),
                  ),
                  const SizedBox(width: 12),
                  FloatingActionButton(
                    onPressed: _isLoading ? null : () => _sendMessage(_controller.text),
                    backgroundColor: colorScheme.primary,
                    child: _isLoading
                        ? SizedBox(width: 24, height: 24, child: CircularProgressIndicator(color: colorScheme.onPrimary, strokeWidth: 2.5))
                        : Icon(Icons.send, color: colorScheme.onPrimary),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}