import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';

class DailyQuestPreview extends StatefulWidget {
  const DailyQuestPreview({super.key});

  @override
  State<DailyQuestPreview> createState() => _DailyQuestPreviewState();
}

class _DailyQuestPreviewState extends State<DailyQuestPreview>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _slideAnimation = Tween<double>(begin: 50.0, end: 0.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOut),
    );

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _slideAnimation,
      builder: (context, child) {
        return Transform.translate(
          offset: Offset(_slideAnimation.value, 0),
          child: child,
        );
      },
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Colors.deepPurple.withOpacity(0.3),
              Colors.purple.withOpacity(0.2),
            ],
          ),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: Colors.purple.withOpacity(0.5),
            width: 2,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.purple.withOpacity(0.3),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(
                    Icons.flag,
                    color: Colors.amber,
                    size: 20,
                  ),
                ),
                const SizedBox(width: 12),
                Text(
                  'daily_quests'.tr(),
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const Spacer(),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.amber,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    '2/3',
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            _QuestItem(
              icon: Icons.gamepad,
              title: 'play_1_game'.tr(),
              progress: 1,
              total: 1,
              isCompleted: true,
            ),
            const SizedBox(height: 8),
            _QuestItem(
              icon: Icons.emoji_events,
              title: 'defeat_5_enemies'.tr(),
              progress: 3,
              total: 5,
              isCompleted: false,
            ),
            const SizedBox(height: 8),
            _QuestItem(
              icon: Icons.star,
              title: 'collect_100_gold'.tr(),
              progress: 100,
              total: 100,
              isCompleted: true,
            ),
          ],
        ),
      ),
    );
  }
}

class _QuestItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final int progress;
  final int total;
  final bool isCompleted;

  const _QuestItem({
    required this.icon,
    required this.title,
    required this.progress,
    required this.total,
    required this.isCompleted,
  });

  @override
  Widget build(BuildContext context) {
    final progressPercent = progress / total;

    return Row(
      children: [
        Icon(
          icon,
          size: 18,
          color: isCompleted ? Colors.green : Colors.white70,
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(
                  fontSize: 13,
                  color: isCompleted ? Colors.green : Colors.white70,
                  decoration:
                      isCompleted ? TextDecoration.lineThrough : null,
                ),
              ),
              const SizedBox(height: 4),
              Container(
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(2),
                ),
                child: FractionallySizedBox(
                  alignment: Alignment.centerLeft,
                  widthFactor: progressPercent,
                  child: Container(
                    decoration: BoxDecoration(
                      color: isCompleted ? Colors.green : Colors.amber,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(width: 8),
        Text(
          '$progress/$total',
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.bold,
            color: isCompleted ? Colors.green : Colors.white70,
          ),
        ),
        if (isCompleted) ..[
          const SizedBox(width: 4),
          const Icon(
            Icons.check_circle,
            size: 18,
            color: Colors.green,
          ),
        ],
      ],
    );
  }
}
