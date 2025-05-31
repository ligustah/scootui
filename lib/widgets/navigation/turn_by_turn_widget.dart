import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../cubits/navigation_cubit.dart';
import '../../cubits/navigation_state.dart';
import '../../routing/models.dart';

class TurnByTurnWidget extends StatelessWidget {
  final bool compact;
  final EdgeInsets? padding;

  const TurnByTurnWidget({
    super.key,
    this.compact = false,
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<NavigationCubit, NavigationState>(
      builder: (context, state) {
        if (!state.hasInstructions || state.status == NavigationStatus.idle) {
          return const SizedBox.shrink();
        }

        return Container(
          padding: padding ?? const EdgeInsets.all(8.0),
          decoration: BoxDecoration(
            color: Colors.black.withOpacity(0.8),
            borderRadius: BorderRadius.circular(8.0),
          ),
          child: compact ? _buildCompactView(state) : _buildFullView(state),
        );
      },
    );
  }

  Widget _buildCompactView(NavigationState state) {
    final instruction = state.nextInstruction;
    if (instruction == null) return const SizedBox.shrink();

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        _buildInstructionIcon(instruction, size: 24),
        const SizedBox(width: 8),
        Flexible(
          child: Text(
            _formatDistance(instruction.distance),
            style: const TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }

  Widget _buildFullView(NavigationState state) {
    final instruction = state.nextInstruction;
    if (instruction == null) return const SizedBox.shrink();

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            _buildInstructionIcon(instruction, size: 48),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    _formatDistance(instruction.distance),
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      height: 1.1,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    _getInstructionText(instruction),
                    style: const TextStyle(
                      color: Colors.white70,
                      fontSize: 14,
                      height: 1.1,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        if (state.status == NavigationStatus.rerouting) ...[
          const SizedBox(height: 8),
          const Row(
            children: [
              SizedBox(
                width: 16,
                height: 16,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.orange),
                ),
              ),
              SizedBox(width: 8),
              Text(
                'Recalculating route...',
                style: TextStyle(
                  color: Colors.orange,
                  fontSize: 12,
                ),
              ),
            ],
          ),
        ],
        if (state.isOffRoute) ...[
          const SizedBox(height: 8),
          const Row(
            children: [
              Icon(
                Icons.warning,
                color: Colors.orange,
                size: 16,
              ),
              SizedBox(width: 8),
              Text(
                'Off route',
                style: TextStyle(
                  color: Colors.orange,
                  fontSize: 12,
                ),
              ),
            ],
          ),
        ],
      ],
    );
  }

  Widget _buildInstructionIcon(RouteInstruction instruction, {required double size}) {
    IconData iconData;
    Color iconColor = Colors.white;

    switch (instruction) {
      case Keep(direction: final direction):
        iconData = switch (direction) {
          KeepDirection.straight => Icons.straight,
          KeepDirection.left => Icons.turn_slight_left,
          KeepDirection.right => Icons.turn_slight_right,
        };
        break;
      case Turn(direction: final direction):
        iconData = switch (direction) {
          TurnDirection.left => Icons.turn_left,
          TurnDirection.right => Icons.turn_right,
          TurnDirection.slightLeft => Icons.turn_slight_left,
          TurnDirection.slightRight => Icons.turn_slight_right,
          TurnDirection.sharpLeft => Icons.turn_sharp_left,
          TurnDirection.sharpRight => Icons.turn_sharp_right,
          TurnDirection.uTurn180 || TurnDirection.uTurn => Icons.u_turn_left,
          TurnDirection.rightUTurn => Icons.u_turn_right,
        };
        break;
      case Roundabout():
        iconData = Icons.roundabout_left;
        break;
      case Exit(side: final side):
        iconData = side == ExitSide.left ? Icons.exit_to_app : Icons.exit_to_app;
        break;
      case Other():
        iconData = Icons.navigation;
        break;
    }

    return Icon(
      iconData,
      color: iconColor,
      size: size,
    );
  }

  String _formatDistance(double distance) {
    if (distance > 500) {
      return '${((((distance + 99) ~/ 100) * 100) / 1000).toStringAsFixed(1)} km';
    } else if (distance > 100) {
      return '${(((distance + 99) ~/ 100) * 100)} m';
    } else if (distance > 10) {
      return '${(((distance + 9) ~/ 10) * 10)} m';
    } else {
      return '${distance.toInt()} m';
    }
  }

  String _getInstructionText(RouteInstruction instruction) {
    return switch (instruction) {
      Keep(direction: final direction) => switch (direction) {
          KeepDirection.straight => 'Continue straight',
          _ => 'Keep ${direction.name}',
        },
      Turn(direction: final direction) => switch (direction) {
          TurnDirection.left => 'Turn left',
          TurnDirection.right => 'Turn right',
          TurnDirection.slightLeft => 'Turn slightly left',
          TurnDirection.slightRight => 'Turn slightly right',
          TurnDirection.sharpLeft => 'Turn sharply left',
          TurnDirection.sharpRight => 'Turn sharply right',
          TurnDirection.uTurn180 => 'Turn 180 degrees',
          TurnDirection.rightUTurn => 'Perform right u-turn',
          TurnDirection.uTurn => 'Perform u-turn',
        },
      Roundabout(side: final side, exitNumber: final exitNumber) =>
        'In the roundabout, take the ${side.name} exit $exitNumber',
      Other() => 'Continue',
      Exit(side: final side) => 'Take the ${side.name} exit',
    };
  }
}
