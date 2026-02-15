import 'package:flutter/material.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:walletfox/model/subscription_model.dart';
import 'package:walletfox/utils/styles/app_theme.dart';

class NotificationListCard extends StatelessWidget {
  final SubscriptionModel sub;
  const NotificationListCard({super.key, required this.sub});

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    final daysLeft = sub.nextBillingDate.difference(now).inDays;
    Color badgeColor;
    if(daysLeft <= 1) {
      badgeColor = Colors.red;
    } else if (daysLeft <= 3) {
      badgeColor = Colors.yellow;
    } else {
      badgeColor = Colors.green;
    }
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      // margin: const EdgeInsets.symmetric(vertical: 8),
      child: Padding(padding: const EdgeInsets.all(16.0), child: Row(
        children: [
          CircleAvatar(
            radius: 22,
            backgroundColor: AppColors.blue.withOpacity(0.3),
            child: PhosphorIcon(Icons.notifications, color: AppColors.blue,),
          ),
          Expanded(child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(sub.name, style: Theme.of(context).textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.bold),)
            ],
          )
          ),

          Container(
            padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 12),
            decoration: BoxDecoration(
              color: badgeColor.withOpacity(0.3),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              "Renews in $daysLeft days",
              style: Theme.of(context).textTheme.bodySmall?.copyWith(color: badgeColor),
            ),
          )
        ],
      ),)
    );
  }
}