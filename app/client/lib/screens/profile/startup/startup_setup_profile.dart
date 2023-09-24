import 'dart:async';
import 'package:client/widgets/forms/input_fields.dart';
import 'package:client/widgets/forms/custom_dropdown_text_field.dart';
import 'package:client/widgets/buttons/custom_buttons.dart';
import 'package:client/models/startup_profile.dart';
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
  String companyNameInputValue = '';
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

  void handleFormSubmit() {
    if (companyNameInputValue.isNotEmpty &&
        location.isNotEmpty &&
        industries.isNotEmpty &&
        investmentStage.isNotEmpty &&
        _selectedImage != null) {
      final startupData = StartupProfileModel(
        companyName: companyNameInputValue,
        location: location,
        industries: industries,
        investmentStage: investmentStage,
        logoFile: imageFile,
      );

      Navigator.of(context).pushNamed('/startup_setup_profile_2', arguments: startupData);
    } else {
      setState(() {
        buttonText = 'Please fill in all fields';
      });
      Timer(const Duration(seconds: 2), () {
        setState(() {
          buttonText = 'Continue';
        });
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
          title: Container(
            width: double.infinity,
            padding: const EdgeInsets.only(right: 25),
            child: const Text(
              '1/3',
              textAlign: TextAlign.end,
              style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.w500,
                fontSize: 18,
              ),
            ),
          ),
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
                      Column(
                        mainAxisAlignment: _selectedImage != null
                            ? MainAxisAlignment.end
                            : MainAxisAlignment.center,
                        children: [
                          IconButton(
                            icon: const Icon(
                              Icons.add_a_photo,
                              color: Colors.white,
                            ),
                            onPressed: _pickImage,
                          ),
                          _selectedImage == null
                              ? const Text(
                            'Upload Logo',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                            ),
                          ) : const SizedBox(),
                        ],
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
                InputField(
                  label: "What's your company's name?",
                  onInputChanged: (value) {
                    companyNameInputValue = value;
                  },
                ),
                const SizedBox(height: 16),
                CustomDropdownTextField(
                  label: 'Where is your company located?',
                  options: DropdownOptions.locations,
                  onSelectionChanged: (selectedOptions) {
                    location = selectedOptions[0];
                  },
                ),
                const SizedBox(height: 16),
                CustomDropdownTextField(
                  label: 'Which industries are you in?',
                  options: DropdownOptions.industries,
                  multipleSelection: true,
                  onSelectionChanged: (selectedOptions) {
                    industries = selectedOptions;
                  },
                ),
                const SizedBox(height: 16),
                CustomDropdownTextField(
                  label: 'What investment stage are you at?',
                  options: DropdownOptions.investmentStages,
                  onSelectionChanged: (selectedOptions) {
                    investmentStage = selectedOptions[0];
                  },
                ),
                const SizedBox(height: 24),
                CustomButton(text: buttonText, onPressed: handleFormSubmit),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
