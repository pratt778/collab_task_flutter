import '../../domain/entities/organization_entity.dart';

class OrganizationModel {
  final int id;
  final String organizationNameEn;
  final String organizationNameNp;
  final String shortName;
  final String organizationCode;
  final String? contactAddressEn;
  final String? contactAddressNp;
  final String? contactMobileEn;
  final String? contactMobileNp;
  final String? contactPerson;
  final String? organizationType;
  final String? emailAddress;
  final String? website;

  const OrganizationModel({
    required this.id,
    required this.organizationNameEn,
    required this.organizationNameNp,
    required this.shortName,
    required this.organizationCode,
    this.contactAddressEn,
    this.contactAddressNp,
    this.contactMobileEn,
    this.contactMobileNp,
    this.contactPerson,
    this.organizationType,
    this.emailAddress,
    this.website,
  });

  factory OrganizationModel.fromJson(Map<String, dynamic> json) {
    return OrganizationModel(
      id: json['id'] ?? 0,
      organizationNameEn: json['organization_name_en'] ?? '',
      organizationNameNp: json['organization_name_np'] ?? '',
      shortName: json['short_name'] ?? '',
      organizationCode: json['organization_code'] ?? '',
      contactAddressEn: json['contact_address_en'],
      contactAddressNp: json['contact_address_np'],
      contactMobileEn: json['contact_mobile_en'],
      contactMobileNp: json['contact_mobile_np'],
      contactPerson: json['contact_person'],
      organizationType: json['organization_type'],
      emailAddress: json['email_address'],
      website: json['website'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'organization_name_en': organizationNameEn,
      'organization_name_np': organizationNameNp,
      'short_name': shortName,
      'organization_code': organizationCode,
      'contact_address_en': contactAddressEn,
      'contact_address_np': contactAddressNp,
      'contact_mobile_en': contactMobileEn,
      'contact_mobile_np': contactMobileNp,
      'contact_person': contactPerson,
      'organization_type': organizationType,
      'email_address': emailAddress,
      'website': website,
    };
  }

  OrganizationEntity toEntity() {
    return OrganizationEntity(
      id: id,
      organizationNameEn: organizationNameEn,
      organizationNameNp: organizationNameNp,
      shortName: shortName,
      organizationCode: organizationCode,
      contactAddressEn: contactAddressEn,
      contactAddressNp: contactAddressNp,
      contactMobileEn: contactMobileEn,
      contactMobileNp: contactMobileNp,
      contactPerson: contactPerson,
      organizationType: organizationType,
      emailAddress: emailAddress,
      website: website,
    );
  }
}