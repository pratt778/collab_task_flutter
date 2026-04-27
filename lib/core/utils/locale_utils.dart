import 'package:flutter/material.dart';

String localizedOf(BuildContext context, String en, String np) =>
    Localizations.localeOf(context).languageCode == 'ne' ? np : en;
