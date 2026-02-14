import 'package:hive_ce/hive.dart';
part 'subscription_model.g.dart';

@HiveType(typeId : 0) 
class SubscriptionModel extends HiveObject {
  @HiveField(0)
  int id;

  @HiveField(1)
  String name;

  @HiveField(2)
  double monthlyCost;

  @HiveField(3)
  DateTime nextBillingDate;

  @HiveField(4)
  String billingCycle;

  @HiveField(5)
  String category;

  @HiveField(6)
  DateTime createdAt;

  SubscriptionModel({
    required this.id,
    required this.name,
    required this.monthlyCost,
    required this.nextBillingDate,
    required this.billingCycle,
    required this.category,
    required this.createdAt
  });
}