import 'package:flutter/material.dart';

class InformationForm extends StatefulWidget {
  final String label;
  final IconData icon;
  final TextEditingController? controller;
  final Color? color;
  final bool readOnly;

  const InformationForm({
    super.key,
    required this.label,
    this.controller,
    this.color,
    required this.icon,
    required this.readOnly,
  });

  @override
  State<InformationForm> createState() => _InformationFormState();
}

class _InformationFormState extends State<InformationForm> {
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: widget.controller,
      readOnly: widget.readOnly,
      decoration: InputDecoration(
        // Label
        label: RichText(
          text: TextSpan(
            text: widget.label,
            style: TextStyle(color: Colors.grey.shade600, fontSize: 25),
            children: const [
              TextSpan(
                text: "*",
                style: TextStyle(
                  color: Colors.red,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
        contentPadding: const EdgeInsets.symmetric(
          vertical: 16,
          horizontal: 12,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey.shade300, width: 1),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(width: 1.5),
        ),

        // Icon
        prefixIcon: Icon(widget.icon, color: widget.color),
      ),

      style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
    );
  }
}
