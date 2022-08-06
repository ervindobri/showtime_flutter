import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:show_time/components/loading_couch.dart';
import 'package:show_time/core/constants/custom_variables.dart';
import 'package:show_time/core/constants/styles.dart';
import 'package:show_time/core/utils/navigation.dart';
import 'package:show_time/features/home/presentation/bloc/scheduledshows_bloc.dart';
import 'package:show_time/ui/schedule_card.dart';

class ScheduledContent extends StatelessWidget {
  const ScheduledContent({Key? key}) : super(key: key);
  // final ScrollController _scheduleScrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    // final double _width = MediaQuery.of(context).size.width;
    // final double _height = MediaQuery.of(context).size.height;
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
                child: const Text("All",
                    style: TextStyle(
                      fontSize: 16,
                      color: GlobalColors.primaryGreen,
                      decoration: TextDecoration.underline,
                      fontWeight: FontWeight.w800,
                    )),
              ),
            ],
          ),
        ),
        BlocBuilder<ScheduledShowsBloc, ScheduledShowsState>(
          builder: (context, state) {
            if (state is ScheduledShowsLoaded) {
              final shows = state.shows;
              if (shows.isNotEmpty) {
                return _buildScheduledShowView(
                  context,
                  shows.take(5).toList(),
                );
              } else {
                return const Center(
                  child: Text("empty as fuck bro"),
                );
              }
            } else {
              return const LoadingCouch();
            }
          },
        ),
      ],
    );
  }

  Widget _buildScheduledShowView(BuildContext context, List shows) {
    double _width = MediaQuery.of(context).size.width;
    // double _height = MediaQuery.of(context).size.height;
    return
        // kIsWeb
        //     ? SizedBox(
        //         width: _width,
        //         height: _height,
        //         child: StaggeredGridView.countBuilder(
        //           physics: const NeverScrollableScrollPhysics(),
        //           staggeredTileBuilder: (int index) =>
        //               const StaggeredTile.count(1, 1),
        //           mainAxisSpacing: 4.0,
        //           crossAxisSpacing: 2.0,
        //           itemCount: shows.length,
        //           itemBuilder: (context, int index) {
        //             return ScheduleCard(episode: shows[index]);
        //           },
        //           crossAxisCount: 4,
        //         ),
        //       )
        //     :
        SizedBox(
      width: _width,
      child: CarouselSlider.builder(
        options: CarouselOptions(
          enlargeCenterPage: true,
          aspectRatio: 16 / 9,
        ),
        itemCount: 5,
        itemBuilder: (_, index, __) {
          final episode = shows.toList()[index];
          return SizedBox(
            // width: 200,
            child: ScheduleCard(episode: episode),
          );
        },
      ),
    );
  }
}
