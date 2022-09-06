import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:show_time/components/loading_couch.dart';
import 'package:show_time/controllers/show_controller.dart';
import 'package:show_time/core/constants/custom_variables.dart';
import 'package:show_time/core/constants/styles.dart';
import 'package:show_time/core/utils/navigation.dart';
import 'package:show_time/features/home/data/models/episode.dart';
import 'package:show_time/features/home/presentation/bloc/scheduledshows_bloc.dart';
import 'package:show_time/injection_container.dart';
import 'package:show_time/ui/schedule_card.dart';

class ScheduledContent extends StatefulWidget {
  const ScheduledContent({Key? key}) : super(key: key);

  @override
  State<ScheduledContent> createState() => _ScheduledContentState();
}

class _ScheduledContentState extends State<ScheduledContent> {
  // final ScrollController _scheduleScrollController = ScrollController();
  final CarouselController controller = CarouselController();
  int _current = 0;

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
                      fontWeight: FontWeight.w700,
                    )),
              ),
            ],
          ),
        ),
        BlocConsumer<ScheduledShowsBloc, ScheduledShowsState>(
          listener: (_, state) {
            if (state is ScheduledShowsLoaded) {
              sl<ShowController>().notAiredList.value =
                  state.shows as List<Episode>;
            }
          },
          builder: (context, state) {
            if (state is ScheduledShowsLoaded) {
              final shows = state.shows;
              if (shows.isNotEmpty) {
                return _buildScheduledShowView(
                  context,
                  shows.take(5).toList(),
                );
              }
              return const Center(child: Text("empty as fuck bro"));
            } else {
              return const LoadingCouch();
            }
          },
        ),
      ],
    );
  }

  Widget _buildScheduledShowView(BuildContext context, List listOfEpisodes) {
    double _width = MediaQuery.of(context).size.width;
    // double _height = MediaQuery.of(context).size.height;
    return SizedBox(
      width: _width,
      child: Column(
        children: [
          CarouselSlider.builder(
            carouselController: controller,
            options: CarouselOptions(
              enlargeCenterPage: true,
              clipBehavior: Clip.none,
              aspectRatio: 16 / 9,
              onPageChanged: (index, reason) {
                setState(() => _current = index);
              },
            ),
            itemCount: 5,
            itemBuilder: (_, index, __) {
              final episode = listOfEpisodes.toList()[index];
              return ScheduleCard(episode: episode);
            },
          ),
          const SizedBox(height: 24),
          ValueListenableBuilder(
              valueListenable: ValueNotifier(_current),
              builder: (context, value, __) {
                return Wrap(
                  spacing: 8,
                  children: List.generate(
                    listOfEpisodes.length,
                    (index) => Container(
                      width: 8,
                      height: 8,
                      decoration: BoxDecoration(
                          color: value == index
                              ? GlobalColors.primaryGreen
                              : GlobalColors.primaryGreen.withOpacity(.2),
                          shape: BoxShape.circle),
                    ),
                  ),
                );
              })
        ],
      ),
    );
  }
}
