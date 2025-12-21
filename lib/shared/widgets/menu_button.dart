import 'package:flutter/material.dart';
import '../../core/services/audio_service.dart';

class MenuButton extends StatefulWidget {
  final IconData icon;
  final String label;
  final VoidCallback onPressed;
  final Color? color;
  final bool isPrimary;

  const MenuButton({
    super.key,
    required this.icon,
    required this.label,
    required this.onPressed,
    this.color,
    this.isPrimary = true,
  });

  @override
  State<MenuButton> createState() => _MenuButtonState();
}

class _MenuButtonState extends State<MenuButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  bool _isPressed = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 100),
      vsync: this,
    );

    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.95).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _handleTapDown(TapDownDetails details) {
    setState(() => _isPressed = true);
    _controller.forward();
  }

  void _handleTapUp(TapUpDetails details) {
    setState(() => _isPressed = false);
    _controller.reverse();
  }

  void _handleTapCancel() {
    setState(() => _isPressed = false);
    _controller.reverse();
  }

  @override
  Widget build(BuildContext context) {
    final buttonColor = widget.color ??
        (widget.isPrimary ? Colors.amber : Colors.white.withOpacity(0.2));
    final textColor =
        widget.isPrimary ? Colors.black87 : Colors.white.withOpacity(0.9);

    return GestureDetector(
      onTapDown: _handleTapDown,
      onTapUp: _handleTapUp,
      onTapCancel: _handleTapCancel,
      onTap: () {
        // Play click sound
        AudioService().playSfx('click.wav');
        widget.onPressed();
      },
      child: ScaleTransition(
        scale: _scaleAnimation,
        child: Container(
          width: double.infinity,
          height: 60,
          decoration: BoxDecoration(
            gradient: widget.isPrimary
                ? LinearGradient(
                    colors: [
                      buttonColor,
                      buttonColor.withOpacity(0.8),
                    ],
                  )
                : null,
            color: widget.isPrimary ? null : buttonColor,
            borderRadius: BorderRadius.circular(16),
            border: widget.isPrimary
                ? null
                : Border.all(
                    color: Colors.white.withOpacity(0.3),
                    width: 2,
                  ),
            boxShadow: [
              BoxShadow(
                color: _isPressed
                    ? buttonColor.withOpacity(0.3)
                    : buttonColor.withOpacity(0.5),
                blurRadius: _isPressed ? 10 : 20,
                offset: Offset(0, _isPressed ? 2 : 8),
              ),
            ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                widget.icon,
                color: textColor,
                size: 28,
              ),
              const SizedBox(width: 12),
              Text(
                widget.label,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: textColor,
                  shadows: widget.isPrimary
                      ? null
                      : const [
                          Shadow(
                            color: Colors.black54,
                            offset: Offset(1, 1),
                            blurRadius: 2,
                          ),
                        ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
