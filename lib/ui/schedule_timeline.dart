import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:show_time/core/constants/custom_variables.dart';
import 'package:show_time/core/constants/theme_utils.dart';
import 'package:show_time/features/home/data/models/episode.dart';
import 'package:timeline_tile/timeline_tile.dart';

class ScheduleTimeline extends StatefulWidget {
  final List<List<Episode>> items;

  const ScheduleTimeline({Key? key, required this.items}) : super(key: key);

  @override
  _ScheduleTimelineState createState() => _ScheduleTimelineState();
}

class _ScheduleTimelineState extends State<ScheduleTimeline> {
  final _scrollController = ScrollController();
  late List<List<Episode>> itemsCopy;

  @override
  void initState() {
    itemsCopy = widget.items;
    itemsCopy.sort((List<Episode> a, List<Episode> b) =>
        a.first.airDate!.compareTo(b.first.airDate!));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // final _width = MediaQuery.of(context).size.width;
    // final _height = MediaQuery.of(context).size.height;
    return Padding(
      padding: const EdgeInsets.only(left: 35, bottom: 50),
      child: SizedBox(
        height: itemsCopy.length * 200.0,
        child: ListView.builder(
            controller: _scrollController,
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            itemCount: itemsCopy.length,
            itemBuilder: (_, index) => EpisodeTile(
                  isFirst: index == 0 ? true : false,
                  isLast: index == itemsCopy.length - 1 ? true : false,
                  episodes: itemsCopy[index],
                )),
      ),
    );
  }
}

class EpisodeTile extends StatelessWidget {
  final List<Episode> episodes;
  final bool isFirst;
  final bool isLast;

  const EpisodeTile(
      {Key? key,
      required this.episodes,
      required this.isFirst,
      required this.isLast})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TimelineTile(
      alignment: TimelineAlign.start,
      isFirst: isFirst,
      isLast: isLast,
      indicatorStyle: IndicatorStyle(
        width: 30,
        color: episodes.first.getDiffDays() < 0
            ? GlobalColors.primaryGreen
            : GlobalColors.fireColor,
        indicatorXY: 0.0,
      ),
      endChild: Container(
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: episodes.first.getDiffDays() < 0
                  ? GlobalColors.primaryGreen.withOpacity(.2)
                  : GlobalColors.fireColor.withOpacity(.2),
              blurRadius: 15,
              spreadRadius: -2,
            )
          ],
        ),
        constraints: const BoxConstraints(
          minHeight: 80,
        ),
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Container(
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                color: episodes.first.getDiffDays() < 0
                    ? GlobalColors.primaryGreen
                    : GlobalColors.fireColor),
            child: Padding(
              padding: const EdgeInsets.all(5.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SizedBox(
                        width: 100,
                        child: Text(episodes.first.name!,
                            style: ShowTheme.listWatchCardSubStyle),
                      ),
                      Text(episodes.first.getAirDateLabel(),
                          maxLines: 1,
                          style: GoogleFonts.raleway(
                              fontSize: 25,
                              fontWeight: FontWeight.w700,
                              color: GlobalColors.white)),
                    ],
                  ),
                  Container(
                    height: 100,
                    width: 70,
                    decoration: BoxDecoration(
                        image: DecorationImage(
                            image: NetworkImage(episodes.first.embedded!['show']
                                ['image']['medium']!),
                            fit: BoxFit.cover),
                        borderRadius:
                            const BorderRadius.all(Radius.circular(12.0)),
                        shape: BoxShape.rectangle),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
