import 'package:equatable/equatable.dart';

class VisaGradient extends Equatable {
  final String startHex;
  final String endHex;

  const VisaGradient({
    required this.startHex,
    required this.endHex,
  });

  @override
  List<Object?> get props => [startHex, endHex];
}

class VisaEntity extends Equatable {
  final String id;
  final String countryName;
  final String visaTitle;
  final double priceUsd;
  final String processingTime; // e.g. "3 أيام عمل"
  final List<String> requiredDocuments; // Bullet list managed from admin panel
  final VisaGradient gradient;
  final String? countryCode; // e.g. "TR", "AE", "EG", "GB"
  final String? flagEmoji;
  final bool isActive;
  final DateTime createdAt;

  const VisaEntity({
    required this.id,
    required this.countryName,
    required this.visaTitle,
    required this.priceUsd,
    required this.processingTime,
    required this.requiredDocuments,
    required this.gradient,
    this.countryCode,
    this.flagEmoji,
    this.isActive = true,
    required this.createdAt,
  });

  @override
  List<Object?> get props => [
        id,
        countryName,
        visaTitle,
        priceUsd,
        processingTime,
        requiredDocuments,
        gradient,
        countryCode,
        flagEmoji,
        isActive,
        createdAt,
      ];
}
