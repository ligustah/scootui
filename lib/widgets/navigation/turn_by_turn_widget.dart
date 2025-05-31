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
      case Roundabout(side: final side, exitNumber: final exitNumber):
        // Handle roundabout with custom widget below
        return _buildRoundaboutIcon(side, exitNumber, size);
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
    // Use Valhalla's instruction text if available
    if (instruction.instructionText?.isNotEmpty == true) {
      return instruction.instructionText!;
    }

    // Generate instruction text with street name if available
    return switch (instruction) {
      Keep(direction: final direction, streetName: final streetName) => switch (direction) {
          KeepDirection.straight => streetName != null ? 'Continue straight on $streetName' : 'Continue straight',
          _ => streetName != null ? 'Keep ${direction.name} on $streetName' : 'Keep ${direction.name}',
        },
      Turn(direction: final direction, streetName: final streetName) => switch (direction) {
          TurnDirection.left => streetName != null ? 'Turn left onto $streetName' : 'Turn left',
          TurnDirection.right => streetName != null ? 'Turn right onto $streetName' : 'Turn right',
          TurnDirection.slightLeft => streetName != null ? 'Turn slightly left onto $streetName' : 'Turn slightly left',
          TurnDirection.slightRight => streetName != null ? 'Turn slightly right onto $streetName' : 'Turn slightly right',
          TurnDirection.sharpLeft => streetName != null ? 'Turn sharply left onto $streetName' : 'Turn sharply left',
          TurnDirection.sharpRight => streetName != null ? 'Turn sharply right onto $streetName' : 'Turn sharply right',
          TurnDirection.uTurn180 => 'Turn 180 degrees',
          TurnDirection.rightUTurn => 'Perform right u-turn',
          TurnDirection.uTurn => 'Perform u-turn',
        },
      Roundabout(exitNumber: final exitNumber, streetName: final streetName) =>
        streetName != null 
          ? 'In the roundabout, take the ${exitNumber == 1 ? '1st' : exitNumber == 2 ? '2nd' : exitNumber == 3 ? '3rd' : '${exitNumber}th'} exit onto $streetName'
          : 'In the roundabout, take the ${exitNumber == 1 ? '1st' : exitNumber == 2 ? '2nd' : exitNumber == 3 ? '3rd' : '${exitNumber}th'} exit',
      Other(streetName: final streetName) => streetName != null ? 'Continue on $streetName' : 'Continue',
      Exit(side: final side, streetName: final streetName) => 
        streetName != null ? 'Take the ${side.name} exit to $streetName' : 'Take the ${side.name} exit',
    };
  }

  Widget _buildRoundaboutIcon(RoundaboutSide side, int exitNumber, double size) {
    // Use appropriate directional icon based on side
    final IconData roundaboutIcon = side == RoundaboutSide.left 
        ? Icons.roundabout_left 
        : Icons.roundabout_right;
    
    return SizedBox(
      width: size,
      height: size,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Icon(
            roundaboutIcon,
            color: Colors.white,
            size: size,
          ),
          Container(
            width: size * 0.35,
            height: size * 0.35,
            decoration: BoxDecoration(
              color: Colors.blue,
              shape: BoxShape.circle,
              border: Border.all(color: Colors.white, width: 1.5),
            ),
            child: Center(
              child: Text(
                exitNumber.toString(),
                style: TextStyle(
                  color: Colors.white,
                  fontSize: size * 0.2,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
