import 'dart:async';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';

class Ex1Page extends StatefulWidget {
  const Ex1Page({Key? key}) : super(key: key);

  @override
  _Ex1PageState createState() => _Ex1PageState();
}

class _Ex1PageState extends State<Ex1Page> {
  late Timer timer;
  late Stopwatch stopwatch;
  var timeElapsed = const Duration(microseconds: 0);
  var lapList = [];
  var isRunning = false;
  @override
  void initState() {
    stopwatch = Stopwatch();

    timer = Timer.periodic(const Duration(milliseconds: 10), timerCallback);
    super.initState();
  }

  @override
  void dispose() {
    stopwatch.stop();
    timer.cancel();
    super.dispose();
  }

  void timerCallback(Timer timer) {
    if (stopwatch.isRunning) {
      setState(() {
        timeElapsed = stopwatch.elapsed;
      });
    }
  }

  /// Convert time elapse to Min:Second:Milli format.
  ///
  String formatTime() {
    String pad2(text) => text.toString().padLeft(2, '0');
    var milli = timeElapsed.inMilliseconds.remainder(1000) ~/ 10;
    var secound = timeElapsed.inSeconds.remainder(60);
    var minute = timeElapsed.inMinutes.remainder(60);
    var hour = timeElapsed.inHours.remainder(24);

    return (hour > 0 ? pad2(hour) + ':' : '') +
        pad2(minute) +
        ':' +
        pad2(secound) +
        '.' +
        pad2(milli);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
          child: SizedBox(
        height: double.infinity,
        width: double.infinity,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.max,
          children: [
            Expanded(
              flex: 3,
              child: FittedBox(
                fit: BoxFit.contain,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10.0),
                  child: Center(
                    child: AutoSizeText(
                      formatTime(),
                      maxLines: 1,
                      textAlign: TextAlign.center,
                      minFontSize: 40,
                      style: const TextStyle(
                          color: Colors.white, fontWeight: FontWeight.w200),
                    ),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 20.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  SizedBox(
                      width: 80,
                      height: 80,
                      child: StyleButton2(
                        backColors: Colors.white,
                        useOpacity: 0.15,
                        buttonText: "ラップ",
                        textColor: Colors.white70,
                        onTap: () {
                          if (stopwatch.isRunning) {
                            lapList.add(formatTime());
                          }
                        },
                      )),
                  Row(
                    children: [
                      Container(
                        width: 8,
                        height: 8,
                        decoration: const BoxDecoration(
                            color: Colors.white, shape: BoxShape.circle),
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      Container(
                        width: 6,
                        height: 6,
                        decoration: const BoxDecoration(
                            color: Colors.white30, shape: BoxShape.circle),
                      )
                    ],
                  ),
                  SizedBox(
                      width: 80,
                      height: 80,
                      child: StyleButton2(
                        backColors: isRunning ? Colors.red : Colors.green,
                        textColor: isRunning ? Colors.red : Colors.green,
                        buttonText: isRunning ? '停止' : '開始',
                        useOpacity: 0.3,
                        onTap: onStartStopTap,
                      ))
                ],
              ),
            ),
            Expanded(
                flex: 2,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: LayoutBuilder(
                    builder: (context, constraints) {
                      var h = constraints.maxHeight;                                //  height of  Divider = 16.
                      int lineNum = (h ~/ (20 + 16));                               //  calculate the number of line to be filled in the bottom.
                      var lineHeight = (h ~/ (lineNum)) - 1.0;                      //  the height of each lap's line.
                      var totalLineItem =                                           //  if number of laps > calculated lineNum.
                          lapList.length > lineNum ? lapList.length : lineNum;      //  totalLineItem = the number of laps.
                      return ListView.builder(
                        itemCount: totalLineItem * 2,
                        itemBuilder: (context, i) {
                          if (i.isEven) {
                            return const Divider(
                              height: 1,
                              color: Colors.white,
                            );
                          }
                          var index = i ~/ 2;
                          return SizedBox(
                              height: lineHeight,
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  if (index < lapList.length)
                                    Text(
                                      'ラップ' + (index + 1).toString(),
                                      textAlign: TextAlign.start,
                                      style: const TextStyle(
                                          fontSize: 18, color: Colors.white),
                                    ),
                                  if (index < lapList.length)
                                    Text(
                                      lapList[index],
                                      textAlign: TextAlign.end,
                                      style: const TextStyle(
                                          fontSize: 18, color: Colors.white),
                                    )
                                ],
                              ));
                        },
                      );
                    },
                  ),
                ))
          ],
        ),
      )),
    );
  }

  void onStartStopTap() {
    if (stopwatch.isRunning) {
      stopwatch.stop();
      setState(() {
        isRunning = false;
      });
    } else {
      stopwatch.reset();
      stopwatch.start();
      setState(() {
        lapList.clear();
        isRunning = true;
      });
    }
  }
}

class StyleButton2 extends StatelessWidget {
  const StyleButton2(
      {Key? key,
      required this.backColors,
      required this.buttonText,
      required this.textColor,
      this.onTap,
      this.useOpacity = 1})
      : super(key: key);
  final Color backColors;
  final Color textColor;
  final String buttonText;
  final Function? onTap;
  final double useOpacity;
  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
        style: OutlinedButton.styleFrom(
            padding: const EdgeInsets.all(5),
            backgroundColor: Colors.transparent,
            shape: const CircleBorder(),
            side: BorderSide(
              width: 2.0,
              color: backColors.withOpacity(useOpacity),
            )),
        onPressed: () {
          if (onTap != null) {
            onTap!();
            return;
          }
        },
        child: LayoutBuilder(
          builder: (context, constraints) {
            return Container(
              width: constraints.maxWidth,
              height: constraints.maxHeight,
              decoration: BoxDecoration(
                  color: backColors.withOpacity(useOpacity),
                  shape: BoxShape.circle),
              child: Center(
                child: Text(buttonText, style: TextStyle(color: textColor)),
              ),
            );
          },
        ));
  }
}
