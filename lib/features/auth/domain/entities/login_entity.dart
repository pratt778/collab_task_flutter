import 'package:equatable/equatable.dart';

import 'organization_entity.dart';

class LoginResponseEntity extends Equatable {
  final int id;
  final String nameEn;
  final String nameNp;
  final String addressEn;
  final String addressNp;
  final String areaNameEn;
  final String areaNameNp;
  final String? subAreaNameEn;
  final String? subAreaNameNp;
  final String wardNameEn;
  final String wardNameNp;
  final String? collectionTypeEn;
  final String? collectionTypeNp;
  final String? customerTypeEn;
  final String? customerTypeNp;
  final String customerImage;
  final String contactNumber;
  final String customerNo;
  final String? tenantId;
  final String token;
  final OrganizationEntity organization;

  const LoginResponseEntity({
    required this.id,
    required this.nameEn,
    required this.nameNp,
    required this.addressEn,
    required this.addressNp,
    required this.areaNameEn,
    required this.areaNameNp,
    this.subAreaNameEn,
    this.subAreaNameNp,
    required this.wardNameEn,
    required this.wardNameNp,
    this.collectionTypeEn,
    this.collectionTypeNp,
    this.customerTypeEn,
    this.customerTypeNp,
    required this.customerImage,
    required this.contactNumber,
    required this.customerNo,
    this.tenantId,
    required this.token,
    required this.organization,
  });

  @override
  List<Object?> get props => [
        id,
        nameEn,
        nameNp,
        addressEn,
        addressNp,
        areaNameEn,
        areaNameNp,
        subAreaNameEn,
        subAreaNameNp,
        wardNameEn,
        wardNameNp,
        collectionTypeEn,
        collectionTypeNp,
        customerTypeEn,
        customerTypeNp,
        customerImage,
        contactNumber,
        customerNo,
        tenantId,
        token,
        organization,
      ];

  @override
  
  String toString() {
    return 'LoginResponseEntity('
        'id: $id, '
        'nameEn: $nameEn, '
        'nameNp: $nameNp, '
        'addressEn: $addressEn, '
        'addressNp: $addressNp, '
        'areaNameEn: $areaNameEn, '
        'areaNameNp: $areaNameNp, '
        'subAreaNameEn: $subAreaNameEn, '
        'subAreaNameNp: $subAreaNameNp, '
        'wardNameEn: $wardNameEn, '
        'wardNameNp: $wardNameNp, '
        'collectionTypeEn: $collectionTypeEn, '
        'collectionTypeNp: $collectionTypeNp, '
        'customerTypeEn: $customerTypeEn, '
        'customerTypeNp: $customerTypeNp, '
        'customerImage: $customerImage, '
        'contactNumber: $contactNumber, '
        'customerNo: $customerNo, '
        'tenantId: $tenantId, '
        'token: $token, '
        'organization: $organization)';
  }
}