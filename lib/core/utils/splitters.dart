

String getOrgName(String rawString) {
  final List<String> parts = rawString.split('::');

  return parts.isNotEmpty ? parts[0] : '';
}

