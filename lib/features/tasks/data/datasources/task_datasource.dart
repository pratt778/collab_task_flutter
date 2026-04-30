import 'package:injectable/injectable.dart';
import 'package:collab_task/core/config/constants/api_constant.dart';
import 'package:collab_task/core/network/api_helper.dart';
import 'package:collab_task/core/utils/safe_request_mapper.dart';
import 'package:collab_task/features/tasks/data/models/task_model.dart';

abstract class TaskDatasource {
  Future<List<TaskModel>> getTasks();
  Future<TaskModel> getTaskDetail(String id);
  Future<TaskModel> createTask(TaskModel task);
  Future<TaskModel> updateTask(TaskModel task);
  Future<bool> deleteTask(String id);
}

@LazySingleton(as: TaskDatasource)
class TaskDatasourceImpl implements TaskDatasource {
  final ApiHelper apiHelper;

  TaskDatasourceImpl(this.apiHelper);

  @override
  Future<List<TaskModel>> getTasks() => SafeRequest.call(() async {
        final response = await apiHelper.get(path: ApiConstants.tasks);
        return (response.data as List)
            .map((e) => TaskModel.fromJson(e as Map<String, dynamic>))
            .toList();
      });

  @override
  Future<TaskModel> getTaskDetail(String id) => SafeRequest.call(() async {
        final response = await apiHelper.get(
          path: ApiConstants.taskDetail.replaceFirst(':id', id),
        );
        return TaskModel.fromJson(response.data as Map<String, dynamic>);
      });

  @override
  Future<TaskModel> createTask(TaskModel task) => SafeRequest.call(() async {
        final response = await apiHelper.post(
          path: ApiConstants.tasks,
          body: task.toJson(),
        );
        return TaskModel.fromJson(response.data as Map<String, dynamic>);
      });

  @override
  Future<TaskModel> updateTask(TaskModel task) => SafeRequest.call(() async {
        final response = await apiHelper.patch(
          path: ApiConstants.taskDetail.replaceFirst(':id', task.id),
          body: task.toJson(),
        );
        return TaskModel.fromJson(response.data as Map<String, dynamic>);
      });

  @override
  Future<bool> deleteTask(String id) => SafeRequest.call(() async {
        await apiHelper.delete(
          path: ApiConstants.taskDetail.replaceFirst(':id', id),
        );
        return true;
      });
}
