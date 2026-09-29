import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:core_domain/entities/visa_entity.dart';

class VisaModel extends VisaEntity {
  const VisaModel({
    required super.id,
    required super.countryName,
    required super.visaTitle,
    required super.priceUsd,
    required super.processingTime,
    required super.requiredDocuments,
    required super.gradient,
    super.countryCode,
    super.flagEmoji,
    super.isActive = true,
    required super.createdAt,
  });

  factory VisaModel.fromJson(Map<String, dynamic> json, String id) {
    return VisaModel(
      id: id,
      countryName: json['countryName'] as String? ?? '',
      visaTitle: json['visaTitle'] as String? ?? '',
      priceUsd: (json['priceUsd'] as num?)?.toDouble() ?? 0.0,
      processingTime: json['processingTime'] as String? ?? '3 أيام عمل',
      requiredDocuments: (json['requiredDocuments'] as List<dynamic>?)
              ?.map((e) => e.toString())
              .toList() ??
          [],
      gradient: VisaGradient(
        startHex: json['gradientStart'] as String? ?? '#0E2A47',
        endHex: json['gradientEnd'] as String? ?? '#C9A227',
      ),
      countryCode: json['countryCode'] as String?,
      flagEmoji: json['flagEmoji'] as String?,
      isActive: json['isActive'] as bool? ?? true,
      createdAt: json['createdAt'] != null
          ? (json['createdAt'] as Timestamp).toDate()
          : DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'countryName': countryName,
      'visaTitle': visaTitle,
      'priceUsd': priceUsd,
      'processingTime': processingTime,
      'requiredDocuments': requiredDocuments,
      'gradientStart': gradient.startHex,
      'gradientEnd': gradient.endHex,
      'countryCode': countryCode,
      'flagEmoji': flagEmoji,
      'isActive': isActive,
      'createdAt': Timestamp.fromDate(createdAt),
    };
  }

  factory VisaModel.fromEntity(VisaEntity entity) {
    return VisaModel(
      id: entity.id,
      countryName: entity.countryName,
      visaTitle: entity.visaTitle,
      priceUsd: entity.priceUsd,
      processingTime: entity.processingTime,
      requiredDocuments: entity.requiredDocuments,
      gradient: entity.gradient,
      countryCode: entity.countryCode,
      flagEmoji: entity.flagEmoji,
      isActive: entity.isActive,
      createdAt: entity.createdAt,
    );
  }
}
