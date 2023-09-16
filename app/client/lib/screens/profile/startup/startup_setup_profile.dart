import 'package:client/widgets/input_fields.dart';
import 'package:client/widgets/custom_dropdown_text_field.dart';
import 'package:client/widgets/custom_buttons.dart';
import 'package:client/models/startup_data.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class StartupSetupProfileScreen extends StatefulWidget {
  const StartupSetupProfileScreen({super.key});

  @override
  _StartupSetupProfileScreenState createState() => _StartupSetupProfileScreenState();
}

class _StartupSetupProfileScreenState extends State<StartupSetupProfileScreen> {
  final ScrollController _scrollController = ScrollController();
  String buttonText = 'Continue';
  XFile? _selectedImage;
  File imageFile = File('');
  String companyName = '';
  String location = '';
  String investmentStage = '';
  List<String> industries = [];

  Future _pickImage() async {
    final picker = ImagePicker();
    final selectedImage = await picker.pickImage(source: ImageSource.gallery);

    if (selectedImage != null) {
      imageFile = File(selectedImage.path);
      setState(() {
        _selectedImage = selectedImage;
      });
    }
  }

  final companyNameInput = InputField(
    label: "What's your company's name?",
  );

  void _handleFormSubmit() {
    companyName = companyNameInput.inputValue;
    if (companyName.isNotEmpty &&
        location.isNotEmpty &&
        industries.isNotEmpty &&
        investmentStage.isNotEmpty &&
        _selectedImage != null) {
      final startupData = StartupProfileModel(
        companyName: companyName,
        location: location,
        industries: industries,
        investmentStage: investmentStage,
        imageFile: imageFile,
      );
      Navigator.of(context).pushNamed(
        '/startup_setup_profile_2',
        arguments: startupData,
      );
    } else {
      setState(() {
        buttonText = 'Please fill in all fields';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion(
      value: const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.dark,
      ),
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          iconTheme: const IconThemeData(color: Colors.black),
          leading: IconButton(
            padding: const EdgeInsets.only(left: 25),
            icon: const Icon(Icons.arrow_back_ios),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ),
        body: SingleChildScrollView(
          controller: _scrollController,
          keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.fromLTRB(24, 0, 24, 15),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                CircleAvatar(
                  backgroundColor: Colors.grey,
                  radius: 64,
                  child: Stack(
                    alignment: Alignment.bottomRight,
                    children: [
                      if (_selectedImage != null)
                        CircleAvatar(
                          radius: 64,
                          backgroundImage: FileImage(File(_selectedImage!.path)),
                        ),
                      IconButton(
                        icon: const Icon(
                          Icons.add_a_photo,
                          color: Colors.white,
                        ),
                        onPressed: _pickImage,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                const SizedBox(
                  width: double.infinity,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Overview of your company',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      SizedBox(height: 8),
                      Text(
                        'Please fill in basic info',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                companyNameInput,
                const SizedBox(height: 16),
                CustomDropdownTextField(
                  label: 'Where is your company located?',
                  options: countryOptions,
                  onSelectionChanged: (selectedOptions) {
                    location = selectedOptions[0];
                    print('Locations: $location');
                  },
                ),
                const SizedBox(height: 16),
                CustomDropdownTextField(
                  label: 'Which industries are you in?',
                  options: industryOptions,
                  multipleSelection: true,
                  onSelectionChanged: (selectedOptions) {
                    industries = selectedOptions;
                    print('Industries: $industries');
                  },
                ),
                const SizedBox(height: 16),
                CustomDropdownTextField(
                  label: 'What investment stage are you at?',
                  options: investmentStageOptions,
                  onSelectionChanged: (selectedOptions) {
                    investmentStage = selectedOptions[0];
                    print('Investment Stage: $investmentStage');
                  },
                ),
                const SizedBox(height: 24),
                CustomButton(text: buttonText, onPressed: _handleFormSubmit),
              ],
            ),
          ),
        ),
      ),
    );
  }

  final List<String> countryOptions = [
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

  final List<String> industryOptions = [
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
    'Telecommunications',
    'Transportation',
    'Travel',
    'Technology',
  ];

  final List<String> investmentStageOptions = [
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
