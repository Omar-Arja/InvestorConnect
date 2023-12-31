import 'dart:io';

class InvestorProfileModel {
  int? userId;
  String fullName;
  String calendlyLink;
  String location;
  String bio;
  String aiAnalysis;
  String profilePictureUrl;
  File? profilePictureFile;
  int minInvestmentAmount;
  int maxInvestmentAmount;
  List<String> preferredIndustries;
  List<String> preferredLocations;
  List<String> preferredInvestmentStages;

  InvestorProfileModel({
    this.userId,
    this.fullName = '',
    this.calendlyLink = '',
    this.location = '',
    this.bio = '',
    this.aiAnalysis = '',
    this.profilePictureUrl = '',
    this.profilePictureFile,
    this.minInvestmentAmount = 0,
    this.maxInvestmentAmount = 0,
    this.preferredIndustries = const [],
    this.preferredLocations = const [],
    this.preferredInvestmentStages = const [],
  });

  factory InvestorProfileModel.fromJson(Map<String, dynamic> json) {
    return InvestorProfileModel(
      userId: json['user_id'],
      fullName: json['full_name'] ?? '',
      calendlyLink: json['calendly_link'] ?? '',
      location: json['location'] ?? '',
      bio: json['bio'] ?? '',
      aiAnalysis: json['ai_analysis'] ?? '',
      profilePictureUrl: json['profile_picture_url'] ?? '',
      minInvestmentAmount: int.tryParse(json['min_investment_amount'].toString()) ?? 0,
      maxInvestmentAmount: int.tryParse(json['max_investment_amount'].toString()) ?? 0,
      preferredIndustries: List<String>.from(json['industries'] ?? []),
      preferredLocations: List<String>.from(json['preferred_locations'] ?? []),
      preferredInvestmentStages: List<String>.from(json['investment_stages'] ?? []),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'user_id': userId,
      'full_name': fullName,
      'calendly_link': calendlyLink,
      'location': location,
      'bio': bio,
      'profile_picture_url': profilePictureUrl,
      'min_investment_amount': minInvestmentAmount,
      'max_investment_amount': maxInvestmentAmount,
      'industries': preferredIndustries,
      'preferred_locations': preferredLocations,
      'investment_stages': preferredInvestmentStages,
    };
  }
}
