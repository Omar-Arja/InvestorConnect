import 'package:flutter/material.dart';

class CustomDropdownTextField extends StatefulWidget {
  final dynamic label;
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
  _CustomDropdownTextFieldState createState() => _CustomDropdownTextFieldState();
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
      _filteredOptions = widget.options.where((option) => option.toLowerCase().contains(searchText)).toList();
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
          controller: _textEditingController,
          decoration: InputDecoration(
            suffixIcon: Icon(
              _isDropdownOpen ? Icons.arrow_drop_up : Icons.arrow_drop_down,
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(6),
              borderSide: const BorderSide(
                color: Color.fromARGB(255, 96, 96, 96),
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

class DropdownOptions {
  static final List<String> locations = [
    'Afghanistan',
    'Albania',
    'Algeria',
    'Andorra',
    'Angola',
    'Antigua and Barbuda',
    'Argentina',
    'Armenia',
    'Australia',
    'Austria',
    'Azerbaijan',
    'Bahamas',
    'Bahrain',
    'Bangladesh',
    'Barbados',
    'Belarus',
    'Belgium',
    'Belize',
    'Benin',
    'Bhutan',
    'Bolivia',
    'Bosnia and Herzegovina',
    'Botswana',
    'Brazil',
    'Brunei',
    'Bulgaria',
    'Burkina Faso',
    'Burundi',
    'Cabo Verde',
    'Cambodia',
    'Cameroon',
    'Canada',
    'Central African Republic',
    'Chad',
    'Chile',
    'China',
    'Colombia',
    'Comoros',
    'Congo (Brazzaville)',
    'Congo (Kinshasa)',
    'Costa Rica',
    'Croatia',
    'Cuba',
    'Cyprus',
    'Czech Republic',
    'Denmark',
    'Djibouti',
    'Dominica',
    'Dominican Republic',
    'East Timor',
    'Ecuador',
    'Egypt',
    'El Salvador',
    'Equatorial Guinea',
    'Eritrea',
    'Estonia',
    'Eswatini',
    'Ethiopia',
    'Fiji',
    'Finland',
    'France',
    'Gabon',
    'Gambia',
    'Georgia',
    'Germany',
    'Ghana',
    'Greece',
    'Grenada',
    'Guatemala',
    'Guinea',
    'Guinea-Bissau',
    'Guyana',
    'Haiti',
    'Honduras',
    'Hungary',
    'Iceland',
    'India',
    'Indonesia',
    'Iran',
    'Iraq',
    'Ireland',
    'Israel',
    'Italy',
    'Ivory Coast',
    'Jamaica',
    'Japan',
    'Jordan',
    'Kazakhstan',
    'Kenya',
    'Kiribati',
    'Korea, North',
    'Korea, South',
    'Kosovo',
    'Kuwait',
    'Kyrgyzstan',
    'Laos',
    'Latvia',
    'Lebanon',
    'Lesotho',
    'Liberia',
    'Libya',
    'Liechtenstein',
    'Lithuania',
    'Luxembourg',
    'Macedonia',
    'Madagascar',
    'Malawi',
    'Malaysia',
    'Maldives',
    'Mali',
    'Malta',
    'Marshall Islands',
    'Mauritania',
    'Mauritius',
    'Mexico',
    'Micronesia',
    'Moldova',
    'Monaco',
    'Mongolia',
    'Montenegro',
    'Morocco',
    'Mozambique',
    'Myanmar',
    'Namibia',
    'Nauru',
    'Nepal',
    'Netherlands',
    'New Zealand',
    'Nicaragua',
    'Niger',
    'Nigeria',
    'Norway',
    'Oman',
    'Pakistan',
    'Palau',
    'Panama',
    'Papua New Guinea',
    'Paraguay',
    'Peru',
    'Philippines',
    'Poland',
    'Portugal',
    'Qatar',
    'Romania',
    'Russia',
    'Rwanda',
    'Saint Kitts and Nevis',
    'Saint Lucia',
    'Saint Vincent and The Grenadines',
    'Samoa',
    'San Marino',
    'Sao Tome and Principe',
    'Saudi Arabia',
    'Senegal',
    'Serbia',
    'Seychelles',
    'Sierra Leone',
    'Singapore',
    'Slovakia',
    'Slovenia',
    'Solomon Islands',
    'Somalia',
    'South Africa',
    'South Sudan',
    'Spain',
    'Sri Lanka',
    'Sudan',
    'Suriname',
    'Sweden',
    'Switzerland',
    'Syria',
    'Taiwan',
    'Tajikistan',
    'Tanzania',
    'Thailand',
    'Togo',
    'Tonga',
    'Trinidad and Tobago',
    'Tunisia',
    'Turkey',
    'Turkmenistan',
    'Tuvalu',
    'Uganda',
    'Ukraine',
    'United Arab Emirates',
    'United Kingdom',
    'United States',
    'Uruguay',
    'Uzbekistan',
    'Vanuatu',
    'Vatican City',
    'Venezuela',
    'Vietnam',
    'Yemen',
    'Zambia',
    'Zimbabwe',
  ];

  static final List<String> industries = [
    'Agriculture',
    'Automotive',
    'Construction',
    'Education',
    'Energy',
    'Entertainment',
    'Finance',
    'Healthcare',
    'Information Technology',
    'Manufacturing',
    'Media',
    'Real Estate',
    'Retail',
    'Technology',
    'Telecommunications',
    'Transportation',
    'Travel',
  ];

  static final List<String> investmentStages = [
    'Pre-Seed',
    'Seed',
    'Series A',
    'Series B',
    'Series C',
    'Series D+',
    'IPO',
    'Acquisition',
  ];
}