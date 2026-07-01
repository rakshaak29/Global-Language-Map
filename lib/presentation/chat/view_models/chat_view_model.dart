import 'package:flutter/material.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:global_language_distribution_map/data/repositories/language_repository.dart';
import 'package:global_language_distribution_map/data/services/gemini_service.dart';

/// Representation of a single chat bubble.
class ChatMessage {
  final String text;
  final bool isUser;
  final DateTime timestamp;

  const ChatMessage({
    required this.text,
    required this.isUser,
    required this.timestamp,
  });
}

/// ViewModel for managing AI chat states.
class ChatViewModel extends ChangeNotifier {
  final LanguageRepository _repository;
  final GeminiService _geminiService;

  final List<ChatMessage> _messages = [];
  bool _isLoading = false;

  ChatViewModel({
    required LanguageRepository repository,
    required GeminiService geminiService,
  })  : _repository = repository,
        _geminiService = geminiService {
    _addWelcomeMessage();
  }

  List<ChatMessage> get messages => _messages;
  bool get isLoading => _isLoading;

  void _addWelcomeMessage() {
    _messages.add(
      ChatMessage(
        text: 'Hello! I am your AI Linguistic Assistant. Ask me anything about the world\'s languages, families, endangerment, or statistics in our dataset!\n\n*(Note: Make sure your Gemini API Key is set in Settings)*',
        isUser: false,
        timestamp: DateTime.now(),
      ),
    );
  }

  /// Sends a message and updates the chat.
  Future<void> sendMessage(String text, String apiKey) async {
    if (text.trim().isEmpty) return;

    _messages.add(ChatMessage(text: text, isUser: true, timestamp: DateTime.now()));
    _isLoading = true;
    notifyListeners();

    try {
      // Map history to google_generative_ai Content format
      final history = _messages.take(_messages.length - 1).map((msg) {
        if (msg.isUser) {
          return Content.text(msg.text);
        } else {
          return Content.model([TextPart(msg.text)]);
        }
      }).toList();

      final response = await _geminiService.askQuestion(
        apiKey: apiKey,
        userQuery: text,
        chatHistory: history,
        repo: _repository,
      );

      _messages.add(ChatMessage(text: response, isUser: false, timestamp: DateTime.now()));
    } catch (e) {
      _messages.add(
        ChatMessage(
          text: 'An unexpected error occurred: $e',
          isUser: false,
          timestamp: DateTime.now(),
        ),
      );
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Clears the chat history.
  void clearChat() {
    _messages.clear();
    _addWelcomeMessage();
    notifyListeners();
  }
}
