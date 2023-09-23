import 'dart:async';
import 'package:client/widgets/custom_dropdown_text_field.dart';
import 'package:client/widgets/custom_buttons.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:client/services/api_service.dart';
import 'package:client/models/investor_profile.dart';

class InvestorPreferencesScreen extends StatefulWidget {
  const InvestorPreferencesScreen({Key? key}) : super(key: key);

  @override
  _InvestorPreferencesScreenState createState() => _InvestorPreferencesScreenState();
}

class _InvestorPreferencesScreenState extends State<InvestorPreferencesScreen> {
  final ScrollController _scrollController = ScrollController();
  InvestorProfileModel? investorData;
  String buttonText = 'Complete Setup';
  List<String> selectedIndustries = [];
  List<String> selectedLocations = [];
  List<String> selectedInvestmentStages = [];
  double minInvestmentAmount = 0;
  double maxInvestmentAmount = 500000;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    investorData = ModalRoute.of(context)?.settings.arguments as InvestorProfileModel;
  }

  void handleFormSubmit() async {
    if (selectedIndustries.isNotEmpty &&
        selectedLocations.isNotEmpty &&
        selectedInvestmentStages.isNotEmpty) {
      investorData?.minInvestmentAmount = minInvestmentAmount.toInt();
      investorData?.maxInvestmentAmount = maxInvestmentAmount.toInt();
      investorData?.preferredIndustries = selectedIndustries;
      investorData?.preferredLocations = selectedLocations;
      investorData?.preferredInvestmentStages = selectedInvestmentStages;

      setState(() {
        buttonText = 'Loading...';
      });

      final data = await ApiService.createInvestorProfile(investorData!);

      setState(() {
        if (data['status'] == 'success') {
          buttonText = 'Success!';
        } else if (data.containsKey('message')) {
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
              '2/2',
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
                        'What are your investment preferences?',
                        style: TextStyle(
                          fontSize: 27,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                      SizedBox(height: 10),
                      Text(
                        'Customize your investment criteria for a personalized experience.',
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
                  'How much are you looking to invest?',
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
                  label: 'Where are you looking to invest?',
                  options: DropdownOptions.locations,
                  multipleSelection: true,
                  onSelectionChanged: (selectedOptions) {
                    selectedLocations = selectedOptions;
                  },
                ),
                const SizedBox(height: 20),
                CustomDropdownTextField(
                  label: 'Which industries are you interested in?',
                  options: DropdownOptions.industries,
                  multipleSelection: true,
                  onSelectionChanged: (selectedOptions) {
                    selectedIndustries = selectedOptions;
                  },
                ),
                const SizedBox(height: 20),
                CustomDropdownTextField(
                  label: 'What investment stages are you interested in?',
                  options: DropdownOptions.investmentStages,
                  multipleSelection: true,
                  onSelectionChanged: (selectedOptions) {
                    selectedInvestmentStages = selectedOptions;
                  },
                ),
                const SizedBox(height: 20),
                CustomButton(text: buttonText, onPressed: handleFormSubmit)
              ],
            ),
          ),
        ),
      ),
    );
  }
}
