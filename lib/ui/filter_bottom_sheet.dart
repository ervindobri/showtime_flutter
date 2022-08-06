import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:multi_select_flutter/chip_field/multi_select_chip_field.dart';
import 'package:show_time/components/radial_range_slider.dart';
import 'package:show_time/core/constants/custom_variables.dart';
import 'package:show_time/core/utils/navigation.dart';
import 'package:show_time/get_controllers/filter_controller.dart';
import 'package:syncfusion_flutter_sliders/sliders.dart';

// ignore: must_be_immutable
class FilterMenuSheet extends StatelessWidget {
  final VoidCallback onFilter;

  FilterMenuSheet({Key? key, required this.onFilter}) : super(key: key);

  FilterController filterController = Get.put(FilterController());
  // List<Object?> _selectedGenres = [];

  @override
  Widget build(BuildContext context) {
    final _width = MediaQuery.of(context).size.width;
    // final _height = MediaQuery.of(context).size.height;
    return Center(
      child: SizedBox(
        width: _width,
        child: GetBuilder<FilterController>(
          init: filterController,
          builder: (controller) {
            return LayoutBuilder(
              builder: (_, constraints) {
                if (constraints.maxWidth > 600) {
                  return Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 50.0),
                        child: InkWell(
                          onTap: () {
                            NavUtils.back(context);
                          },
                          hoverColor: Colors.transparent,
                          splashColor: Colors.transparent,
                          child: FaIcon(
                            FontAwesomeIcons.timesCircle,
                            color: GlobalColors.primaryGreen,
                            size: kIsWeb
                                ? 100
                                : MediaQuery.of(context).size.width / 3,
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
                              SizedBox(
                                height: 200,
                                width: 350,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "Rating",
                                      style: GoogleFonts.raleway(
                                          color: GlobalColors.primaryGreen,
                                          fontSize: 25),
                                    ),
                                    // Obx(
                                    //       () =>
                                    const RadialRangeSlider(
                                      textColor: GlobalColors.primaryGreen,
                                      backgroundColor:
                                          GlobalColors.primaryGreen,
                                      radiusFactor: .5,
                                    )
                                    // ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          Column(
                            children: [
                              //runtime
                              SizedBox(
                                height: 200,
                                width: 350,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "Runtime",
                                      style: GoogleFonts.raleway(
                                          color: GlobalColors.primaryGreen,
                                          fontSize: 25),
                                    ),
                                    Obx(
                                      () => SfRangeSlider(
                                        min: 0.0,
                                        max: 60.0,
                                        stepSize: 5,
                                        activeColor: GlobalColors.primaryGreen,
                                        showLabels: true,
                                        showTicks: true,
                                        enableIntervalSelection: true,
                                        enableTooltip: true,
                                        labelPlacement: LabelPlacement.onTicks,
                                        values: filterController
                                            .runtimeRangeValues.value,
                                        onChanged: (values) {
                                          filterController.runtimeRangeValues
                                              .value = values;
                                        },
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              //genres
                              SizedBox(
                                height: 300,
                                width: 350,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "Genres",
                                      style: GoogleFonts.raleway(
                                          color: GlobalColors.primaryGreen,
                                          fontSize: 25),
                                    ),
                                    MultiSelectChipField<String?>(
                                      items: filterController.genreItems,
                                      initialValue: [
                                        FilterController.genres[0]
                                      ],
                                      scroll: false,
                                      headerColor: Colors.transparent,
                                      textStyle: GoogleFonts.raleway(
                                          color: GlobalColors.greyTextColor),
                                      selectedChipColor:
                                          GlobalColors.primaryGreen,
                                      selectedTextStyle: GoogleFonts.raleway(
                                          color: GlobalColors.white),
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      onTap: (values) {
                                        filterController.selectedGenres =
                                            values;
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
                            backgroundColor: MaterialStateProperty.all(
                                GlobalColors.primaryBlue)),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            "Apply filters",
                            style:
                                GoogleFonts.raleway(color: GlobalColors.white),
                          ),
                        ),
                      )
                    ],
                  );
                } else {
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 15.0),
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 50.0),
                            child: InkWell(
                              onTap: () {
                                NavUtils.back(context);
                              },
                              hoverColor: Colors.transparent,
                              splashColor: Colors.transparent,
                              child: FaIcon(
                                FontAwesomeIcons.timesCircle,
                                color: GlobalColors.primaryGreen,
                                size: kIsWeb
                                    ? 100
                                    : MediaQuery.of(context).size.width / 3,
                              ),
                            ),
                          ),
                          //start date
                          //current season
                          //current episode
                          //first watch date
                          //last watch date

                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Rating",
                                style: GoogleFonts.raleway(
                                    color: GlobalColors.primaryGreen,
                                    fontSize: 25),
                              ),
                              // Obx(
                              //       () =>
                              const RadialRangeSlider(
                                textColor: GlobalColors.primaryGreen,
                                backgroundColor: GlobalColors.primaryGreen,
                                radiusFactor: .65,
                              )
                              // ),
                            ],
                          ),
                          Column(
                            children: [
                              //runtime
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "Runtime",
                                    style: GoogleFonts.raleway(
                                        color: GlobalColors.primaryGreen,
                                        fontSize: 25),
                                  ),
                                  Obx(
                                    () => SfRangeSlider(
                                      min: 0.0,
                                      max: 60.0,
                                      stepSize: 5,
                                      activeColor: GlobalColors.primaryGreen,
                                      showLabels: true,
                                      showTicks: true,
                                      enableIntervalSelection: true,
                                      enableTooltip: true,
                                      labelPlacement: LabelPlacement.onTicks,
                                      values: filterController
                                          .runtimeRangeValues.value,
                                      onChanged: (values) {
                                        filterController
                                            .runtimeRangeValues.value = values;
                                      },
                                    ),
                                  ),
                                ],
                              ),
                              //genres
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "Genres",
                                    style: GoogleFonts.raleway(
                                        color: GlobalColors.primaryGreen,
                                        fontSize: 25),
                                  ),
                                  MultiSelectChipField<String?>(
                                    items: filterController.genreItems,
                                    initialValue: [FilterController.genres[0]],
                                    scroll: false,
                                    headerColor: Colors.transparent,
                                    textStyle: GoogleFonts.raleway(
                                        color: GlobalColors.greyTextColor),
                                    selectedChipColor:
                                        GlobalColors.primaryGreen,
                                    selectedTextStyle: GoogleFonts.raleway(
                                        color: GlobalColors.white),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    onTap: (values) {
                                      filterController.selectedGenres = values;
                                    },
                                  ),
                                ],
                              ),
                            ],
                          ),

                          //total seasons
                          //finished or not
                          //watched times
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 25.0),
                            child: TextButton(
                              onPressed: onFilter,
                              style: ButtonStyle(
                                backgroundColor: MaterialStateProperty.all(
                                    GlobalColors.primaryGreen),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  "Apply filters",
                                  style: GoogleFonts.raleway(
                                    color: GlobalColors.white,
                                    fontWeight: FontWeight.w600,
                                    fontSize: 20,
                                  ),
                                ),
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                  );
                }
              },
            );
          },
        ),
      ),
    );
  }
}
