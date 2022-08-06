import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:show_time/core/constants/custom_variables.dart';
import 'package:show_time/core/constants/theme_utils.dart';
import 'package:show_time/core/utils/navigation.dart';
import 'package:show_time/features/home/data/models/watched.dart';

class WatchlistDetailDialog extends StatelessWidget {
  final WatchedTVShow show;

  const WatchlistDetailDialog({Key? key, required this.show}) : super(key: key);

  //todo animator

  @override
  Widget build(BuildContext context) {
    const double dialogWidth = 600;
    const double dialogHeight = 450;
    return MouseRegion(
      onExit: (event) {
        NavUtils.back(context);
      },
      child: SizedBox(
        width: dialogWidth,
        height: dialogHeight,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30.0, vertical: 25),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: Container(
                  width: dialogWidth / 3,
                  height: dialogHeight * .8,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      fit: BoxFit.contain,
                      image: NetworkImage(
                        show.imageThumbnailPath!,
                      ),
                    ),
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(15.0),
                child: SizedBox(
                  width: dialogWidth / 2,
                  height: dialogHeight * .8,
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                const Padding(
                                  padding: EdgeInsets.all(8.0),
                                  child: FaIcon(
                                    FontAwesomeIcons.clock,
                                    color: GlobalColors.greyTextColor,
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text("Runtime",
                                      style: ShowTheme.defaultTextStyle),
                                ),
                              ],
                            ),
                            Text(show.runtime.toString(),
                                style: ShowTheme.defaultBoldTextStyle),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                const Padding(
                                  padding: EdgeInsets.all(8.0),
                                  child: FaIcon(
                                    FontAwesomeIcons.star,
                                    color: GlobalColors.greyTextColor,
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text("Rating",
                                      style: ShowTheme.defaultTextStyle),
                                ),
                              ],
                            ),
                            Text(show.rating.toString(),
                                style: ShowTheme.defaultBoldTextStyle),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 50.0),
                        child: Text(
                          "You are watching",
                          style: GoogleFonts.raleway(
                              color: GlobalColors.greyTextColor, fontSize: 30),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 20.0, horizontal: 35),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                children: [
                                  Text(
                                    "Season",
                                    style: GoogleFonts.raleway(
                                        color: GlobalColors.greyTextColor),
                                  ),
                                  Text(
                                    show.currentSeason.toString(),
                                    style: GoogleFonts.raleway(
                                        color: Get.theme.primaryColor,
                                        fontWeight: FontWeight.w700,
                                        fontSize: 35),
                                  ),
                                ],
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                children: [
                                  Text(
                                    "Episode",
                                    style: GoogleFonts.raleway(
                                        color: GlobalColors.greyTextColor),
                                  ),
                                  Text(
                                    show.currentEpisode.toString(),
                                    style: GoogleFonts.raleway(
                                        color: Get.theme.primaryColor,
                                        fontWeight: FontWeight.w700,
                                        fontSize: 35),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
