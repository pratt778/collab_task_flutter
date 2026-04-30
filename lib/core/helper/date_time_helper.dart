import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

DateTime _parseDate(String dateStr) => DateTime.parse(dateStr);

/// Returns the full month name (e.g., "april").
String getMonthName(String dateStr) {
  final DateTime date = _parseDate(dateStr);
  return DateFormat('MMMM').format(date).toLowerCase();
}

/// Returns the day as a string (e.g., "19").
String getDayString(String dateStr) {
  final DateTime date = _parseDate(dateStr);
  return date.day.toString();
}

/// Returns the 3-letter abbreviation for a full month name (e.g., "apr").
String getMonthAbbreviation(String monthName) {
  if (monthName.isEmpty) return '';

  try {
    final String formattedInput =
        monthName[0].toUpperCase() + monthName.substring(1).toLowerCase();
    final DateTime date = DateFormat('MMMM').parse(formattedInput);
    return DateFormat('MMM').format(date).toLowerCase();
  } catch (e) {
    debugPrint('Error parsing month: $e');
    return 'inv';
  }
}

/// Returns the full date in long format (e.g., "April 19, 2026").
String formatToFullDate(String dateString) {
  try {
    final DateTime dateTime = DateTime.parse(dateString);
    return DateFormat('MMMM d, y').format(dateTime);
  } catch (e) {
    return 'Invalid Date';
  }
}
