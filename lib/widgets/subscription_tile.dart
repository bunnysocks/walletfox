import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:provider/provider.dart';
import 'package:walletfox/model/subscription_model.dart';
import 'package:walletfox/providers/subscription_provider.dart';
import 'package:walletfox/utils/styles/app_theme.dart';

class SubscriptionTile extends StatelessWidget {

  final SubscriptionModel sub;
  final int index;
  const SubscriptionTile({super.key, required this.index, required this.sub});

  @override
  Widget build(BuildContext context) {
    final subVm = context.read<SubscriptionProvider>();
    return Dismissible(
      key: ValueKey(sub.key),
      direction: DismissDirection.endToStart,
      onDismissed: (_) => subVm.deleteSubscription(index: index, id: sub.id),
      background: Container(
        color: AppColors.red,
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 20),
        child: const Icon(Icons.delete, color: AppColors.white,),
      ),
      child: Card(
        margin: const EdgeInsets.symmetric(vertical: 6),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      
        child: ListTile(
          leading: PhosphorIcon(
            _categoryIcons(sub.category),
            size: 32,
            color: AppColors.blue,
          ),
          title: Text(sub.name, style: Theme.of(context).textTheme.bodyMedium,),
          subtitle: Text("₹${sub.monthlyCost} | Renews on ${DateFormat.yMMMEd().format(sub.nextBillingDate)}"),
      
          trailing: Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: AppColors.blue.withOpacity(0.3),
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: AppColors.gray50)
            ),
            child: Text(sub.category),
          ),
        ),
      ),
    );
  }

  IconData _categoryIcons(String category) {
    final lwCat = category.toLowerCase();
    IconData icon = Icons.category;
    switch(lwCat) {
      case "entertainment":
        icon=Icons.movie;
        break;
      case "sports":
        icon=Icons.sports;
        break;
      case "software":
        icon=Icons.laptop;
        break;
      case "utilites":
        icon=Icons.settings;
        break;
      case "health":
        icon=Icons.safety_check;
        break;
      case "other":
        icon=Icons.category;
        break;
    }
    return icon;
  }
}