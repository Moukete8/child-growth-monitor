import 'package:flutter/material.dart';
import '../tokens/app_colors.dart';

/// Shared visual shell for "icon box + title + subtitle (+ trailing)" rows,
/// reused by NotificationTile, ActivityTile, AlertTile and ReportTile.
class _IconRowCard extends StatelessWidget {
  const _IconRowCard({
    required this.icon,
    required this.iconBg,
    required this.iconColor,
    required this.title,
    required this.subtitle,
    this.footer,
    this.onTap,
    this.unreadDot = false,
  });

  final IconData icon;
  final Color iconBg;
  final Color iconColor;
  final String title;
  final String subtitle;
  final Widget? footer;
  final VoidCallback? onTap;
  final bool unreadDot;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.surface,
      borderRadius: BorderRadius.circular(15),
      child: InkWell(
        borderRadius: BorderRadius.circular(15),
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            border: Border.all(color: AppColors.border),
            borderRadius: BorderRadius.circular(15),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 42,
                height: 42,
                decoration: BoxDecoration(color: iconBg, borderRadius: BorderRadius.circular(12)),
                alignment: Alignment.center,
                child: Icon(icon, color: iconColor, size: 21),
              ),
              const SizedBox(width: 13),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(title,
                              style: TextStyle(
                                  fontSize: 14.5, fontWeight: FontWeight.w700, color: AppColors.textPrimary)),
                        ),
                        if (unreadDot)
                          Container(
                            width: 7,
                            height: 7,
                            margin: const EdgeInsets.only(left: 8),
                            decoration: const BoxDecoration(
                                color: AppColors.parentPrimary, shape: BoxShape.circle),
                          ),
                      ],
                    ),
                    const SizedBox(height: 3),
                    Text(subtitle,
                        style: const TextStyle(fontSize: 12.5, color: Color(0xFF6A7C84))),
                    if (footer != null) ...[const SizedBox(height: 6), footer!],
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

class NotificationTile extends StatelessWidget {
  const NotificationTile({
    super.key,
    required this.icon,
    required this.iconBg,
    required this.iconColor,
    required this.title,
    required this.body,
    required this.time,
    required this.unread,
    this.onTap,
  });

  final IconData icon;
  final Color iconBg;
  final Color iconColor;
  final String title;
  final String body;
  final String time;
  final bool unread;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return _IconRowCard(
      icon: icon,
      iconBg: iconBg,
      iconColor: iconColor,
      title: title,
      subtitle: body,
      unreadDot: unread,
      onTap: onTap,
      footer: Text(time, style: TextStyle(fontSize: 11, color: AppColors.textFaint)),
    );
  }
}

class ActivityTile extends StatelessWidget {
  const ActivityTile({
    super.key,
    required this.icon,
    required this.iconBg,
    required this.iconColor,
    required this.name,
    required this.text,
    required this.time,
  });

  final IconData icon;
  final Color iconBg;
  final Color iconColor;
  final String name;
  final String text;
  final String time;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 13),
      child: Row(
        children: [
          Container(
            width: 38,
            height: 38,
            decoration: BoxDecoration(color: iconBg, borderRadius: BorderRadius.circular(11)),
            alignment: Alignment.center,
            child: Icon(icon, size: 19, color: iconColor),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(name,
                    style: TextStyle(
                        fontSize: 13.5, fontWeight: FontWeight.w600, color: AppColors.textPrimary)),
                const SizedBox(height: 1),
                Text(text, style: TextStyle(fontSize: 12, color: AppColors.textMuted)),
              ],
            ),
          ),
          Text(time, style: TextStyle(fontSize: 11, color: AppColors.textFaint)),
        ],
      ),
    );
  }
}

class AlertTile extends StatelessWidget {
  const AlertTile({
    super.key,
    required this.icon,
    required this.level,
    required this.name,
    required this.text,
    required this.time,
    required this.resolved,
    this.onOpen,
    this.onResolve,
  });

  final IconData icon;
  final RiskLevel level;
  final String name;
  final String text;
  final String time;
  final bool resolved;
  final VoidCallback? onOpen;
  final VoidCallback? onResolve;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.surface,
        border: Border.all(color: AppColors.border),
        borderRadius: BorderRadius.circular(15),
      ),
      child: Row(
        children: [
          Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(color: level.backgroundColor, borderRadius: BorderRadius.circular(12)),
            alignment: Alignment.center,
            child: Icon(icon, size: 22, color: level.dotColor),
          ),
          const SizedBox(width: 13),
          Expanded(
            child: InkWell(
              onTap: onOpen,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(name,
                      style: TextStyle(
                          fontSize: 14.5, fontWeight: FontWeight.w700, color: AppColors.textPrimary)),
                  const SizedBox(height: 2),
                  Text(text, style: const TextStyle(fontSize: 12.5, color: Color(0xFF6A7C84))),
                  const SizedBox(height: 5),
                  Text(time, style: TextStyle(fontSize: 11, color: AppColors.textFaint)),
                ],
              ),
            ),
          ),
          if (resolved)
            const Icon(Icons.check_circle, color: AppColors.riskNormalDot, size: 24)
          else
            InkWell(
              onTap: onResolve,
              borderRadius: BorderRadius.circular(10),
              child: Container(
                width: 38,
                height: 38,
                decoration: BoxDecoration(
                  border: Border.all(color: AppColors.border),
                  color: const Color(0xFFF7FAFB),
                  borderRadius: BorderRadius.circular(10),
                ),
                alignment: Alignment.center,
                child: const Icon(Icons.done, size: 20, color: AppColors.riskNormalDot),
              ),
            ),
        ],
      ),
    );
  }
}

class ReportTile extends StatelessWidget {
  const ReportTile({
    super.key,
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.brand,
    this.onGeneratePdf,
    this.onExport,
    this.onShare,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final Color brand;
  final VoidCallback? onGeneratePdf;
  final VoidCallback? onExport;
  final VoidCallback? onShare;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: AppColors.surface,
        border: Border.all(color: AppColors.border),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 42,
                height: 42,
                decoration: BoxDecoration(color: AppColors.nurseInfoBg, borderRadius: BorderRadius.circular(12)),
                alignment: Alignment.center,
                child: Icon(icon, size: 22, color: brand),
              ),
              const SizedBox(width: 13),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(title,
                        style: TextStyle(
                            fontSize: 14.5, fontWeight: FontWeight.w700, color: AppColors.textPrimary)),
                    const SizedBox(height: 2),
                    Text(subtitle, style: TextStyle(fontSize: 12, color: AppColors.textMuted)),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 13),
          Row(
            children: [
              Expanded(
                child: _smallAction('PDF', Icons.picture_as_pdf_outlined, brand, Colors.white, onGeneratePdf, fill: brand),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _smallAction('Export', Icons.table_chart_outlined, AppColors.parentPrimary,
                    AppColors.textPrimary, onExport),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _smallAction('Share', Icons.share_outlined, AppColors.riskNormalDot,
                    AppColors.textPrimary, onShare),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _smallAction(String label, IconData icon, Color iconColor, Color textColor, VoidCallback? onTap,
      {Color? fill}) {
    return OutlinedButton(
      onPressed: onTap,
      style: OutlinedButton.styleFrom(
        backgroundColor: fill,
        side: fill == null ? BorderSide(color: AppColors.border) : BorderSide.none,
        padding: const EdgeInsets.symmetric(vertical: 10),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(11)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16, color: fill != null ? Colors.white : iconColor),
          const SizedBox(width: 5),
          Text(label,
              style: TextStyle(
                  fontSize: 12, fontWeight: FontWeight.w600, color: fill != null ? Colors.white : textColor)),
        ],
      ),
    );
  }
}
