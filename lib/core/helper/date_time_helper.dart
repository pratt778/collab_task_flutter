// Helper to parse the string once
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:nepali_utils/nepali_utils.dart';

DateTime _parseDate(String dateStr) => DateTime.parse(dateStr);

/// Returns the full month name (e.g., "April")
String getMonthName(String dateStr) {
  final DateTime date = _parseDate(dateStr);
  return DateFormat('MMMM').format(date).toLowerCase();
}

/// Returns the day as a string (e.g., "19")
String getDayString(String dateStr) {
  final DateTime date = _parseDate(dateStr);
  return date.day.toString();
}

String getMonthAbbreviation(String monthName) {
  if (monthName.isEmpty) return '';

  try {
    // 1. Capitalize first letter (e.g., 'april' -> 'April')
    final String formattedInput =
        monthName[0].toUpperCase() + monthName.substring(1).toLowerCase();

    // 2. Parse and format
    final DateTime date = DateFormat('MMMM').parse(formattedInput);
    return DateFormat('MMM').format(date).toLowerCase(); // returns 'apr'
  } catch (e) {
    debugPrint('Error parsing month: $e');
    return 'inv';
  }
}

String formatToFullDate(String dateString) {
  try {
    // 1. Parse the string into a DateTime object
    final DateTime dateTime = DateTime.parse(dateString);

    // 2. Format the DateTime object
    // 'MMMM' = Full Month, 'd' = day, 'y' = year
    return DateFormat('MMMM d, y').format(dateTime);
  } catch (e) {
    return 'Invalid Date';
  }
}

/// Returns the full Nepali month name (e.g., "Baishakh")
String getNepaliMonthName(String dateStr) {
  try {
    // Expects "YYYY-MM-DD"
    final NepaliDateTime date = NepaliDateTime.parse(dateStr);
    return NepaliDateFormat('MMMM', Language.nepali).format(date).toLowerCase();
  } catch (e) {
    return 'invalid';
  }
}

/// Returns the abbreviation (e.g., "baishakh" -> "bai")
String getNepaliMonthAbbreviation(String monthName) {
  if (monthName.isEmpty) return '';

  // Full Month names in Devnagari
  const months = [
    'बैशाख',
    'जेठ',
    'असार',
    'साउन',
    'भदौ',
    'असोज',
    'कात्तिक',
    'मंसिर',
    'पुष',
    'माघ',
    'फागुन',
    'चैत',
  ];

  // Abbreviations in Devnagari
  const abbreviations = [
    'बैशा',
    'जेठ',
    'असा',
    'साउ',
    'भदौ',
    'असो',
    'कात्',
    'मंसी',
    'पुष',
    'माघ',
    'फागु',
    'चैत',
  ];

  final String input = monthName.trim();
  final int index = months.indexOf(input);

  if (index != -1) {
    return abbreviations[index];
  } else {
    debugPrint('Month name "$monthName" not recognized');
    return 'त्रुटि'; // Means "Error"
  }
}
