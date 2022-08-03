import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:show_time/core/constants/custom_variables.dart';
import 'package:show_time/core/utils/navigation.dart';

typedef void ItemCallback(int value);

class SortMenu extends StatelessWidget {
  final VoidCallback onTap;
  final ItemCallback onSelectItemChanged;

  const SortMenu(
      {Key? key, required this.onTap, required this.onSelectItemChanged})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    double _width = MediaQuery.of(context).size.width;
    double _height = MediaQuery.of(context).size.height;
    return ClipRRect(
      borderRadius: BorderRadius.only(
          topLeft: Radius.circular(25.0), topRight: Radius.circular(25.0)),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Container(
            height: _height / 8,
            color: Colors.white,
            child: Stack(
              alignment: Alignment.center,
              children: [
                Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 25.0),
                        child: Material(
                          color: Colors.transparent,
                          child: InkWell(
                              onTap: () {
                            NavUtils.back(context);
                              },
                              child: Icon(
                                Icons.arrow_back,
                                size: 30,
                              ) // the arrow back icon
                              ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 25.0),
                        child: InkWell(
                          onTap: onTap,
                          child: Text(
                            "Confirm",
                            style: TextStyle(
                              color: GlobalColors.greyTextColor,
                              decoration: TextDecoration.underline,
                              fontSize: 20,
                              fontFamily: 'Raleway',
                            ),
                          ),
                        ),
                      )
                    ]),
                Center(
                    child: Text(
                  "Sort",
                  style: TextStyle(
                      fontFamily: 'Raleway',
                      fontWeight: FontWeight.w700,
                      fontSize: 30,
                      color: GlobalColors.greyTextColor),
                ) // Your desired title
                    ),
              ],
            ),
          ),
          Container(
            height: _height / 2.4,
            color: Colors.white,
            child: CupertinoPicker(
              backgroundColor: Colors.white,
              itemExtent: 50,
              diameterRatio: 1,
              looping: true,
              useMagnifier: true,
              onSelectedItemChanged: (int value) {
                onSelectItemChanged(value);
              },
              children: new List<Widget>.generate(
                  GlobalVariables.SORT_CATEGORIES.length, (index) {
                return Container(
                  width: _width,
                  color: Colors.white,
                  child: Center(
                      child: Text(
                    GlobalVariables.SORT_CATEGORIES[index],
                    style: TextStyle(
                      color: GlobalColors.greyTextColor,
                      fontSize: 25,
                      fontFamily: 'Raleway',
                    ),
                  )),
                );
              }),
            ),
          )
        ],
      ),
    );
  }
}
