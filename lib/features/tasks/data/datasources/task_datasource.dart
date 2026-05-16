import 'package:flutter/foundation.dart';
import 'package:injectable/injectable.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:collab_task/core/utils/safe_request_mapper.dart';
import 'package:collab_task/features/tasks/data/models/task_model.dart';

abstract class TaskDatasource {
  Future<List<TaskModel>> getTasks(String workspaceId);
  Future<TaskModel> getTaskDetail(String id);
  Future<TaskModel> createTask(TaskModel task);
  Future<TaskModel> updateTask(TaskModel task);
  Future<bool> deleteTask(String id);
}

@LazySingleton(as: TaskDatasource)
class TaskDatasourceImpl implements TaskDatasource {
  SupabaseClient get _client => Supabase.instance.client;

  @override
  Future<List<TaskModel>> getTasks(String workspaceId) => SafeRequest.call(() async {
        final response = await _client
            .from('tasks')
            .select()
            .eq('workspace_id', workspaceId)
            .order('created_at', ascending: false);
        
        return (response as List)
            .map((e) => TaskModel.fromJson(e as Map<String, dynamic>))
            .toList();
      });

  @override
  Future<TaskModel> getTaskDetail(String id) => SafeRequest.call(() async {
        final response = await _client
            .from('tasks')
            .select()
            .eq('id', id)
            .single();
        return TaskModel.fromJson(response);
      });

  @override
  Future<TaskModel> createTask(TaskModel task) => SafeRequest.call(() async {
        // Remove ID to let Postgres generate it
        final taskData = task.toJson()..remove('id');
        
        debugPrint('📤 Supabase: Inserting task: $taskData');

        final response = await _client
            .from('tasks')
            .insert(taskData)
            .select()
            .single();
        return TaskModel.fromJson(response);
      });

  @override
  Future<TaskModel> updateTask(TaskModel task) => SafeRequest.call(() async {
        final response = await _client
            .from('tasks')
            .update(task.toJson())
            .eq('id', task.id)
            .select()
            .single();
        return TaskModel.fromJson(response);
      });

  @override
  Future<bool> deleteTask(String id) => SafeRequest.call(() async {
        await _client.from('tasks').delete().eq('id', id);
        return true;
      });
}
