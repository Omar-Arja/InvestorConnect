import 'package:flutter/material.dart';

class InputField extends StatefulWidget {
  final dynamic label;
  final IconData? icon;
  final String? hint;
  final int? maxLines;
  final int? maxCharacterCount;
  final bool isPassword;
  final String? initialText;
  final Function onInputChanged;

  const InputField({
    required this.label,
    this.icon,
    this.hint,
    this.maxLines,
    this.maxCharacterCount,
    this.isPassword = false,
    this.initialText,
    required this.onInputChanged,
    Key? key,
  }) : super(key: key);

  @override
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
        widget.label is Text
            ? widget.label
            : Text(
                widget.label,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: Color.fromARGB(255, 20, 20, 20),
                ),
              ),
        const SizedBox(height: 10),
        TextFormField(
          maxLines: widget.maxLines ?? 1,
          maxLength: widget.maxCharacterCount,
          textAlignVertical: TextAlignVertical.center,
          controller: controller,
          onChanged: (value) {
            widget.onInputChanged(value);
          },
          decoration: InputDecoration(
            contentPadding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
            alignLabelWithHint: true,
            hintText: widget.hint,
            hintStyle: const TextStyle(
              fontSize: 16,
              color: Color.fromARGB(255, 117, 117, 117),
            ),
            prefixIcon: widget.icon != null
              ? Icon(
                  widget.icon,
                  color: const Color.fromARGB(255, 117, 117, 117),
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
                      color: const Color.fromARGB(255, 117, 117, 117),
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
