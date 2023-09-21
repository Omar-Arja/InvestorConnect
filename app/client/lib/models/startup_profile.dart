import 'dart:io';

class StartupProfileModel {
  String companyName;
  String location;
  List<String> industries;
  String investmentStage;
  String companyLogoUrl;
  File? logoFile;
  String companyDescription;
  String pitchVideoUrl;
  File? pitchVideoFile;
  List<String> preferredLocations;
  int minInvestmentAmount;
  int maxInvestmentAmount;

  StartupProfileModel({
    this.companyName = '',
    this.location = '',
    this.industries = const [],
    this.investmentStage = '',
    this.companyLogoUrl = '',
    this.logoFile,
    this.companyDescription = '',
    this.pitchVideoUrl = '',
    this.pitchVideoFile,
    this.preferredLocations = const [],
    this.minInvestmentAmount = 0,
    this.maxInvestmentAmount = 0,
  });

  factory StartupProfileModel.fromJson(Map<String, dynamic> json) {
    return StartupProfileModel(
      companyName: json['company_name'] ?? '',
      location: json['location'] ?? '',
      industries: List<String>.from(json['industries'] ?? []),
      companyLogoUrl: json['company_logo_url'] ?? '',
      investmentStage: json['investment_stage'] ?? '',
      companyDescription: json['company_description'] ?? '',
      pitchVideoUrl: json['pitch_video_url'] ?? '',
      preferredLocations: List<String>.from(json['preferred_locations'] ?? []),
      minInvestmentAmount: json['min_investment_amount'] ?? 0.0,
      maxInvestmentAmount: json['max_investment_amount'] ?? 0.0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'company_name': companyName,
      'location': location,
      'industries': industries,
      'investment_stage': investmentStage,
      'logo_file': logoFile,
      'company_description': companyDescription,
      'pitch_video_file': pitchVideoFile,
      'preferred_locations': preferredLocations,
      'min_investment_amount': minInvestmentAmount,
      'max_investment_amount': maxInvestmentAmount,
    };
  }
}
