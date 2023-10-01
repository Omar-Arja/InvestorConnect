import 'dart:io';

class StartupProfileModel {
  int? userId;
  String fullName;
  String companyName;
  String calendlyLink;
  String location;
  List<String> industries;
  String investmentStage;
  String companyLogoUrl;
  File? logoFile;
  String companyDescription;
  String aiAnalysis;
  String pitchVideoUrl;
  File? pitchVideoFile;
  List<String> preferredLocations;
  int minInvestmentAmount;
  int maxInvestmentAmount;

  StartupProfileModel({
    this.userId,
    this.fullName = '',
    this.companyName = '',
    this.calendlyLink = '',
    this.location = '',
    this.industries = const [],
    this.investmentStage = '',
    this.companyLogoUrl = '',
    this.logoFile,
    this.companyDescription = '',
    this.aiAnalysis = '',
    this.pitchVideoUrl = '',
    this.pitchVideoFile,
    this.preferredLocations = const [],
    this.minInvestmentAmount = 0,
    this.maxInvestmentAmount = 0,
  });

  factory StartupProfileModel.fromJson(Map<String, dynamic> json) {
  final industriesList = json['industries'];
  List<String> industries = [];

  if (industriesList != null && industriesList is List<dynamic>) {
    industries = List<String>.from(industriesList.map((e) => e.toString()));
  }

  return StartupProfileModel(
    userId: json['user_id'],
    fullName: json['full_name'] ?? '',
    companyName: json['company_name'] ?? '',
    calendlyLink: json['calendly_link'] ?? '',
    location: json['location'] ?? '',
    industries: industries,
    companyLogoUrl: json['company_logo_url'] ?? '',
    investmentStage: json['investment_stage'] ?? '',
    companyDescription: json['company_description'] ?? '',
    aiAnalysis: json['ai_analysis'] ?? '',
    pitchVideoUrl: json['pitch_video_url'] ?? '',
    preferredLocations: List<String>.from(json['preferred_locations'] ?? []),
    minInvestmentAmount: json['min_investment_amount'] ?? 0,
    maxInvestmentAmount: json['max_investment_amount'] ?? 0,
  );
}


  Map<String, dynamic> toJson() {
    return {
      'user_id': userId,
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
