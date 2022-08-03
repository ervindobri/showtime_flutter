import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:get/get.dart';
import 'package:show_time/components/loading_couch.dart';
import 'package:show_time/core/constants/custom_variables.dart';
import 'package:show_time/core/constants/styles.dart';
import 'package:show_time/core/utils/navigation.dart';
import 'package:show_time/features/home/presentation/bloc/scheduledshows_bloc.dart';
import 'package:show_time/screens/full_schedule.dart';
import 'package:show_time/ui/schedule_card.dart';

class ScheduledContent extends StatelessWidget {
  final ScrollController _scheduleScrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    final double _width = MediaQuery.of(context).size.width;
    final double _height = MediaQuery.of(context).size.height;
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 25.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("Schedule", style: GlobalStyles.sectionStyle()),
              InkWell(
                onTap: () => NavUtils.navigate(context, '/schedule'),
                child: Container(
                  child: Center(
                    child: Text("All",
                        style: TextStyle(
                          fontSize: 16,
                          color: GlobalColors.greenColor,
                          decoration: TextDecoration.underline,
                          fontWeight: FontWeight.w800,
                        )),
                  ),
                ),
              ),
            ],
          ),
        ),
        BlocBuilder<ScheduledShowsBloc, ScheduledShowsState>(
          builder: (context, state) {
            print(state);
            if (state is ScheduledShowsLoaded) {
              final shows = state.shows;
              if (shows.isNotEmpty) {
                return _buildScheduledShowView(context, shows);
              } else {
                return Container(
                  child: Center(
                    child: Text("empty as fuck bro"),
                  ),
                );
              }
            } else {
              return LoadingCouch();
            }
          },
        ),
      ],
    );
  }

  Widget _buildScheduledShowView(BuildContext context, List shows) {
    double _width = MediaQuery.of(context).size.width;
    double _height = MediaQuery.of(context).size.height;
    return kIsWeb
        ? Container(
            width: _width,
            height: _height,
            child: StaggeredGridView.countBuilder(
              physics: NeverScrollableScrollPhysics(),
              staggeredTileBuilder: (int index) =>
                  new StaggeredTile.count(1, 1),
              mainAxisSpacing: 4.0,
              crossAxisSpacing: 2.0,
              itemCount: shows.length,
              itemBuilder: (context, int index) {
                return Center(child: ScheduleCard(episode: shows[index]));
              },
              crossAxisCount: 4,
            ),
          )
        : Container(
            width: _width,
            height: _height * .4,
            color: GlobalColors.bgColor,
            child: ListView.builder(
                controller: _scheduleScrollController,
                scrollDirection: Axis.horizontal,
                itemCount: 3,
                // itemCount: showController.notAired.take(5).length,
                itemBuilder: (context, int index) {
                  return Center(
                      child:
                          ScheduleCard(episode: shows.take(5).toList()[index]));
                }));
  }
}
