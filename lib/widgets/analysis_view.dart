import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:walletfox/model/subscription_model.dart';
import 'package:walletfox/providers/subscription_provider.dart';
import 'package:walletfox/utils/styles/app_theme.dart';
import 'package:walletfox/widgets/pie_chart_indicator.dart';


class AnalysisView extends StatefulWidget {
  const AnalysisView({super.key});

  @override
  State<AnalysisView> createState() => _AnalysisViewState();
}

class _AnalysisViewState extends State<AnalysisView> {
  int touchedIndex = -1;
  @override
  Widget build(BuildContext context) {
    return Consumer<SubscriptionProvider>(
      builder: (context, subVm, _) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Spending by category", style: Theme.of(context).textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.bold),),
            Text("Your Monthly subscription breakdown", style: Theme.of(context).textTheme.bodySmall?.copyWith(),),
            Row(
              children: [
                const SizedBox(height: 18,),
                Expanded(
                  child: AspectRatio(
                    aspectRatio: 0.9,
                    child: PieChart(
                        PieChartData(
                          pieTouchData: PieTouchData(
                            touchCallback: (FlTouchEvent event, pieTouchResponse) {
                              setState(() {
                                if (!event.isInterestedForInteractions ||
                                    pieTouchResponse == null ||
                                    pieTouchResponse.touchedSection == null) {
                                  touchedIndex = -1;
                                  return;
                                }
                                touchedIndex = pieTouchResponse
                                    .touchedSection!.touchedSectionIndex;
                              });
                            }
                            ),
                            borderData: FlBorderData(show: false),
                            sectionsSpace: 0,
                            centerSpaceRadius: 40,
                            sections: showingSections(subVm)
                        )
                      ),
                  ),
                ),
        
                Column(
                  spacing: 4,
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: List.generate(subVm.categories.length, (index) {
                    final category = subVm.categories[index];
                    return PieChartIndicator(color: categoryColors(category), text: category, isSquare: true, );
                  }),
                )
              ],
            )
          ],
        );
      }
    );
  }

  Color categoryColors(String category) {
    final lwCat = category.toLowerCase();
    Color color = Colors.red;
    switch(lwCat) {
      case "entertainment":
        color=AppColors.blue;
        break;
      case "sports":
        color=AppColors.green;
        break;
      case "sass":
        color=Colors.yellow;
        break;
      case "utilites":
        color=Colors.purple;
        break;
      case "health":
        color=Colors.amber;
        break;
      case "other":
        color=Colors.red;
        break;
    }

    return color;
  }
  
  List<PieChartSectionData>? showingSections(SubscriptionProvider subVm) {
    return List.generate(subVm.categories.length, (index) {
      final isTouched = index == touchedIndex;
      final fontSize = isTouched ? 25.0 : 16.0;
      final radius = isTouched ? 60.0 : 50.0;
      const shadows = [Shadow(color: Colors.black, blurRadius: 2)];

      final category = subVm.categories[index].toLowerCase();
      return PieChartSectionData(
        color: categoryColors(category),
        value: 45,
        title: "45%",
        radius: radius,
        titleStyle: Theme.of(context).textTheme.bodyLarge?.copyWith(
          fontWeight: FontWeight.bold,
          color: AppColors.white,
          shadows: shadows,
          fontSize: fontSize
        )
      );
    });
  }
 }