import 'package:flutter/material.dart';
import 'package:walletfox/utils/constants/strings.dart';
import 'package:walletfox/utils/styles/app_theme.dart';
import 'package:walletfox/views/add_subscription_view.dart';
import 'package:walletfox/widgets/ai_card.dart';
import 'package:walletfox/widgets/analysis_view.dart';
import 'package:walletfox/widgets/empty_state.dart';
import 'package:walletfox/widgets/notification_list_card.dart';
import 'package:walletfox/widgets/stats_card.dart';
import 'package:walletfox/widgets/subscription_tile.dart';

class DashboardView extends StatefulWidget {
  const DashboardView({super.key});

  @override
  State<DashboardView> createState() => _DashboardViewState();
}

class _DashboardViewState extends State<DashboardView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.blue.withOpacity(0.3),
        title: Text(APP_NAME),
        centerTitle: false,
      ),
      body: _buildHome(context),
      floatingActionButton: FloatingActionButton(onPressed: () => Navigator.of(context,).push(MaterialPageRoute(builder: (_) => AddSubscriptionView())), child: const Icon(Icons.add),
      ),
    );
  }
}

Widget? _buildHome(BuildContext context) {
  final subscriptionsList = [];
  return SingleChildScrollView(
    padding: const EdgeInsets.all(16.0),
    child: Column(
      spacing: 16,
      crossAxisAlignment : CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            StatsCard(title: 'Total Monthly Spend', value: '\$ 100', subtitle: '4 subscriptions', color: AppColors.blue),
            StatsCard(title: 'Upcoming Renewals', value: '2', subtitle: 'in the next 7 days', color: AppColors.blue),
          ],
        ),

        AiCard(),

        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text("Notification & Insights", style: Theme.of(context).textTheme.bodyLarge,),
            Text("Upcoming Renewals", style: Theme.of(context).textTheme.bodyMedium,),
            const SizedBox(height: 10,),
            ListView.builder(
              physics: NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              itemBuilder: (context, index)
            {
              return NotificationListCard();
            }, itemCount: 4)
          ],
        ),

        Text(
          "Your Subscriptions",
          style: Theme.of(context).textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.bold),
        ),

        subscriptionsList.isEmpty
          ? EmptyState(title: "No Subscriptions yet", subtitle: 'Add one')
          :
          ListView.builder(
          physics: NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          itemCount: 3,
          itemBuilder: (context, index) 
          {
            return SubscriptionTile(index: index);
          }),

          AnalysisView(),

          const SizedBox(height: 80,)
      ],
    ),
  );
}