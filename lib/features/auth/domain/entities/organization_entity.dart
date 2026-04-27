import 'package:equatable/equatable.dart';

class OrganizationEntity extends Equatable {
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

  const OrganizationEntity({
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

  @override
  List<Object?> get props => [
        id,
        organizationNameEn,
        organizationNameNp,
        shortName,
        organizationCode,
        contactAddressEn,
        contactAddressNp,
        contactMobileEn,
        contactMobileNp,
        contactPerson,
        organizationType,
        emailAddress,
        website,
      ];

  @override
  String toString() {
    return 'OrganizationEntity('
        'id: $id, '
        'organizationNameEn: $organizationNameEn, '
        'organizationNameNp: $organizationNameNp, '
        'shortName: $shortName, '
        'organizationCode: $organizationCode, '
        'contactAddressEn: $contactAddressEn, '
        'contactAddressNp: $contactAddressNp, '
        'contactMobileEn: $contactMobileEn, '
        'contactMobileNp: $contactMobileNp, '
        'contactPerson: $contactPerson, '
        'organizationType: $organizationType, '
        'emailAddress: $emailAddress, '
        'website: $website)';
  }
}