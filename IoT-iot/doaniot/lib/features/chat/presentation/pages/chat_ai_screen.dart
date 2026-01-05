import 'package:flutter/material.dart';
import 'package:doaniot/core/theme/app_colors.dart';
import 'package:flutter_svg/svg.dart';

class ChatAIScreen extends StatefulWidget {
  const ChatAIScreen({super.key});

  @override
  State<ChatAIScreen> createState() => _ChatAIScreenState();
}

class _ChatAIScreenState extends State<ChatAIScreen> {
  final TextEditingController _controller = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final List<Map<String, dynamic>> _messages = [
    {
      "isUser": false,
      "text": "Hello there! 👋 How can I assist you today?",
      "time": "09:41",
    },
  ];

  void _sendMessage() {
    if (_controller.text.trim().isEmpty) return;

    final userText = _controller.text.trim();
    final time =
        "${DateTime.now().hour}:${DateTime.now().minute.toString().padLeft(2, '0')}";

    setState(() {
      _messages.add({"isUser": true, "text": userText, "time": time});
      _controller.clear();
      _scrollToBottom();
    });

    // Simple AI Logic
    Future.delayed(const Duration(seconds: 1), () {
      String botResponse =
          "I'm sorry, I didn't quite catch that. Could you try again?";
      if (userText.toLowerCase().contains("smartify") ||
          userText.toLowerCase().contains("cool things")) {
        botResponse =
            "Awesome! 🎉 With Smartify, you can control devices, set up automation, manage energy, and more! What are you interested in exploring first?";
      } else if (userText.toLowerCase().contains("automation")) {
        botResponse =
            "Hmm, tell me about automation. How can I set it up? You can go to the 'Scenes' tab and create a new automation rule easily!";
      } else if (userText.toLowerCase().contains("hello") ||
          userText.toLowerCase().contains("hi")) {
        botResponse = "Hi! Ready to make your home smarter?";
      }

      if (mounted) {
        setState(() {
          _messages.add({
            "isUser": false,
            "text": botResponse,
            "time": time,
          }); // Using same time for simplicity
          _scrollToBottom();
        });
      }
    });
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          "Chat with Bobo",
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.more_vert, color: Colors.black),
            onPressed: () {},
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              controller: _scrollController,
              padding: const EdgeInsets.all(16),
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                final message = _messages[index];
                final isUser = message["isUser"] as bool;
                return _buildMessage(
                  message["text"],
                  message["time"],
                  isUser,
                  index == 0 ||
                      _messages[index - 1]["isUser"] !=
                          isUser, // Show avatar if first in chain
                );
              },
            ),
          ),
          _buildInputArea(),
        ],
      ),
    );
  }

  Widget _buildMessage(String text, String time, bool isUser, bool showAvatar) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        mainAxisAlignment: isUser
            ? MainAxisAlignment.end
            : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (!isUser) ...[
            if (showAvatar)
              CircleAvatar(
                backgroundColor: Colors.transparent,
                radius: 20,
                child: Image.asset("assets/robot.png"),
              )
            else
              const SizedBox(width: 40),
            const SizedBox(width: 12),
          ],
          Flexible(
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: isUser ? AppColors.primary : Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 5,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: isUser
                    ? CrossAxisAlignment.end
                    : CrossAxisAlignment.start,
                children: [
                  Text(
                    text,
                    style: TextStyle(
                      color: isUser ? Colors.white : Colors.black87,
                      fontSize: 15,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    time,
                    style: TextStyle(
                      color: isUser ? Colors.white70 : Colors.grey[400],
                      fontSize: 10,
                    ),
                  ),
                ],
              ),
            ),
          ),
          if (isUser) const SizedBox(width: 16), // Padding right for user
        ],
      ),
    );
  }

  Widget _buildInputArea() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: const BoxDecoration(color: Colors.white),
      child: Row(
        children: [
          Expanded(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                color: const Color(0xFFF5F7FA),
                borderRadius: BorderRadius.circular(12),
              ),
              child: TextField(
                controller: _controller,
                onSubmitted: (_) => _sendMessage(),
                decoration: const InputDecoration(
                  hintText: "Ask me anything ...",
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.symmetric(vertical: 12),
                ),
              ),
            ),
          ),
          const SizedBox(width: 8),
          Container(
            decoration: const BoxDecoration(
              color: AppColors.primary,
              shape: BoxShape.circle,
            ),
            child: IconButton(
              icon: SvgPicture.asset("assets/sendico.svg", color: Colors.white),
              onPressed: _sendMessage,
            ),
          ),
        ],
      ),
    );
  }
}
