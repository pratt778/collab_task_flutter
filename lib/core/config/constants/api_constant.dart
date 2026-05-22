import 'package:flutter_dotenv/flutter_dotenv.dart';

/// Generic API endpoint registry for optional REST/WebSocket services.
///
/// Supabase-backed features use `Supabase.instance.client` directly. These
/// values are kept for dev tooling, Chucker, and any future REST endpoints.
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

  // ── Tasks ────────────────────────────────────────────────────────────
  static const String tasks = 'tasks';
  static const String taskDetail = 'tasks/:id';
  static const String taskChecklist = 'tasks/:id/checklist';
  static const String taskChecklistItem = 'tasks/:id/checklist/:checkId';

  // ── WebSockets ───────────────────────────────────────────────────────
  static const String ws = 'ws';

  // ── Supabase ─────────────────────────────────────────────────────────
  static String get supabaseUrl => dotenv.get('SUPABASE_URL', fallback: '');
  static String get supabaseAnonKey =>
      dotenv.get('SUPABASE_ANON_KEY', fallback: '');
}
