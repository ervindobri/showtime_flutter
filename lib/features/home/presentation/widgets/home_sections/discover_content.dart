import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:show_time/core/constants/custom_variables.dart';
import 'package:show_time/core/constants/styles.dart';
import 'package:show_time/ui/colorful_card_home.dart';

class DiscoverContent extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final double _width = MediaQuery.of(context).size.width;
    final double _height = MediaQuery.of(context).size.height;
    return Container(
      height: _height * .25,
      color: GlobalColors.bgColor,
      width: _width,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 25.0),
            child: Text("Discover", style: GlobalStyles.sectionStyle()),
          ),
          Container(
            width: _width,
            height: _height * .21,
            child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: GlobalVariables.DISCOVER_DATA.length,
                shrinkWrap: true,
                itemBuilder: (context, int index) {
                  return ColorfulCard(
                    index: index,
                    data: GlobalVariables.DISCOVER_DATA[index],
                    maxWidth: kIsWeb ? 200 : _width / 3,
                    maxHeight: kIsWeb ? 200 : _width / 3,
                  );
                }),
          )
        ],
      ),
    );
  }
}
