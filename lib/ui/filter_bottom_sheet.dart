import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:multi_select_flutter/chip_display/multi_select_chip_display.dart';
import 'package:multi_select_flutter/chip_field/multi_select_chip_field.dart';
import 'package:multi_select_flutter/util/multi_select_item.dart';
import 'package:show_time/components/radial_range_slider.dart';
import 'package:show_time/constants/custom_variables.dart';
import 'package:show_time/get_controllers/filter_controller.dart';
import 'package:syncfusion_flutter_sliders/sliders.dart';

class FilterMenuSheet extends StatelessWidget {
  final VoidCallback onFilter;


  FilterMenuSheet({Key? key,required this.onFilter}) : super(key: key);

  FilterController filterController = Get.put(FilterController());
  List<Object?> _selectedGenres = [];

  @override
  Widget build(BuildContext context) {
    final _width = Get.width;
    final _height = Get.height;
    return Scaffold(
        body: Padding(
          padding: const EdgeInsets.symmetric(
              horizontal: kIsWeb ? 55.0 : 25,
              vertical: 50),
          child: Container(
            width: _width,
            height: _height,
            child: Center(
              child: Container(
                width: _width*.8,
                child: GetBuilder<FilterController>(
                  init: filterController,
                  builder: (controller) {
                    return Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 50.0),
                          child: InkWell(
                            onTap: (){
                              Get.back();
                            },
                            hoverColor: Colors.transparent,
                            splashColor: Colors.transparent,
                            child: FaIcon(
                              FontAwesomeIcons.timesCircle,
                              color: GlobalColors.greenColor,
                              size: kIsWeb ? 100 : Get.width/3,
                            ),
                          ),
                        ),
                        //start date
                        //current season
                        //current episode
                        //first watch date
                        //last watch date

                        Row(
                          children: [
                            Column(
                              //rating
                              children: [
                                Container(
                                height: 200,
                                width: 350,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "Rating",
                                      style: GoogleFonts.raleway(
                                          color: GlobalColors.greenColor,
                                          fontSize: 25
                                      ),
                                    ),
                                    // Obx(
                                    //       () =>
                                    RadialRangeSlider(
                                      textColor: GlobalColors.greenColor,
                                      backgroundColor: GlobalColors.greenColor,
                                      radiusFactor: .5,
                                    )
                                    // ),
                                  ],
                                ),
                              ),],
                            ),
                            Column(
                              children: [
                                //runtime
                                Container(
                                  height: 200,
                                  width: 350,
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        "Runtime",
                                        style: GoogleFonts.raleway(
                                            color: GlobalColors.greenColor,
                                            fontSize: 25
                                        ),
                                      ),
                                      Obx(
                                            () => SfRangeSlider(
                                          min: 0.0,
                                          max: 60.0,
                                          stepSize: 5,
                                          activeColor: GlobalColors.greenColor,
                                          showLabels: true,
                                          showTicks: true,
                                          enableIntervalSelection: true,
                                          enableTooltip: true,
                                          labelPlacement: LabelPlacement.onTicks,
                                          values: filterController.runtimeRangeValues.value,
                                          onChanged: (values){
                                            filterController.runtimeRangeValues.value = values;
                                          },
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                //genres
                                Container(
                                  height: 300,
                                  width: 350,
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        "Genres",
                                        style: GoogleFonts.raleway(
                                            color: GlobalColors.greenColor,
                                            fontSize: 25
                                        ),
                                      ),
                                      MultiSelectChipField<String?>(
                                        items: filterController.genreItems,
                                        initialValue: [FilterController.genres[0]],
                                        scroll: false,
                                        headerColor: Colors.transparent,
                                        textStyle: GoogleFonts.raleway(
                                            color: GlobalColors.greyTextColor
                                        ),
                                        selectedChipColor: GlobalColors.greenColor,
                                        selectedTextStyle: GoogleFonts.raleway(
                                            color: GlobalColors.white
                                        ),
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(12),
                                        ),
                                        onTap: (values) {
                                          filterController.selectedGenres = values;
                                        },
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            )
                          ],
                        ),

                        //total seasons
                        //finished or not
                        //watched times
                        TextButton(
                          onPressed: onFilter,
                          style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.all(GlobalColors.blueColor)
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              "Apply filters",
                              style: GoogleFonts.raleway(
                                  color: GlobalColors.white
                              ),
                            ),
                          ),
                        )
                      ],
                    );
                  }
                ),
              ),
            ),
          ),
        )
    );
  }
}
