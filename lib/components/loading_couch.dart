import 'package:flare_flutter/flare_actor.dart';
import 'package:flutter/cupertino.dart';
import 'package:show_time/core/constants/custom_variables.dart';

class LoadingCouch extends StatelessWidget {
  final Color color;
  const LoadingCouch({Key? key, this.color = GlobalColors.primaryGreen})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
        width: MediaQuery.of(context).size.width * .5,
        height: MediaQuery.of(context).size.height * .2,
        child: Center(
          child: FlareActor("assets/loadingcouch.flr",
              alignment: Alignment.bottomCenter,
              fit: BoxFit.contain,
              color: color,
              animation: "load"),
        ),
      ),
    );
  }
}
