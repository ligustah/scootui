import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:scooter_cluster/services/task_service.dart';

class TaskProgressIndicator extends StatelessWidget {
  const TaskProgressIndicator({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<(Task, TaskStatus)>>(
      stream: context.read<TaskService>().stream,
      initialData: context.read<TaskService>().tasks,
      builder: (context, snapshot) {
        final tasks = snapshot.data ?? [];
        if (tasks.isEmpty) {
          return const SizedBox.shrink();
        }

        final runningTasks = tasks.whereType<(Task, TaskRunning)>().toList();
        final progress = runningTasks.isEmpty
            ? 0.0
            : runningTasks.fold<double>(0.0,
                    (prev, element) => prev + (element.$2.progress ?? 0.0)) /
                runningTasks.length;

        return SizedBox(
          width: 40,
          height: 40,
          child: Stack(
            alignment: Alignment.center,
            children: [
              CircularProgressIndicator(
                value: progress,
                strokeWidth: 3.0,
                backgroundColor: Colors.grey.withOpacity(0.5),
              ),
              Text(
                '${tasks.length}',
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
