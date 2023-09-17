import 'dart:io';

class StartupProfileModel {
  String companyName;
  String location;
  List<String> industries;
  String investmentStage;
  String imageFilePath;
  File? imageFile;
  String shortDescription;
  String pitchVideoPath;
  File? pitchVideoFile;
  List<String> selectedLocations;
  double minInvestmentAmount;
  double maxInvestmentAmount;

  StartupProfileModel({
    this.companyName = '',
    this.location = '',
    this.industries = const [],
    this.investmentStage = '',
    this.imageFilePath = '',
    this.imageFile,
    this.shortDescription = '',
    this.pitchVideoPath = '',
    this.pitchVideoFile,
    this.selectedLocations = const [],
    this.minInvestmentAmount = 0,
    this.maxInvestmentAmount = 0,
  });

  factory StartupProfileModel.fromJson(Map<String, dynamic> json) {
    return StartupProfileModel(
      companyName: json['companyName'] ?? '',
      location: json['location'] ?? '',
      industries: List<String>.from(json['industries'] ?? []),
      imageFilePath: json['imageFilePath'] ?? '',
      imageFile: json['imageFile'],
      investmentStage: json['investmentStage'] ?? '',
      shortDescription: json['shortDescription'] ?? '',
      pitchVideoPath: json['pitchVideoPath'] ?? '',
      selectedLocations: List<String>.from(json['selectedLocations'] ?? []),
      minInvestmentAmount: json['minInvestmentAmount'] ?? 0.0,
      maxInvestmentAmount: json['maxInvestmentAmount'] ?? 0.0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'companyName': companyName,
      'location': location,
      'industries': industries,
      'investmentStage': investmentStage,
      'imageFile': imageFile,
      'shortDescription': shortDescription,
      'pitchVideoFile': pitchVideoFile,
      'selectedLocations': selectedLocations,
      'minInvestmentAmount': minInvestmentAmount,
      'maxInvestmentAmount': maxInvestmentAmount,
    };
  }
}
