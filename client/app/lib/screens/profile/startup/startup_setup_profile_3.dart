import 'dart:async';
import 'package:InvestorConnect/widgets/forms/custom_dropdown_text_field.dart';
import 'package:InvestorConnect/widgets/buttons/custom_buttons.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:InvestorConnect/services/api_service.dart';
import 'package:InvestorConnect/models/startup_profile.dart';

class StartupPreferencesScreen extends StatefulWidget {
  const StartupPreferencesScreen({Key? key}) : super(key: key);

  @override
  _StartupPreferencesScreenState createState() => _StartupPreferencesScreenState();
}

class _StartupPreferencesScreenState extends State<StartupPreferencesScreen> {
  final ScrollController _scrollController = ScrollController();
  StartupProfileModel? startupData;
  String buttonText = 'Complete Setup';
  double minInvestmentAmount = 0;
  double maxInvestmentAmount = 500000;
  List<String> selectedLocations = [];

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    startupData = ModalRoute.of(context)?.settings.arguments as StartupProfileModel;
  }

  void handleFormSubmit() async {
  if (selectedLocations.isNotEmpty) {
    startupData?.minInvestmentAmount = minInvestmentAmount.toInt();
    startupData?.maxInvestmentAmount = maxInvestmentAmount.toInt();
    startupData?.preferredLocations = selectedLocations;

    setState(() {
      buttonText = 'Loading...';
    });

    final data = await ApiService.createStartupProfile(startupData!);

    setState(() {
      if (data['status'] == 'success') {
        buttonText = 'Success!';
      } else if (data.containsKey('message')){
        buttonText = data['message'];
      } else {
        buttonText = 'Oops! Something Went Wrong. Please Retry.';
      }
    });

    Timer(const Duration(seconds: 2), () {
      if (data['status'] == 'success') {
        Navigator.of(context).pushNamedAndRemoveUntil('/home', (route) => false);
      } else {
        setState(() {
          buttonText = 'Complete Setup';
        });
      }
    });
  } else {
    setState(() {
      buttonText = 'Please fill in all fields';
    });

    Timer(const Duration(seconds: 2), () {
      setState(() {
        buttonText = 'Complete Setup';
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
            '3/3',
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
              const SizedBox(height: 18),
              Container(
                width: double.infinity,
                child: const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'What are your preferences?',
                      style: TextStyle(
                        fontSize: 27,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                    SizedBox(height: 10),
                    Text(
                      'Please select your preferences below.',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 17,
                        color: Colors.black,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 50),
              const Text(
                'How much investment are you looking for?',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 17,
                  color: Colors.black,
                ),
              ),
              RangeSlider(
                values: RangeValues(minInvestmentAmount, maxInvestmentAmount),
                divisions: 100,
                labels: RangeLabels(
                  "\$${(minInvestmentAmount / 1000).toStringAsFixed(0)}K",
                  "\$${(maxInvestmentAmount / 1000).toStringAsFixed(0)}K",
                ),
                min: 0,
                max: 500000,
                onChanged: (values) {
                  setState(() {
                    minInvestmentAmount = values.start;
                    maxInvestmentAmount = values.end;
                  });
                },
                activeColor: Theme.of(context).primaryColor,
                inactiveColor: Colors.grey[300],
              ),
              const SizedBox(height: 20),
              CustomDropdownTextField(
                label: 'What locations are you interested in?',
                options: DropdownOptions.locations,
                multipleSelection: true,
                onSelectionChanged: (selectedOptions) {
                  selectedLocations = selectedOptions;
                },
              ),
              const SizedBox(height: 30),
              const Text(
                'Your preferences will be used to match you with the right investors.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 17,
                  color: Colors.black,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 40),
              CustomButton(text: buttonText, onPressed: handleFormSubmit)
            ],
          ),
        ),
      ),
    );
  }
}
