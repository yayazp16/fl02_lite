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
  @override
  void initState() {
    stopwatch = Stopwatch();

    timer = Timer.periodic(const Duration(milliseconds: 10), timerCallback);
    super.initState();
  }

  void timerCallback(Timer timer) {
    if (stopwatch.isRunning) {
      setState(() {
        timeElapsed = stopwatch.elapsed;
      });
    } else if (stopwatch.elapsedTicks != 0) {
      stopwatch.reset();

      setState(() {
        lapList.clear();
        timeElapsed = const Duration(milliseconds: 0);
      });
    }
  }

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
                      child: StyleButton(
                        forcedColor: Colors.white.withOpacity(0.15),
                        forecedText: "ラップ",
                        forcedTextColor: Colors.white70,
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
                      child: StyleButton(
                        stopwatch: stopwatch,
                        startText: '開始',
                        startColor: Colors.green,
                        stopText: '停止',
                        stopColor: Colors.red,
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
                      var h = constraints.maxHeight;
                      int memoNum = (h ~/ (20 + 16));
                      // height of  Divider = 16
                      var memoHeight = (h ~/ (memoNum)) - 1.0;
                      var toatlNum =
                          lapList.length > memoNum ? lapList.length : memoNum;
                      return ListView.builder(
                        itemCount: toatlNum * 2,
                        itemBuilder: (context, i) {
                          if (i.isEven) {
                            return const Divider(
                              height: 1,
                              color: Colors.white,
                            );
                          }
                          var index = i ~/ 2;
                          return SizedBox(
                              height: memoHeight,
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
}

class StyleButton extends StatelessWidget {
  const StyleButton(
      {Key? key,
      this.stopwatch,
      this.forcedColor,
      this.startColor,
      this.stopColor,
      this.startText,
      this.stopText,
      this.forecedText,
      this.forcedTextColor,
      this.onTap})
      : super(key: key);

  final Stopwatch? stopwatch;
  final Color? forcedColor;
  final Color? forcedTextColor;
  final String? forecedText;
  final Color? startColor;
  final Color? stopColor;
  final String? startText;
  final String? stopText;
  final Function? onTap;
  @override
  Widget build(BuildContext context) {
    late Color backColors;
    late String buttonText;

    if (stopwatch != null) {
      var check = stopwatch!.isRunning;
      backColors = check ? stopColor ?? Colors.red : startColor ?? Colors.green;
      buttonText = check ? stopText ?? '' : startText ?? '';
    }
    return OutlinedButton(
        style: OutlinedButton.styleFrom(
            padding: const EdgeInsets.all(5),
            backgroundColor: Colors.transparent,
            shape: const CircleBorder(),
            side: BorderSide(
              width: 2.0,
              color: forcedColor ?? backColors.withOpacity(0.3),
            )),
        onPressed: () {
          if (onTap != null) {
            onTap!();
            return;
          }
          if (stopwatch != null) {
            stopwatch!.isRunning ? stopwatch!.stop() : stopwatch!.start();
          }
        },
        child: LayoutBuilder(
          builder: (context, constraints) {
            return Container(
              width: constraints.maxWidth,
              height: constraints.maxHeight,
              decoration: BoxDecoration(
                  color: forcedColor ?? backColors.withOpacity(0.3),
                  shape: BoxShape.circle),
              child: Center(
                child: Text(forecedText ?? buttonText,
                    style: TextStyle(color: forcedTextColor ?? backColors)),
              ),
            );
          },
        ));
  }
}
