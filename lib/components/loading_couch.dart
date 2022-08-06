import 'package:flare_flutter/flare_actor.dart';
import 'package:flutter/cupertino.dart';

class LoadingCouch extends StatelessWidget {
  const LoadingCouch({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
        width: MediaQuery.of(context).size.width * .5,
        height: MediaQuery.of(context).size.height * .2,
        // color: Colors.black,
        child: const Center(
          child: FlareActor("assets/loadingcouch.flr",
              alignment: Alignment.bottomCenter,
              fit: BoxFit.contain,
              animation: "load"),
        ),
      ),
    );
  }
}
