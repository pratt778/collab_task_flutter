import 'package:flutter/material.dart';

class RouteModel {
  final String name;
  final String path;
  final Widget page;

  const RouteModel({
    required this.name,
    required this.path,
    required this.page,
  });
}