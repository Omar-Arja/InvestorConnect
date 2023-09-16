import 'package:flutter/material.dart';

class CustomDropdownTextField extends StatefulWidget {
  final String label;
  final List<String> options;
  final bool multipleSelection;
  final Function(List<String>) onSelectionChanged;

  const CustomDropdownTextField({super.key,
    required this.label,
    required this.options,
    this.multipleSelection = false,
    required this.onSelectionChanged,
  });

  @override
  _CustomDropdownTextFieldState createState() =>
      _CustomDropdownTextFieldState();
}

class _CustomDropdownTextFieldState extends State<CustomDropdownTextField> {
  final TextEditingController _textEditingController = TextEditingController();
  bool _isDropdownOpen = false;
  List<String> _selectedOptions = [];
  List<String> _filteredOptions = [];

  @override
  void initState() {
    super.initState();
    _textEditingController.addListener(_onTextChanged);
    _filteredOptions = widget.options;
  }

  @override
  void dispose() {
    _textEditingController.dispose();
    super.dispose();
  }

  void _onTextChanged() {
    final searchText = _textEditingController.text.toLowerCase();
    setState(() {
      _filteredOptions = widget.options
          .where((option) => option.toLowerCase().contains(searchText))
          .toList();
    });
  }

  void _toggleDropdown() {
    setState(() {
      _isDropdownOpen = !_isDropdownOpen;
    });
  }

  void _selectOption(String option) {
    if (widget.multipleSelection) {
      setState(() {
        if (_selectedOptions.contains(option)) {
          _selectedOptions.remove(option);
        } else {
          _selectedOptions.add(option);
        }
        _textEditingController.clear();
        widget.onSelectionChanged(_selectedOptions);
      });
    } else {
      setState(() {
        _selectedOptions = [option];
        _isDropdownOpen = false;
        _textEditingController.text = option;
        widget.onSelectionChanged(_selectedOptions);
      });
    }
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
          controller: _textEditingController,
          decoration: InputDecoration(
            suffixIcon: Icon(
              _isDropdownOpen ? Icons.arrow_drop_up : Icons.arrow_drop_down,
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(6),
              borderSide: const BorderSide(
                color: Color(0xFF3D4E81),
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(6),
              borderSide: const BorderSide(
                color: Color(0xFF3B82F6),
              ),
            ),
            filled: true,
            fillColor: Colors.white,
          ),
          onTap: _toggleDropdown,
        ),
        if (_isDropdownOpen)
          Container(
            height: _filteredOptions.length * 56.0,
            constraints: const BoxConstraints(
              maxHeight: 160,
            ),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(6),
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFF4C68AF).withOpacity(0.2),
                  blurRadius: 5,
                  offset: const Offset(0, 5),
                ),
              ],
            ),
            child: ListView.builder(
              itemCount: _filteredOptions.length,
              itemBuilder: (context, index) {
                final option = _filteredOptions[index];
                final isSelected = _selectedOptions.contains(option);
                return ListTile(
                  title: Text(option),
                  trailing: isSelected
                      ? const Icon(Icons.check_circle, color: Color(0xFF4C68AF))
                      : null,
                  onTap: () => _selectOption(option),
                );
              },
            ),
          ),
        if (widget.multipleSelection && _selectedOptions.isNotEmpty)
          Wrap(
            spacing: 4,
            children: _selectedOptions
                .map(
                  (option) => Chip(
                    side: const BorderSide(
                      color: Color.fromARGB(60, 77, 77, 77),
                    ),
                    elevation: 1,
                    label: Text(
                      option,
                      style: const TextStyle(
                        color: Colors.black,
                      ),
                    ),
                    onDeleted: () {
                      setState(() {
                        _selectedOptions.remove(option);
                        widget.onSelectionChanged(_selectedOptions);
                      });
                    },
                    backgroundColor: Colors.white,
                    deleteIconColor: const Color.fromARGB(255, 77, 77, 77),
                  ),
                )
                .toList(),
          ),
      ],
    );
  }
}
