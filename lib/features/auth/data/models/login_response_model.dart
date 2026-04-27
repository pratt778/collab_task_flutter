import 'package:flutter_clean_starter/features/auth/domain/entities/login_entity.dart';

import 'organization_model.dart';

class LoginResponseModel {
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
  final OrganizationModel organization;

  const LoginResponseModel({
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

  factory LoginResponseModel.fromJson(Map<String, dynamic> json) {
    return LoginResponseModel(
      id: json['id'] ?? 0,
      nameEn: json['name_en'] ?? '',
      nameNp: json['name_np'] ?? '',
      addressEn: json['address_en'] ?? '',
      addressNp: json['address_np'] ?? '',
      areaNameEn: json['area_name_en'] ?? '',
      areaNameNp: json['area_name_np'] ?? '',
      subAreaNameEn: json['sub_area_name_en'],
      subAreaNameNp: json['sub_area_name_np'],
      wardNameEn: (json['ward_name_en'] ?? '').toString(),
      wardNameNp: (json['ward_name_np'] ?? '').toString(),
      collectionTypeEn: json['collection_type_en'],
      collectionTypeNp: json['collection_type_np'],
      customerTypeEn: json['customer_type_en'],
      customerTypeNp: json['customer_type_np'],
      customerImage: json['customer_image'] ?? '',
      contactNumber: json['contact_number'] ?? '',
      customerNo: json['customer_no'] ?? '',
      tenantId: json['tenant_id'],
      token: json['token'] ?? '',
      organization: OrganizationModel.fromJson(
        json['organization'] ?? <String, dynamic>{},
      ),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name_en': nameEn,
      'name_np': nameNp,
      'address_en': addressEn,
      'address_np': addressNp,
      'area_name_en': areaNameEn,
      'area_name_np': areaNameNp,
      'sub_area_name_en': subAreaNameEn,
      'sub_area_name_np': subAreaNameNp,
      'ward_name_en': wardNameEn,
      'ward_name_np': wardNameNp,
      'collection_type_en': collectionTypeEn,
      'collection_type_np': collectionTypeNp,
      'customer_type_en': customerTypeEn,
      'customer_type_np': customerTypeNp,
      'customer_image': customerImage,
      'contact_number': contactNumber,
      'customer_no': customerNo,
      'tenant_id': tenantId,
      'token': token,
      'organization': organization.toJson(),
    };
  }

  LoginResponseEntity toEntity() {
    return LoginResponseEntity(
      id: id,
      nameEn: nameEn,
      nameNp: nameNp,
      addressEn: addressEn,
      addressNp: addressNp,
      areaNameEn: areaNameEn,
      areaNameNp: areaNameNp,
      subAreaNameEn: subAreaNameEn,
      subAreaNameNp: subAreaNameNp,
      wardNameEn: wardNameEn,
      wardNameNp: wardNameNp,
      collectionTypeEn: collectionTypeEn,
      collectionTypeNp: collectionTypeNp,
      customerTypeEn: customerTypeEn,
      customerTypeNp: customerTypeNp,
      customerImage: customerImage,
      contactNumber: contactNumber,
      customerNo: customerNo,
      tenantId: tenantId,
      token: token,
      organization: organization.toEntity(),
    );
  }
}