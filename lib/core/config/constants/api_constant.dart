/// Generic API endpoint registry.
///
/// The starter uses `jsonplaceholder.typicode.com` so `flutter run` works out
/// of the box with no backend setup. Replace the hosts and endpoints when
/// you wire up your real API.
class ApiConstants {
  // ── Hosts ────────────────────────────────────────────────────────────
  static const String localIp = 'http://10.0.2.2:8080';
  static const String devIp = 'https://jsonplaceholder.typicode.com';

  /// Mutable so the dev/staging IP-config screen can swap hosts at runtime.
  /// Production flavors keep this compile-time default.
  static String baseUrl = devIp;

  static String buildBaseUrl(String host) => host.trimRight();

  // ── Endpoints ────────────────────────────────────────────────────────
  // Auth (placeholder — point at your backend)
  static const String login = 'auth/login';
  static const String logout = 'auth/logout';

  // Demo (jsonplaceholder placeholder list)
  static const String demos = 'posts';

  // ── Tasks ────────────────────────────────────────────────────────────
  static const String tasks = 'tasks';
  static const String taskDetail = 'tasks/:id';
  static const String taskChecklist = 'tasks/:id/checklist';
  static const String taskChecklistItem = 'tasks/:id/checklist/:checkId';

  // ── WebSockets ───────────────────────────────────────────────────────
  static const String ws = 'ws';

  // ── Supabase (Optional: Use if not using REST API Helper) ────────────
  static const String supabaseUrl = 'YOUR_SUPABASE_URL';
  static const String supabaseAnonKey = 'YOUR_SUPABASE_ANON_KEY';
}
