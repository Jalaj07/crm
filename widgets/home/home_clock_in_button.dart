import 'package:flutter/material.dart';
import 'package:flutter_development/theme/central_app_theme_color.dart';

class ClockInButton extends StatefulWidget {
  final VoidCallback onPressed;
  final bool isLoading;
  final bool isClockIn;
  final bool isActive;
  final bool isSuccess;

  const ClockInButton({
    super.key,
    required this.onPressed,
    required this.isLoading,
    required this.isClockIn,
    this.isActive = true,
    required this.isSuccess,
  });

  @override
  State<ClockInButton> createState() => _ClockInButtonState();
}

class _ClockInButtonState extends State<ClockInButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late Animation<double> _shineAnimation;
  Color? _primaryColor;
  Color? _inactiveColor;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );

    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 0.95,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));

    _shineAnimation = Tween<double>(begin: -1.0, end: 2.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.0, 0.5, curve: Curves.easeInOut),
      ),
    );
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _primaryColor = Theme.of(context).primaryColor;
    _inactiveColor = Colors.grey[400];
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _handleTap() {
    if (!widget.isLoading && widget.isActive) {
      _controller.forward().then((_) {
        if (mounted) {
          widget.onPressed();
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    Theme.of(context);
    final theme = Theme.of(context); // Get theme
    final statusColors = theme.extension<StatusColors>(); // Get extension
    final Color successColor = statusColors?.approved ?? Colors.green;
    final Color currentInactiveColor =
        widget.isActive ? _primaryColor! : _inactiveColor!;

    final currentColor =
        widget.isSuccess
            ? Colors.green
            : (widget.isActive ? _primaryColor : _inactiveColor);
    widget.isSuccess ? successColor : currentInactiveColor;
    return GestureDetector(
      onTapDown: (_) => _controller.forward(),
      onTapUp: (_) => _controller.reverse(),
      onTapCancel: () => _controller.reverse(),
      onTap: _handleTap,
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          return Transform.scale(
            scale: _scaleAnimation.value,
            child: Container(
              width: double.infinity,
              height: 50,
              decoration: BoxDecoration(
                color: currentColor,
                borderRadius: BorderRadius.circular(8),
                boxShadow: [
                  BoxShadow(
                    color: currentColor!.withAlpha(255),
                    blurRadius: 0,
                    spreadRadius: 2,
                  ),
                ],
              ),
              child: Stack(
                children: [
                  // Shine effect
                  Positioned.fill(
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: CustomPaint(
                        painter: ShinePainter(
                          progress: _shineAnimation.value,
                          color: Colors.white.withAlpha(255),
                        ),
                      ),
                    ),
                  ),
                  // Content
                  Center(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        if (widget.isLoading)
                          const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              valueColor: AlwaysStoppedAnimation<Color>(
                                Colors.white,
                              ),
                            ),
                          )
                        else
                          Icon(
                            widget.isSuccess
                                ? Icons.check
                                : widget.isClockIn
                                ? Icons.login_rounded
                                : Icons.logout_rounded,
                            color:
                                theme.elevatedButtonTheme.style?.foregroundColor
                                    ?.resolve({}) ??
                                (ThemeData.estimateBrightnessForColor(
                                          currentColor,
                                        ) ==
                                        Brightness.dark
                                    ? Colors.white
                                    : Colors.black),
                            size: 20,
                          ),
                        const SizedBox(width: 8),
                        Text(
                          widget.isSuccess
                              ? (widget.isClockIn
                                  ? 'Clocked In'
                                  : 'Clocked Out')
                              : (widget.isClockIn ? 'Clock In' : 'Clock Out'),
                          style: theme.elevatedButtonTheme.style?.textStyle
                              ?.resolve({})
                              ?.copyWith(
                                color:
                                    theme
                                        .elevatedButtonTheme
                                        .style
                                        ?.foregroundColor
                                        ?.resolve({}) ??
                                    (ThemeData.estimateBrightnessForColor(
                                              currentColor,
                                            ) ==
                                            Brightness.dark
                                        ? Colors.white
                                        : Colors.black),
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                              ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

class ShinePainter extends CustomPainter {
  final double progress;
  final Color color;

  ShinePainter({required this.progress, required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint =
        Paint()
          ..color = color
          ..style = PaintingStyle.fill;

    final path =
        Path()
          ..moveTo(progress * size.width, 0)
          ..lineTo(progress * size.width + size.width * 0.3, 0)
          ..lineTo(progress * size.width, size.height)
          ..lineTo(progress * size.width - size.width * 0.3, size.height)
          ..close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(ShinePainter oldDelegate) {
    return oldDelegate.progress != progress || oldDelegate.color != color;
  }
}
