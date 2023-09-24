import 'dart:async';
import 'package:client/widgets/forms/input_fields.dart';
import 'package:client/widgets/forms/custom_dropdown_text_field.dart';
import 'package:client/widgets/buttons/custom_buttons.dart';
import 'package:client/models/investor_profile.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class InvestorSetupProfileScreen extends StatefulWidget {
  const InvestorSetupProfileScreen({super.key});

  @override
  _InvestorSetupProfileScreenState createState() => _InvestorSetupProfileScreenState();
}

class _InvestorSetupProfileScreenState extends State<InvestorSetupProfileScreen> {
  final ScrollController _scrollController = ScrollController();
  String buttonText = 'Continue';
  XFile? _selectedImage;
  File imageFile = File('');
  String location = '';
  String bio = '';
  String calendlyLink = '';

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
    if (location.isNotEmpty && bio.isNotEmpty && _selectedImage != null) {
      final investorData = InvestorProfileModel(
        profilePictureFile: imageFile,
        calendlyLink: calendlyLink,
        location: location,
        bio: bio.trim(),
      );

      Navigator.of(context).pushNamed('/investor_setup_profile_2', arguments: investorData);
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
    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: Colors.white,
      appBar: AppBar(
        systemOverlayStyle: const SystemUiOverlayStyle(
          statusBarColor: Colors.transparent,
          statusBarIconBrightness: Brightness.dark,
        ),
        title: Container(
          width: double.infinity,
          padding: const EdgeInsets.only(right: 25),
          child: const Text(
            '1/2',
            textAlign: TextAlign.end,
            style: TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.w500,
              fontSize: 18,
            ),
          ),
        ),
        backgroundColor: Colors.transparent,
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
                radius: 66,
                child: Stack(
                  alignment: Alignment.bottomRight,
                  children: [
                    if (_selectedImage != null)
                      CircleAvatar(
                        radius: 66,
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
                                'Upload Profile Picture',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 12,
                                ),
                              )
                            : const SizedBox(),
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
                      'Tell us about yourself',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      'Please provide some information',
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
                label: 'What is your Calendly link? (Optional - for meetings)',
                onInputChanged: (value) {
                  calendlyLink = value;
                },
              ),
              const SizedBox(height: 16),
              CustomDropdownTextField(
                label: 'Where are you located?',
                options: DropdownOptions.locations,
                onSelectionChanged: (selectedOptions) {
                  location = selectedOptions[0];
                },
              ),
              const SizedBox(height: 16),
              InputField(
                label: 'Tell us about yourself (Bio)',
                maxCharacterCount: 260,
                maxLines: 5,
                onInputChanged: (value) {
                  bio = value;
                },
              ),
              const SizedBox(height: 12),
              const Text(
                "Share your profile to find the best matches! Your information will help startups discover you.",
                style: TextStyle(
                  fontSize: 15,
                  color: Colors.grey,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),
              CustomButton(text: buttonText, onPressed: handleFormSubmit),
            ],
          ),
        ),
      ),
    );
  }
}
