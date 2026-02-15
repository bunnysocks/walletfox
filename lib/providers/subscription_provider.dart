
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:hive_ce/hive.dart';
import 'package:walletfox/model/subscription_model.dart';
import 'package:walletfox/services/notification_service.dart';

class SubscriptionProvider extends ChangeNotifier {
  //Hive Box
  final _boxName = "subscriptions";
  late Box<SubscriptionModel> _box;

  final TextEditingController nameController = TextEditingController();
  final TextEditingController costController = TextEditingController();
  final TextEditingController dateController = TextEditingController();

  String billingCycle = "Monthly";
  String category = "entertainment";

  final _notifications = NotificationService();

  List<String> categories = [
    "entertainment",
    "sports",
    "software",
    "utilities",
    "health",
    "others"
  ];

  List<SubscriptionModel> _subscriptions = [];
  List<SubscriptionModel> get subscriptions => _subscriptions;

  Future<void> init()async {
    _box = await Hive.openBox<SubscriptionModel>(_boxName);
    _getSubscriptions();
  }

  void setBillingCycle(String value) {
    billingCycle = value;
    notifyListeners();
  }

  void setCategory(String value) {
    category = value;
    notifyListeners();
  }

  Future<void> pickNextBillingDate(BuildContext context) async {
    final now = DateTime.now();

    final picked = await showDatePicker(context: context, initialDate: now, firstDate: now.subtract(const Duration(days: 365)), lastDate: now.add(const Duration(days: 365 * 5)));
    if(picked != null) {
      dateController.text = picked.toIso8601String().split("T").first;
      notifyListeners();
    }
  }

  Future<bool> saveSubscription(BuildContext context) async {
    if(nameController.text.isEmpty || costController.text.isEmpty || dateController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Fill all Fields")));
      return false;
    }

    final subscription = SubscriptionModel(id: Random().nextInt(10 * 10000), name: nameController.text.trim(), monthlyCost: double.tryParse(costController.text) ?? 0, nextBillingDate: DateTime.parse(dateController.text), billingCycle: billingCycle, category: category, createdAt: DateTime.now());

    await _box.add(subscription);

    //Schedule Notification
    _notifications.scheduleRenewalNotification(
      id: subscription.id,
      name: subscription.name,
      date: subscription.nextBillingDate,
      amount: subscription.monthlyCost,
    );

    _getSubscriptions();
    clearForm();
    _getSubscriptions();

    return true;
  }

  Future<void> deleteSubscription({required int index, required int id}) async {
    final key = _box.keyAt(index);
    await _box.delete(key);
    _getSubscriptions();

    //cancel notification
    _notifications.cancel(id);
  }

  void _getSubscriptions() {
    _subscriptions = _box.values.toList().cast<SubscriptionModel>();
    notifyListeners();
  }
  
  void clearForm() {
    nameController.clear();
    costController.clear();
    dateController.clear();
    billingCycle = "Monthly";
    category = "entertainment";
  }

  double totalMonthlyCost() {
    double total = 0;
    for (var sub in subscriptions) {
      final monthly = sub.monthlyCost * (30 / _getDays(sub.billingCycle.toLowerCase()));
      total += monthly;
    }

    return total;
  }
  
  int _getDays(String billingCycle) {
    return switch(billingCycle) {
      'daily' => 1,
      'weekly' => 7,
      'monthly' => 30,
      'yearly' => 365,
      'never' => 30,
      _ => 30,
    };
  }


  //Spending per category for the pie chart
  Map<String, double> spendingPerCategory() {
    final Map<String, double> data = {};
    for(final sub in subscriptions) {
      data[sub.category.toLowerCase()] = (data[sub.category] ?? 0) + sub.monthlyCost;
    }


    return data;
  }


  List<SubscriptionModel> upcomingRenewalSubs() {
    final now = DateTime.now();
    final upcoming = now.add(const Duration(days: 7));
    return subscriptions.where((sub) => sub.nextBillingDate.isAfter(now) && sub.nextBillingDate.isBefore(upcoming)).toList();
  }
}