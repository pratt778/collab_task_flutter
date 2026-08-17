import 'package:injectable/injectable.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:collab_task/core/utils/safe_request_mapper.dart';
import 'package:collab_task/core/error/exceptions.dart';
import 'package:collab_task/features/workspaces/data/models/workspace_model.dart';

abstract class WorkspaceRemoteDatasource {
  Future<List<WorkspaceModel>> getMyWorkspaces();
  Future<WorkspaceModel> createWorkspace({required String name, String? description});
  Future<void> addMemberByEmail({required String workspaceId, required String email});
  Future<void> deleteWorkspace(String workspaceId);
  Future<List<Map<String, dynamic>>> getWorkspaceMembers(String workspaceId);
}

@LazySingleton(as: WorkspaceRemoteDatasource)
class WorkspaceRemoteDatasourceImpl implements WorkspaceRemoteDatasource {
  SupabaseClient get _client => Supabase.instance.client;

  @override
  Future<List<Map<String, dynamic>>> getWorkspaceMembers(String workspaceId) {
    return SafeRequest.call(() async {
      final response = await _client
          .from('workspace_members')
          .select('role, profiles(*)')
          .eq('workspace_id', workspaceId);
      return (response as List).cast<Map<String, dynamic>>();
    });
  }

  @override
  Future<void> deleteWorkspace(String workspaceId) {
    return SafeRequest.call(() async {
      await _client.from('workspaces').delete().eq('id', workspaceId);
    });
  }

  @override
  Future<List<WorkspaceModel>> getMyWorkspaces() {
    return SafeRequest.call(() async {
      // We rely on RLS policies to filter workspaces where the user is a member
      final response = await _client
          .from('workspaces')
          .select();
      
      return (response as List).map((json) => WorkspaceModel.fromJson(json)).toList();
    });
  }

  @override
  Future<WorkspaceModel> createWorkspace({required String name, String? description}) {
    return SafeRequest.call(() async {
      final userId = _client.auth.currentUser!.id;
      final response = await _client.from('workspaces').insert({
        'name': name,
        'description': description,
        'owner_id': userId,
      }).select().single();
      
      // Also add the owner as a member
      await _client.from('workspace_members').insert({
        'workspace_id': response['id'],
        'user_id': userId,
        'role': 'admin',
      });

      return WorkspaceModel.fromJson(response);
    });
  }

  @override
  Future<void> addMemberByEmail({required String workspaceId, required String email}) {
    return SafeRequest.call(() async {
      // 1. Find user by email in profiles
      final userResponse = await _client
          .from('profiles')
          .select('id')
          .eq('email', email)
          .maybeSingle();

      if (userResponse == null) {
        throw const ApiException('No user found with this email address.');
      }

      final userId = userResponse['id'] as String;

      // 2. Add to members table
      await _client.from('workspace_members').insert({
        'workspace_id': workspaceId,
        'user_id': userId,
        'role': 'member',
      });
    });
  }
}
