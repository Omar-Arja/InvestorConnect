import 'dart:io';

class StartupProfileModel {
  String fullName;
  String companyName;
  String calendlyLink;
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
    this.fullName = '',
    this.companyName = '',
    this.calendlyLink = '',
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
      fullName: json['full_name'] ?? '',
      companyName: json['company_name'] ?? '',
      calendlyLink: json['calendly_link'] ?? '',
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
      'full_name': fullName,
      'company_name': companyName,
      'calendly_link': calendlyLink,
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
