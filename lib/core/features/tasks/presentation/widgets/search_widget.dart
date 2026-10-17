import 'package:flutter/material.dart';
import 'package:task_manager/core/features/app_widgets/colors.dart';
import 'package:task_manager/core/features/project_management/domain/entities/project.dart';

class SearchWidget extends StatefulWidget {
  final List<ProjectEntity> projects;
  final Function(String? priority, int? projectId) onFilterChanged;
  const SearchWidget({
    super.key,
    required this.onFilterChanged,
    required this.projects,
  });

  @override
  State<SearchWidget> createState() => _SearchWidgetState();
}

class _SearchWidgetState extends State<SearchWidget> {
  final TextEditingController statusController = TextEditingController();
  final TextEditingController priorityController = TextEditingController();

  String? selectedPriority;
  int? selectedProjectId;

  final List<String> priorities = ['All', 'low', 'medium', 'high'];
  void notifyParent() {
    widget.onFilterChanged(selectedPriority, selectedProjectId);
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
              dropdownMenuEntries: priorities.map((priority) {
                return DropdownMenuEntry<String>(
                  value: priority,
                  label: priorityLabel(priority),
                );
              }).toList(),
              onSelected: (value) {
                setState(() {
                  selectedPriority = value == 'All' ? null : value;
                });
                notifyParent();
              },
              label: Text('Priority'),
              width: double.infinity,
              initialSelection: selectedPriority,
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
