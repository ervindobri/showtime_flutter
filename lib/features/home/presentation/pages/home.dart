import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:show_time/controllers/auth_controller.dart';
import 'package:show_time/core/constants/styles.dart';
import 'package:show_time/features/home/presentation/bloc/scheduledshows_bloc.dart';
import 'package:show_time/features/home/presentation/bloc/watched_shows_bloc.dart';
import 'package:show_time/features/home/presentation/widgets/custom_appbar.dart';
import 'package:show_time/features/home/presentation/widgets/home_sections/discover_content.dart';
import 'package:show_time/features/home/presentation/widgets/home_sections/scheduled_content.dart';
import 'package:show_time/features/home/presentation/widgets/home_sliding_panel.dart';
import 'package:flutter/material.dart';
import 'package:show_time/features/home/presentation/widgets/user_greetings.dart';
import 'package:show_time/injection_container.dart';

class HomeView extends StatefulWidget {
  const HomeView({Key? key}) : super(key: key);

  @override
  _HomeViewState createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView>
    with AutomaticKeepAliveClientMixin {
  @override
  Widget build(BuildContext context) {
    final email = sl<AuthController>().currentUserEmail.value;
    super.build(context);
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: GlobalStyles.noAppbar,
        body: MultiBlocProvider(
          providers: [
            BlocProvider.value(
              value: sl<WatchedShowsBloc>()
                ..add(
                  LoadWatchedShowsEvent(email),
                ),
            ),
            BlocProvider.value(
              value: sl<ScheduledShowsBloc>()
                ..add(
                  LoadScheduledShowsEvent(),
                ),
            ),
          ],
          child: Stack(
            children: <Widget>[
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                // crossAxisAlignment: CrossAxisAlignment.start,
                children: const <Widget>[
                  CustomAppbar(),
                  UserGreetings(),
                  SizedBox(height: 24),
                  DiscoverContent(),
                  SizedBox(height: 24),
                  ScheduledContent(),
                ],
              ),
              const HomeSlidingPanel(),
            ],
          ),
        ),
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
