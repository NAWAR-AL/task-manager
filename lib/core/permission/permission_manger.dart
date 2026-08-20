

import 'package:taskmanger/core/permission/permission.dart';
import 'package:taskmanger/core/permission/role.dart';

class PermissionManager {
  static bool can(UserRole role, Permission permission) {
    switch (role) {
      case UserRole.admin:
        return true;

      case UserRole.editor:
        return [
          //1-task
          Permission.createTask,
          Permission.readTask,
          Permission.updateTask,
          Permission.deleteTask,
          Permission.updateTaskStatus, 
          //2-project
          Permission.createProject,
          Permission.readProject,
          Permission.updateProject,
          Permission.deleteProject,
          //3- comment
          Permission.createComment,
          Permission.readComment,
          Permission.updateComment,
          Permission.deleteComment,
        ].contains(permission);
      case UserRole.developer:
        return [
          Permission.readTask,
          Permission.updateTaskStatus,
          Permission.createComment,
          Permission.readComment,
          Permission.updateComment,
        ].contains(permission);
    }
  }
}
