import 'package:flutter/cupertino.dart';
import 'package:show_time/core/constants/custom_variables.dart';
import 'package:show_time/core/constants/styles.dart';
import 'package:show_time/ui/colorful_card_home.dart';

class DiscoverContent extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final double width = MediaQuery.of(context).size.width;
    final double height = MediaQuery.of(context).size.height;
    const items = GlobalVariables.DISCOVER_DATA;
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 25.0),
          child: Text("Discover", style: GlobalStyles.sectionStyle()),
        ),
        const SizedBox(height: 12),
        SizedBox(
          height: width / 3,
          child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: items.length,
              shrinkWrap: true,
              clipBehavior: Clip.none,
              padding: const EdgeInsets.symmetric(horizontal: 24),
              separatorBuilder: (context, int index) =>
                  const SizedBox(width: 16),
              itemBuilder: (context, int index) {
                return ColorfulCard(
                  index: index,
                  data: items[index],
                );
              }),
        )
      ],
    );
  }
}
