import 'package:flutter/material.dart';

// ignore: must_be_immutable
class InputField extends StatefulWidget {
  final String label;
  final IconData? icon;
  final String? hint;
  final bool isPassword;
  final String? initialText;

  String inputValue = '';

  InputField({
    required this.label,
    this.icon,
    this.hint,
    this.isPassword = false,
    this.initialText,
    Key? key,
  }) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _InputFieldState createState() => _InputFieldState();

}

class _InputFieldState extends State<InputField> {
  final controller = TextEditingController();
  bool obscureText = true;

  @override
  void initState() {
    super.initState();
    controller.text = widget.initialText ?? '';
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widget.label,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 10),
        TextFormField(
          textAlignVertical: TextAlignVertical.center,
          controller: controller,
          onChanged: (text) {
            widget.inputValue = text;
          },
          decoration: InputDecoration(
            alignLabelWithHint: true,
            hintText: widget.hint,
            hintStyle: const TextStyle(
              fontSize: 16,
              color: Color.fromARGB(255, 96, 96, 96),
            ),
            prefixIcon: widget.icon != null
              ? Icon(
                  widget.icon,
                  color: const Color.fromARGB(255, 96, 96, 96),
                )
              : null,
            suffixIcon: widget.isPassword
                ? IconButton(
                    onPressed: () {
                      setState(() {
                        obscureText = !obscureText;
                      });
                    },
                    icon: Icon(
                      !obscureText ? Icons.visibility : Icons.visibility_off,
                      color: const Color.fromARGB(255, 96, 96, 96),
                    ),
                  )
                : null,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(6),
              borderSide: const BorderSide(
                color: Color.fromARGB(255, 96, 96, 96),
              ),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(6),
              borderSide: const BorderSide(
                color: Color.fromARGB(255, 96, 96, 96),
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(6),
              borderSide: BorderSide(
                color: Theme.of(context).primaryColor,
              ),
            ),
          ),
          obscureText: widget.isPassword ? obscureText : false,
          style: const TextStyle(
            fontSize: 17,
            fontWeight: FontWeight.w500,
            color: Color.fromARGB(255, 10, 10, 10),
          ),
        ),
      ],
    );
  }
  
}
