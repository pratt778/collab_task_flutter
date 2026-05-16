import 'package:injectable/injectable.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:collab_task/core/utils/safe_request_mapper.dart';
import 'package:collab_task/features/workspaces/data/models/workspace_model.dart';

abstract class WorkspaceRemoteDatasource {
  Future<List<WorkspaceModel>> getMyWorkspaces();
  Future<WorkspaceModel> createWorkspace({required String name, String? description});
}

@LazySingleton(as: WorkspaceRemoteDatasource)
class WorkspaceRemoteDatasourceImpl implements WorkspaceRemoteDatasource {
  SupabaseClient get _client => Supabase.instance.client;

  @override
  Future<List<WorkspaceModel>> getMyWorkspaces() {
    return SafeRequest.call(() async {
      final response = await _client.from('workspaces').select();
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
      
      // Also add the owner as a member (though trigger could handle this, 
      // let's be explicit if needed, or assume trigger handles it)
      await _client.from('workspace_members').insert({
        'workspace_id': response['id'],
        'user_id': userId,
        'role': 'admin',
      });

      return WorkspaceModel.fromJson(response);
    });
  }
}
