import 'package:flutter/material.dart';
import 'dart:async';

class NotificationBanner extends StatefulWidget {
  final String message;
  final IconData icon;
  final Color? backgroundColor;
  final Duration duration;
  final VoidCallback? onTap;

  const NotificationBanner({
    super.key,
    required this.message,
    this.icon = Icons.info_outline,
    this.backgroundColor,
    this.duration = const Duration(seconds: 5),
    this.onTap,
  });

  @override
  State<NotificationBanner> createState() => _NotificationBannerState();
}

class _NotificationBannerState extends State<NotificationBanner>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Offset> _slideAnimation;
  Timer? _autoHideTimer;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, -1),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOut,
    ));

    _controller.forward();

    // Auto hide after duration
    _autoHideTimer = Timer(widget.duration, () {
      _hide();
    });
  }

  void _hide() {
    if (mounted) {
      _controller.reverse().then((_) {
        if (mounted) {
          // Remove from tree
        }
      });
    }
  }

  @override
  void dispose() {
    _autoHideTimer?.cancel();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SlideTransition(
      position: _slideAnimation,
      child: GestureDetector(
        onTap: widget.onTap,
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                widget.backgroundColor ?? Colors.deepPurple.withOpacity(0.9),
                (widget.backgroundColor ?? Colors.deepPurple)
                    .withOpacity(0.7),
              ],
            ),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: Colors.white.withOpacity(0.3),
              width: 1,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.3),
                blurRadius: 15,
                offset: const Offset(0, 5),
              ),
            ],
          ),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  widget.icon,
                  color: Colors.white,
                  size: 24,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  widget.message,
                  style: const TextStyle(
                    fontSize: 14,
                    color: Colors.white,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              IconButton(
                icon: const Icon(Icons.close, color: Colors.white70, size: 20),
                onPressed: _hide,
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Static method to show notification banner
class NotificationService {
  static OverlayEntry? _currentOverlay;

  static void show(
    BuildContext context, {
    required String message,
    IconData icon = Icons.info_outline,
    Color? backgroundColor,
    Duration duration = const Duration(seconds: 5),
    VoidCallback? onTap,
  }) {
    // Remove existing notification
    hide();

    final overlay = Overlay.of(context);
    _currentOverlay = OverlayEntry(
      builder: (context) => Positioned(
        top: MediaQuery.of(context).padding.top,
        left: 0,
        right: 0,
        child: NotificationBanner(
          message: message,
          icon: icon,
          backgroundColor: backgroundColor,
          duration: duration,
          onTap: onTap,
        ),
      ),
    );

    overlay.insert(_currentOverlay!);

    // Auto remove after duration + animation time
    Future.delayed(duration + const Duration(milliseconds: 500), () {
      hide();
    });
  }

  static void hide() {
    _currentOverlay?.remove();
    _currentOverlay = null;
  }
}
