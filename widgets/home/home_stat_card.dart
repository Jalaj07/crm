import 'package:flutter/material.dart';

// Constants specific to StatCard
const EdgeInsets _statCardPadding = EdgeInsets.all(12.0);
const SizedBox _spacingW12 = SizedBox(width: 10);
const SizedBox _spacingH4 = SizedBox(height: 3);

class StatCard extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;
  final Color color;
  final String? subtitle; // Optional subtitle

  const StatCard({
    super.key,
    required this.title,
    required this.value,
    required this.icon,
    required this.color,
    this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final cardTheme = Theme.of(context).cardTheme;
    final Color bgColor = Theme.of(context).colorScheme.surface;

    return Card(
      elevation: cardTheme.elevation ?? 3,
      shape:
          cardTheme.shape ??
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      margin: cardTheme.margin ?? EdgeInsets.zero,
      shadowColor: Theme.of(context).colorScheme.shadow,
      color: bgColor,
      child: Padding(
        padding: _statCardPadding,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Icon in colored circle
            Container(
              decoration: BoxDecoration(
                color: color.withAlpha(46),
                shape: BoxShape.circle,
              ),
              padding: const EdgeInsets.all(7),
              child: Icon(
                icon,
                color: color,
                size: Theme.of(context).iconTheme.size ?? 22,
              ),
            ),
            _spacingW12,
            // Texts
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    title,
                    style: textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                  ),
                  _spacingH4,
                  Text(
                    value,
                    style: textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: color,
                      fontSize: 18,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  if (subtitle != null) ...[
                    _spacingH4,
                    Text(
                      subtitle!,
                      style: textTheme.bodySmall?.copyWith(
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                        fontWeight: FontWeight.w400,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
