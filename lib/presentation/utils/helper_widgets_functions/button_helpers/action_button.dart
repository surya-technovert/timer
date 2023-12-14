import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ActionButton extends ConsumerStatefulWidget {
  final VoidCallback onPressed;
  final String buttonText;
  const ActionButton(
      {super.key, required this.onPressed, required this.buttonText});

  @override
  ConsumerState<ActionButton> createState() => _ActionButtonState();
}

class _ActionButtonState extends ConsumerState<ActionButton> {
  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
        onPressed: widget.onPressed,
        child: Text(widget.buttonText,
            style: const TextStyle(
                fontFamily: 'Crimson', fontWeight: FontWeight.bold)));
  }
}
