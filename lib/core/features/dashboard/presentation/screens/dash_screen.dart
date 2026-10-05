import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:task_manager/core/features/auth/presentation/cubit/profile_cubit.dart';
import 'package:task_manager/core/features/dashboard/domain/entity/dashboard_entity.dart';
import 'package:task_manager/core/features/dashboard/presentation/bloc/dashboard_bloc.dart';

class DashScreen extends StatefulWidget {
  const DashScreen({super.key});

  @override
  State<DashScreen> createState() => _DashScreenState();
}

class _DashScreenState extends State<DashScreen> {
  @override
  void initState() {
    super.initState();

    context.read<ProfileCubit>().getDashboardusers();

    context.read<DashboardBloc>().add(GetStatistics());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xffF7FAFD),

      body: SafeArea(
        child: BlocBuilder<DashboardBloc, DashboardState>(
          builder: (context, state) {
            if (state is DashboardLoaded) {
              final data = state.entity.data!;

              return SingleChildScrollView(
                padding: EdgeInsets.fromLTRB(20, 15, 20, 25),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildHeader(),

                    Gap(25),

                    _buildWelcome(),

                    Gap(25),

                    _buildStatistics(data),

                    Gap(22),

                    _buildTasksStatus(data),

                    Gap(22),

                    _buildPriorityTasks(data),

                    Gap(22),

                    _buildRecentActivity(state.recentActivity),

                    Gap(15),
                  ],
                ),
              );
            }

            if (state is DashboardError) {
              return Center(
                child: Text(state.message, style: TextStyle(color: Colors.red)),
              );
            }

            return Center(child: CircularProgressIndicator());
          },
        ),
      ),
    );
  }

  // HEADER

  Widget _buildHeader() {
    return Row(
      children: [
        IconButton(
          onPressed: () {
            Scaffold.of(context).openDrawer();
          },
          icon: Icon(Icons.menu, size: 28),
        ),

        Spacer(),

        IconButton(
          onPressed: () {},
          icon: Icon(Icons.notifications_none, size: 28),
        ),

        Gap(8),

        CircleAvatar(
          radius: 22,
          backgroundColor: Color(0xffE8D9FF),
          child: Text(
            "A",
            style: TextStyle(
              fontSize: 19,
              fontWeight: FontWeight.bold,
              color: Color(0xff5B3A8C),
            ),
          ),
        ),
      ],
    );
  }

  // WELCOME

  Widget _buildWelcome() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Welcome back,",
          style: TextStyle(fontSize: 21, color: Color(0xff58708D)),
        ),

        Text(
          "Admin 👋",
          style: TextStyle(
            fontSize: 32,
            fontWeight: FontWeight.bold,
            color: Color(0xff102A43),
          ),
        ),

        Gap(5),

        Text(
          "Here's what's happening with your system today.",
          style: TextStyle(fontSize: 14, color: Color(0xff718096)),
        ),
      ],
    );
  }

  // STATISTICS

  Widget _buildStatistics(dynamic data) {
    return Row(
      children: [
        Expanded(
          child: _statisticsCard(
            title: "Total Projects",
            value: '${data.total_projects ?? 0}',
            icon: Icons.folder_outlined,
            backgroundColor: Color(0xffEAF3FF),
          ),
        ),

        Gap(14),

        Expanded(
          child: _statisticsCard(
            title: "Total Tasks",
            value: '${data.total_tasks ?? 0}',
            icon: Icons.task_alt,
            backgroundColor: Color(0xfffff7e5),
          ),
        ),
      ],
    );
  }

  Widget _statisticsCard({
    required String title,
    required String value,
    required IconData icon,
    required Color backgroundColor,
  }) {
    return Container(
      padding: EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(
            radius: 23,
            backgroundColor: Colors.white.withOpacity(.7),
            child: Icon(icon, color: Color(0xff1976D2), size: 27),
          ),

          Gap(12),

          Text(title, style: TextStyle(fontSize: 14, color: Color(0xff58708D))),

          Gap(4),

          Text(
            value,
            style: TextStyle(
              fontSize: 30,
              fontWeight: FontWeight.bold,
              color: Color(0xff102A43),
            ),
          ),
        ],
      ),
    );
  }

  // TASKS BY STATUS

  Widget _buildTasksStatus(dynamic data) {
    return _sectionContainer(
      title: "Tasks by Status",
      child: Row(
        children: [
          SizedBox(width: 150, height: 150, child: _buildDonutChart(data)),

          Gap(18),

          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _statusRow(
                  color: Color(0xffffd96a),
                  title: "Todo",
                  value: data.todo,
                  total: data.total_tasks,
                ),

                Gap(12),

                _statusRow(
                  color: Color(0xff69CDB5),
                  title: "In Progress",
                  value: data.in_progress,
                  total: data.total_tasks,
                ),

                Gap(12),

                _statusRow(
                  color: Color(0xff4FA4D8),
                  title: "Done",
                  value: data.done,
                  total: data.total_tasks,
                ),

                Gap(12),

                _statusRow(
                  color: Color(0xffff7777),
                  title: "Review",
                  value: data.review,
                  total: data.total_tasks,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDonutChart(dynamic data) {
    return Stack(
      alignment: Alignment.center,
      children: [
        PieChart(
          PieChartData(
            centerSpaceRadius: 40,
            sectionsSpace: 2,
            sections: [
              PieChartSectionData(
                value: (data.todo ?? 0).toDouble(),
                color: Color(0xffffd96a),
                radius: 52,
                showTitle: false,
              ),

              PieChartSectionData(
                value: (data.in_progress ?? 0).toDouble(),
                color: Color(0xff69CDB5),
                radius: 52,
                showTitle: false,
              ),

              PieChartSectionData(
                value: (data.done ?? 0).toDouble(),
                color: Color(0xff4FA4D8),
                radius: 52,
                showTitle: false,
              ),

              PieChartSectionData(
                value: (data.review ?? 0).toDouble(),
                color: Color(0xffff7777),
                radius: 52,
                showTitle: false,
              ),
            ],
          ),
        ),

        Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              '${data.total_tasks ?? 0}',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Color(0xff102A43),
              ),
            ),

            Text(
              "Total Tasks",
              style: TextStyle(fontSize: 11, color: Color(0xff718096)),
            ),
          ],
        ),
      ],
    );
  }

  Widget _statusRow({
    required Color color,
    required String title,
    required int? value,
    required int? total,
  }) {
    final count = value ?? 0;
    final all = total ?? 0;
    final percent = all == 0 ? 0 : ((count / all) * 100).round();

    return Row(
      children: [
        Container(
          width: 12,
          height: 12,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),

        Gap(8),

        Expanded(
          child: Text(
            title,
            style: TextStyle(fontSize: 13, color: Color(0xff34495E)),
          ),
        ),

        Text(
          '$count',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Color(0xff102A43),
          ),
        ),

        Gap(8),

        SizedBox(
          width: 38,
          child: Text(
            '$percent%',
            textAlign: TextAlign.right,
            style: TextStyle(color: Color(0xff58708D), fontSize: 12),
          ),
        ),
      ],
    );
  }

  // PRIORITY TASKS

  Widget _buildPriorityTasks(dynamic data) {
    return _sectionContainer(
      title: "Priority Tasks",
      child: Column(
        children: [
          _priorityItem(
            title: "Overdue Projects",
            value: data.overdue.toString(),
            icon: Icons.warning_amber_rounded,
            color: Color(0xffffeeee),
            iconColor: Colors.redAccent,
            label: "High",
          ),

          Gap(10),

          _priorityItem(
            title: "High Priority Tasks",
            value: data.high_priority.toString(),
            icon: Icons.priority_high,
            color: Color(0xffEAF3FF),
            iconColor: Color(0xff1976D2),
            label: "High",
          ),
        ],
      ),
    );
  }

  Widget _priorityItem({
    required String title,
    required String value,
    required IconData icon,
    required Color color,
    required Color iconColor,
    required String label,
  }) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12, vertical: 13),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(15),
      ),
      child: Row(
        children: [
          CircleAvatar(
            backgroundColor: Colors.white,
            child: Icon(icon, color: iconColor),
          ),

          Gap(12),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                ),

                Gap(3),

                Text(
                  "$value tasks",
                  style: TextStyle(fontSize: 12, color: Color(0xff718096)),
                ),
              ],
            ),
          ),

          Container(
            padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(.7),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              label,
              style: TextStyle(
                color: iconColor,
                fontWeight: FontWeight.w600,
                fontSize: 12,
              ),
            ),
          ),

          Gap(5),

          Icon(Icons.chevron_right, color: Color(0xff58708D)),
        ],
      ),
    );
  }

  // RECENT ACTIVITY

  Widget _buildRecentActivity(List<RecentActivityEntity> activities) {
    return _sectionContainer(
      title: "Recent Activity",
      child: activities.isEmpty
          ? Padding(
              padding: EdgeInsets.symmetric(vertical: 12),
              child: Text(
                "No recent activity",
                style: TextStyle(fontSize: 13, color: Color(0xff718096)),
              ),
            )
          : Column(
              children: [
                for (var i = 0; i < activities.length; i++) ...[
                  if (i > 0) const Gap(17),
                  _activityItemFromEntity(activities[i]),
                ],
              ],
            ),
    );
  }

  Widget _activityItemFromEntity(RecentActivityEntity activity) {
    return _activityItem(
      icon: _activityIcon(activity),
      title: activity.title,
      subtitle: activity.subtitle,
      time: _timeAgo(activity.time),
    );
  }

  IconData _activityIcon(RecentActivityEntity activity) {
    switch (activity.type) {
      case 'user':
        return Icons.person;
      case 'project':
        return Icons.folder;
      case 'task':
        return activity.title.contains('completed')
            ? Icons.check_circle
            : Icons.task_alt;
      default:
        return Icons.notifications;
    }
  }

  String _timeAgo(DateTime time) {
    final local = time.toLocal();
    final diff = DateTime.now().difference(local);
    if (diff.inMinutes < 1) return 'now';
    if (diff.inMinutes < 60) return '${diff.inMinutes}m';
    if (diff.inHours < 24) return '${diff.inHours}h';
    if (diff.inDays < 7) return '${diff.inDays}d';
    return '${local.day}/${local.month}/${local.year}';
  }

  Widget _activityItem({
    required IconData icon,
    required String title,
    required String subtitle,
    required String time,
  }) {
    return Padding(
      padding: EdgeInsets.only(bottom: 17),
      child: Row(
        children: [
          CircleAvatar(
            radius: 20,
            backgroundColor: Color(0xffEAF3FF),
            child: Icon(icon, color: Color(0xff1976D2), size: 20),
          ),

          Gap(12),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                ),

                Gap(3),

                Text(
                  subtitle,
                  style: TextStyle(fontSize: 12, color: Color(0xff718096)),
                ),
              ],
            ),
          ),

          Text(time, style: TextStyle(fontSize: 11, color: Color(0xff718096))),
        ],
      ),
    );
  }

  // SECTION CONTAINER

  Widget _sectionContainer({required String title, required Widget child}) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(22),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(.04),
            blurRadius: 15,
            offset: Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: 21,
              fontWeight: FontWeight.bold,
              color: Color(0xff102A43),
            ),
          ),

          Gap(18),

          child,
        ],
      ),
    );
  }
}
