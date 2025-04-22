import 'package:flutter/material.dart';

class ChatInputField extends StatefulWidget {
  final Function(String) onSendMessage;
  final bool isLoading;

  const ChatInputField({
    super.key,
    required this.onSendMessage,
    this.isLoading = false,
  });

  @override
  State<ChatInputField> createState() => _ChatInputFieldState();
}

class _ChatInputFieldState extends State<ChatInputField> {
  final TextEditingController _textController = TextEditingController();
  final FocusNode _focusNode = FocusNode(); // To manage focus

  void _handleSend() {
    if (_textController.text.trim().isNotEmpty && !widget.isLoading) {
      widget.onSendMessage(_textController.text.trim());
      _textController.clear();
      _focusNode.requestFocus(); // Keep focus after sending for quick typing
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface, // Use surface color from theme
        boxShadow: [
          BoxShadow(
            offset: const Offset(0, -1),
            blurRadius: 4,
            color: Colors.black.withOpacity(0.05),
          ),
        ],
      ),
      child: SafeArea(
        // Prevent overlap with system UI (like home bar)
        child: Row(
          children: [
            Expanded(
              child: TextField(
                controller: _textController,
                focusNode: _focusNode,
                textCapitalization: TextCapitalization.sentences,
                autocorrect: true,
                enableSuggestions: true,
                decoration: InputDecoration(
                  hintText: 'Type a message...',
                  filled: true,
                  fillColor: theme.colorScheme.surfaceVariant
                      .withOpacity(0.5), // Slightly different background
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(25.0),
                    borderSide: BorderSide.none, // No visible border line
                  ),
                  contentPadding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                ),
                onSubmitted: widget.isLoading
                    ? null
                    : (_) => _handleSend(), // Send on keyboard 'done'
                enabled: !widget.isLoading, // Disable field when loading
              ),
            ),
            const SizedBox(width: 8.0),
            IconButton(
              icon: Icon(
                Icons.send_rounded,
                color: widget.isLoading || _textController.text.trim().isEmpty
                    ? theme.colorScheme.onSurface
                        .withOpacity(0.4) // Dimmed color when disabled
                    : theme.colorScheme.primary,
              ),
              onPressed: widget.isLoading ? null : _handleSend,
              tooltip: 'Send message',
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _textController.dispose();
    _focusNode.dispose();
    super.dispose();
  }
}
