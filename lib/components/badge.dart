import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';

class Badge extends StatelessWidget {
  final String description;
  final IconData icon;
  final List<Color> colors;
  final double? size;

  const Badge(
      {Key? key,
      required this.icon,
      required this.colors,
      required this.description,
      this.size = 50})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 8),
      child: InkWell(
        onTap: () {
          Fluttertoast.showToast(msg: description, backgroundColor: colors[0]);
        },
        child: Container(
          width: 54,
          height: 54,
          decoration: BoxDecoration(
              gradient: LinearGradient(
                  stops: const [.33, 1],
                  begin: Alignment.topRight,
                  end: Alignment.bottomLeft,
                  colors: [
                    colors[0],
                    colors[1],
                  ]),
              shape: BoxShape.circle),
          child: Center(
            child: FaIcon(
              icon,
              size: size! * .5,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }
}

class DetailBadge extends StatelessWidget {
  final String text;
  final List<Color> colors;

  const DetailBadge({Key? key, required this.text, required this.colors})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 5.0, vertical: 5),
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
              stops: const [.33, 1],
              begin: Alignment.topRight,
              end: Alignment.bottomLeft,
              colors: [
                colors[0],
                colors[1],
              ]),
          borderRadius: const BorderRadius.all(Radius.circular(50.0)),
          boxShadow: [
            BoxShadow(
              color: colors[0].withOpacity(.3),
              blurRadius: 5,
              spreadRadius: 1,
            )
          ],
        ),
        child: ClipOval(
          child: Container(
            width: MediaQuery.of(context).size.height / 11,
            height: MediaQuery.of(context).size.height / 11,
            padding: const EdgeInsets.all(7),
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
            ),
            child: Center(
              child: AutoSizeText(
                text,
                style: GoogleFonts.poppins(
                    color: Colors.white,
                    fontSize: MediaQuery.of(context).size.height / 20,
                    fontWeight: FontWeight.w700),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
