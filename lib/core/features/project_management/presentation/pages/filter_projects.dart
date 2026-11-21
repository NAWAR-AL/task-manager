import 'package:flutter/material.dart';
import 'package:task_manager/core/features/app_widgets/colors.dart';
import 'package:task_manager/core/features/project_management/domain/entities/project.dart';

class FilterProjects extends StatefulWidget {
  final List<ProjectEntity> projects;
  final Function(String? status, int? projectId) onFilterChanged;
  const FilterProjects({
    super.key,
    required this.onFilterChanged,
    required this.projects,
  });

  @override
  State<FilterProjects> createState() => _FilterProjectsState();
}

class _FilterProjectsState extends State<FilterProjects> {
  final TextEditingController statusController = TextEditingController();
  final TextEditingController nameController = TextEditingController();

  String? selectedStatus;
  int? selectedProjectId;

  final List<String> status = ['all', 'active', 'on_hold', 'completed'];
  void notifyParent() {
    widget.onFilterChanged(selectedStatus, selectedProjectId);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: ColorsApp.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: ColorsApp.divider),
      ),
      child: Row(
        children: [
          Expanded(
            child: DropdownMenu<int>(
              dropdownMenuEntries: [
                DropdownMenuEntry(value: 0, label: 'All Projects'),
                ...widget.projects.map((project) {
                  return DropdownMenuEntry<int>(
                    value: project.id!,
                    label: project.name,
                  );
                }),
              ],
              onSelected: (value) {
                setState(() {
                  selectedProjectId = value == 0 ? null : value;
                });
                notifyParent();
              },
              label: Text('Project'),
              width: double.infinity,
              initialSelection: selectedProjectId,
            ),
          ),

          SizedBox(width: 20),
          Expanded(
            child: DropdownMenu<String>(
              dropdownMenuEntries: status.map((priority) {
                return DropdownMenuEntry<String>(
                  value: priority,
                  label: priorityLabel(priority),
                );
              }).toList(),
              onSelected: (value) {
                setState(() {
                  selectedStatus = value == 'all' ? null : value;
                });
                notifyParent();
              },
              label: Text('Status'),
              width: double.infinity,
              initialSelection: selectedStatus,
            ),
          ),
        ],
      ),
    );
  }

  String priorityLabel(String priority) {
    return priority[0].toUpperCase() + priority.substring(1);
  }
}
