import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:walletfox/providers/subscription_provider.dart';
import 'package:walletfox/utils/styles/app_theme.dart';
import 'package:walletfox/widgets/analysis_view.dart';

class AddSubscriptionView extends StatelessWidget {
  AddSubscriptionView({super.key});

  

  @override
  Widget build(BuildContext context) {
    final subVm = context.watch<SubscriptionProvider>();
    return Scaffold(
      appBar: AppBar(titleSpacing: 0, title: Text("Add a new subscription"),),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          spacing: 12,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 14),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text("Enter the details of your subscriptions to start tracking", style: Theme.of(context).textTheme.bodyLarge?.copyWith(),),
              ),
            ),

            _borderField(subVm.nameController, "Subscription Name"),
            _borderField(subVm.costController, "Monthly Cost (\$)", inputType: TextInputType.number),
            _borderField(subVm.dateController, "Next billing date", readOnly: true, onTap: () {
              // Pick Date
              subVm.pickNextBillingDate(context);
            }),
            const SizedBox(height: 8,),
            _dropDownField(label: "Billing Cycle", value: subVm.billingCycle, items: const ["Daily", "Weekly", "Monthly", "Yearly", "Never"], onChanged: (v) {subVm.setBillingCycle(v);}),
            _dropDownField(label: "Category", value: subVm.category, items: subVm.categories, onChanged: (v) {subVm.setCategory(v);}),

            const SizedBox(height: 40,),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: () async {
                  //save subscription
                  final result = await subVm.saveSubscription(context);
                  if(result && context.mounted) {

                    Navigator.pop(context);
                  }
                },
                style: ButtonStyle(
                  backgroundColor: WidgetStatePropertyAll(AppColors.blue),
                  foregroundColor: WidgetStatePropertyAll(AppColors.white)
                ), 
                child: const Text("Save Subscription"),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _borderField(
    TextEditingController c,
    String label, {
      TextInputType? inputType,
      bool readOnly = false,
      VoidCallback? onTap,
    }) {
      return TextField(
        controller: c,
        keyboardType: inputType,
        readOnly: readOnly,
        onTap: onTap,
        decoration: InputDecoration(
          labelText: label,
          border: const OutlineInputBorder(borderSide: BorderSide(width: 1))
        ),
      );
    }

    Widget _dropDownField(
      {required String label,
      required String value,
      required List<String> items,
      required Function(String) onChanged,}
    ) {
      return InputDecorator(decoration: const InputDecoration(
        border: OutlineInputBorder(borderSide: BorderSide(width: 1)),
      ).copyWith(labelText: label),
      child: DropdownButtonHideUnderline(child: DropdownButton<String>(value: value, isExpanded: true, items: items.map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(), onChanged: (v) => onChanged(v!),)),
      );
    }
}