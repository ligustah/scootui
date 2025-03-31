import 'package:flutter/material.dart';

class PowerDisplay extends StatefulWidget {
  final double powerOutput;
  final double maxRegenPower; 
  final double maxDischargePower;

  const PowerDisplay({
    super.key,
    required this.powerOutput,
    this.maxRegenPower = 1.0, // 1kW max regen
    this.maxDischargePower = 4.0, // 4kW max discharge
  });

  @override
  State<PowerDisplay> createState() => _PowerDisplayState();
}

class _PowerDisplayState extends State<PowerDisplay> with SingleTickerProviderStateMixin {
  late AnimationController _powerController;
  late Animation<double> _powerAnimation;
  double _lastPowerKW = 0.0;

  @override
  void initState() {
    super.initState();
    _powerController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );
    _powerAnimation = Tween<double>(
      begin: 0,
      end: 0,
    ).animate(
      CurvedAnimation(
        parent: _powerController,
        curve: Curves.easeOutCubic,
      ),
    );
    _lastPowerKW = widget.powerOutput / 1000;
  }

  @override
  void dispose() {
    _powerController.dispose();
    super.dispose();
  }

  @override
  void didUpdateWidget(PowerDisplay oldWidget) {
    super.didUpdateWidget(oldWidget);
    
    final newPowerKW = widget.powerOutput / 1000;
    
    // Only animate if power has changed significantly
    if ((newPowerKW - _lastPowerKW).abs() > 0.01) {
      _powerAnimation = Tween<double>(
        begin: _lastPowerKW,
        end: newPowerKW,
      ).animate(
        CurvedAnimation(
          parent: _powerController,
          curve: Curves.easeOutCubic,
        ),
      );
      
      _powerController.forward(from: 0.0);
      _lastPowerKW = newPowerKW;
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    
    return AnimatedBuilder(
      animation: _powerAnimation,
      builder: (context, child) {
        final powerKW = _powerAnimation.value;
        final isRegenerating = powerKW < 0;
        final absKW = powerKW.abs();
        
        // Calculate width factor based on power direction
        final maxPower = isRegenerating ? widget.maxRegenPower : widget.maxDischargePower;
        final progress = (absKW / maxPower).clamp(0.0, 1.0);

        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Labels
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'REGEN',
                    style: TextStyle(
                      fontSize: 12,
                      color: isDark ? Colors.white70 : Colors.black54,
                    ),
                  ),
                  Text(
                    'DISCHARGE',
                    style: TextStyle(
                      fontSize: 12,
                      color: isDark ? Colors.white70 : Colors.black54,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 4),

            // Power bar container
            SizedBox(
              height: 4,
              child: LayoutBuilder(
                builder: (context, constraints) {
                  final totalWidth = constraints.maxWidth;
                  final barWidth = totalWidth * progress * 0.5; // Half width for each direction

                  return Stack(
                    alignment: Alignment.center,
                    children: [
                      // Background bar
                      Container(
                        height: 4,
                        width: totalWidth,
                        decoration: BoxDecoration(
                          color: isDark ? Colors.grey.shade800 : Colors.grey.shade200,
                          borderRadius: BorderRadius.circular(2),
                        ),
                      ),

                      // Power indicator
                      AnimatedPositioned(
                        duration: const Duration(milliseconds: 300),
                        curve: Curves.easeOutCubic,
                        left: isRegenerating ? (totalWidth / 2) - barWidth : totalWidth / 2,
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 300),
                          curve: Curves.easeOutCubic,
                          height: 4,
                          width: barWidth,
                          decoration: BoxDecoration(
                            color: isRegenerating ? Colors.red : Colors.blue,
                            borderRadius: BorderRadius.circular(2),
                          ),
                        ),
                      ),

                      // Center marker
                      Container(
                        width: 2,
                        height: 8,
                        decoration: BoxDecoration(
                          color: isDark ? Colors.white30 : Colors.black26,
                          borderRadius: BorderRadius.circular(1),
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),
            const SizedBox(height: 4),

            // Power value with animated text
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TweenAnimationBuilder<double>(
                    duration: const Duration(milliseconds: 500),
                    curve: Curves.easeOutCubic,
                    tween: Tween<double>(
                      begin: _lastPowerKW.abs(),
                      end: absKW,
                    ),
                    builder: (context, value, child) {
                      return Text(
                        '${value.toStringAsFixed(1)} kW',
                        style: TextStyle(
                          fontSize: 12,
                          color: isDark ? Colors.white70 : Colors.black54,
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }
}