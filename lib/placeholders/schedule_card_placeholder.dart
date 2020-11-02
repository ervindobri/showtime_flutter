
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ScheduleCardPlaceholder extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    double _width = MediaQuery.of(context).size.width;
    double _height = MediaQuery.of(context).size.height;
    const BorderRadius _radius = BorderRadius.all(Radius.circular(25.0));
    const BorderRadius _leftRadius = BorderRadius.only(
      topLeft:  Radius.circular(75.0),
      bottomRight: Radius.circular(25.0),
      bottomLeft: Radius.circular(25.0),
      topRight: Radius.circular(25.0),
    );

    return Padding(
      padding: const EdgeInsets.only(top: 25.0),
      child: Container(
          width: _width / 1.7,
          height: _height / 2.3,
          // color: CupertinoColors.black,
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  height: _height/30,
                  width: _width/3,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: _radius,
                    boxShadow: [ new BoxShadow(
                        color: Colors.black.withOpacity(.3),
                        blurRadius: 15.0,
                        spreadRadius:-4,
                        offset: Offset(0, 5)),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  height: _height/20,
                  width: _width/2.5,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: _radius,
                    boxShadow: [ new BoxShadow(
                        color: Colors.black.withOpacity(.3),
                        blurRadius: 15.0,
                        spreadRadius:-4,
                        offset: Offset(0, 5)),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        height: 50,
                        width: _width/7,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: _radius,
                          boxShadow: [ new BoxShadow(
                              color: Colors.black.withOpacity(.3),
                              blurRadius: 15.0,
                              spreadRadius:-4,
                              offset: Offset(0, 5)),
                          ],
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        height: 50,
                        width: _width/7,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: _radius,
                          boxShadow: [ new BoxShadow(
                              color: Colors.black.withOpacity(.3),
                              blurRadius: 15.0,
                              spreadRadius:-4,
                              offset: Offset(0, 5)),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  height: _height/15,
                  width: _width/3,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: _radius,
                    boxShadow: [ new BoxShadow(
                        color: Colors.black.withOpacity(.3),
                        blurRadius: 15.0,
                        spreadRadius:-4,
                        offset: Offset(0, 5)),
                    ],
                  ),
                ),
              ),

            ],
          )
        ),
    );
  }
}
