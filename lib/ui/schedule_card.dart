import 'dart:async';
import 'package:show_time/core/constants/theme_utils.dart';
import 'package:flutter/material.dart';
import 'package:show_time/core/utils/navigation.dart';
import 'package:show_time/features/home/data/models/countdown.dart';
import 'package:show_time/features/home/data/models/episode.dart';
import 'package:show_time/core/constants/custom_variables.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:show_time/features/watchlist/presentation/widgets/detail_view/watched_detail_view.dart';

class ScheduleCard extends StatefulWidget {
  final Episode episode;

  const ScheduleCard({Key? key, required this.episode}) : super(key: key);

  @override
  _ScheduleCardState createState() => _ScheduleCardState();
}

class _ScheduleCardState extends State<ScheduleCard> {
  String _countdownLabel = "";
  late Timer _timer;
  Color episodeLabelColor = GlobalColors.greyTextColor;

  @override
  void initState() {
    super.initState();
    //Initialize the label text
    _countdownLabel = widget.episode.getDifference().displayLetters;
    startCountdown();
  }

  @override
  void dispose() {
    _timer.cancel();
    _countdownLabel = "";

    super.dispose();
  }

  void startCountdown() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        _countdownLabel = widget.episode.getDifference().displayLetters;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final double width = MediaQuery.of(context).size.width;
    // final double height = MediaQuery.of(context).size.height;
    // const BorderRadius _radius = BorderRadius.all(Radius.circular(25.0));
    return InkWell(
      onTap: () {
        //  showModalBottomSheet<dynamic>(
        //     shape: const RoundedRectangleBorder(
        //       borderRadius: BorderRadius.only(
        //           topLeft: Radius.circular(24.0),
        //           topRight: Radius.circular(24.0)),
        //     ),
        //     context: context,
        //     builder: (_) => WatchedDetailWrapper(show: show),
        //     isScrollControlled: true);
      },
      child: Container(
        // color: Colors.black,
        padding: const EdgeInsets.fromLTRB(0, 12, 0, 24),
        child: Stack(
          clipBehavior: Clip.none,
          alignment: Alignment.center,
          children: [
            Container(
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.all(Radius.circular(24)),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey,
                    blurRadius: 15.0,
                    spreadRadius: -5,
                    offset: Offset(0, 5),
                  ),
                ],
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Container(
                    decoration: const BoxDecoration(
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(24.0),
                          topRight: Radius.circular(24.0),
                        ),
                        color: GlobalColors.greyTextColor),
                    padding: const EdgeInsets.all(12),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Text(
                              "S${widget.episode.season.toString()}",
                              style: const TextStyle(
                                  fontWeight: FontWeight.w700,
                                  color: Colors.white,
                                  fontSize: 14,
                                  fontFamily: 'Raleway'),
                            ),
                            const SizedBox(width: 8),
                            Text(
                              "E${widget.episode.episode.toString()}",
                              style: const TextStyle(
                                  fontWeight: FontWeight.w700,
                                  color: Colors.white,
                                  fontSize: 14,
                                  fontFamily: 'Raleway'),
                            ),
                          ],
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            SizedBox(
                              width: width / 2,
                              child:
                                  Text(widget.episode.embedded!['show']['name'],
                                      textAlign: TextAlign.right,
                                      overflow: TextOverflow.fade,
                                      maxLines: 1,
                                      style: GoogleFonts.poppins(
                                        color: Colors.white,
                                        fontSize: 16,
                                        fontWeight: FontWeight.w700,
                                        // fontFamily: 'Raleway',
                                      )),
                            ),
                            Text(widget.episode.name!,
                                textAlign: TextAlign.right,
                                style: GoogleFonts.poppins(
                                  color: Colors.white,
                                  fontStyle: FontStyle.italic,
                                  fontSize: 14,
                                )),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                  widget.episode.getDiffDays() >= 0
                      ? const SizedBox()
                      : Text(
                          _countdownLabel,
                          style: GoogleFonts.poppins(
                              color: GlobalColors.greyTextColor.withOpacity(.4),
                              fontSize: 24,
                              fontWeight: FontWeight.w700),
                        ),
                  // const SizedBox(height: 48),
                ],
              ),
            ),
            Positioned(
              bottom: -24,
              child: Container(
                height: 48,
                decoration: BoxDecoration(
                  color: widget.episode.getDiffDays() > 3
                      ? GlobalColors.lightGreenColor
                      : GlobalColors.orangeColor,
                  borderRadius: ShowTheme.radius50,
                  boxShadow: [
                    BoxShadow(
                      color: widget.episode.getDiffDays() > 3
                          ? GlobalColors.lightGreenColor.withOpacity(.5)
                          : GlobalColors.fireColor.withOpacity(1),
                      blurRadius: 8.0,
                      spreadRadius: -2,
                      offset: const Offset(0, 2),
                    )
                  ],
                ),
                padding:
                    const EdgeInsets.symmetric(vertical: 4, horizontal: 24),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      widget.episode.getAirDateLabel(),
                      textAlign: TextAlign.center,
                      style: GoogleFonts.poppins(
                        fontWeight: FontWeight.w900,
                        color: Colors.white,
                        fontSize: 12,
                      ),
                    ),
                    Text(
                      widget.episode.getDiffDays() >= 0
                          ? "Available"
                          : widget.episode.airTime!,
                      style: GoogleFonts.poppins(
                        fontWeight: FontWeight.w500,
                        color: Colors.white,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
