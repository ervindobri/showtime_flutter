import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:show_time/core/utils/navigation.dart';

class ColorfulCard extends StatelessWidget {
  final int index;
  final List<dynamic> data;

  const ColorfulCard({Key? key, required this.index, required this.data})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return Container(
      width: width / 3,
      height: 124,
      decoration: BoxDecoration(
        gradient: LinearGradient(
            begin: Alignment.bottomRight,
            end: Alignment.topLeft,
            colors: [
              Color(data[1]),
              Color(data[2]),
            ]),
        borderRadius: const BorderRadius.all(Radius.circular(24.0)),
        boxShadow: [
          BoxShadow(
              color: Color(data[1]).withOpacity(.15),
              blurRadius: 12.0,
              spreadRadius: -1,
              offset: const Offset(0, 4)),
        ],
      ),
      child: InkWell(
        onTap: () {
          print("navigating - $index");
          NavUtils.navigate(context, '/discover_$index', arguments: data);
        },
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            FaIcon(
              data[3],
              color: Colors.white,
              size: 42,
            ),
            const SizedBox(height: 12),
            Text(
              data[0],
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontFamily: 'Raleway',
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
