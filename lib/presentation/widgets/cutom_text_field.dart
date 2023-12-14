import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:Reminder/presentation/utils/extensions/context_extensions.dart';

class CustomInputField extends ConsumerStatefulWidget {
  final TextEditingController fieldController;
  final IconData icon;
  final String hintText;
  final String errorText;
  final bool readOnly;
  final VoidCallback? onTap;
  final int? maxLines;
  final TextInputType? keyboardType;
  final List<TextInputFormatter>? inputParameters;

  const CustomInputField({
    super.key,
    required this.fieldController,
    required this.hintText,
    required this.errorText,
    required this.icon,
    this.readOnly = false,
    this.onTap,
    this.maxLines,
    this.keyboardType,
    this.inputParameters,
  });

  @override
  ConsumerState<CustomInputField> createState() => _CustomInputFieldState();
}

class _CustomInputFieldState extends ConsumerState<CustomInputField> {
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      validator: (value) {
        if (value == '') {
          return widget.errorText;
        }
        return null;
      },
      maxLines: widget.maxLines,
      inputFormatters: widget.inputParameters,
      keyboardType: widget.keyboardType,
      readOnly: widget.readOnly,
      onTap: widget.onTap,
      controller: widget.fieldController,
      style: const TextStyle(fontSize: 14),
      decoration: InputDecoration(
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 20,
          vertical: 20,
        ),
        hintText: widget.hintText,
        hintStyle: const TextStyle(
            fontSize: 14, fontFamily: 'Crimson', fontWeight: FontWeight.bold),
        icon: Icon(widget.icon, color: context.primartyColor),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
        ),
      ),
    );
  }
}
