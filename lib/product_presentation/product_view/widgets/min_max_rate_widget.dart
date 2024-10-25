import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:test_project/product_presentation/product_bloc/product_bloc.dart';

class MaxMinRateWidget extends StatelessWidget {
  final double deviceWidth;
  final List<String> keys;
  final List<double> values;

  const MaxMinRateWidget(
      {super.key,
      required this.deviceWidth,
      required this.keys,
      required this.values});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            ...keys.map((e) => Text(
                  e,
                  style: const TextStyle(fontWeight: FontWeight.w700),
                )),
          ],
        ),
        SizedBox(
          height: deviceWidth * .03,
        ),
        CustomSlider(
          maxVal: values.last,
          minVal: values.first,
        ),
        SizedBox(
          height: deviceWidth * .03,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            ...values.map((e) => Text(
                  e.toString(),
                  style: const TextStyle(fontWeight: FontWeight.w400),
                )),
          ],
        ),
        SizedBox(
          height: deviceWidth * .03,
        ),
      ],
    );
  }
}

class CustomSlider extends StatefulWidget {
  final double minVal;
  final double maxVal;

  const CustomSlider({super.key, required this.maxVal, required this.minVal});

  @override
  State<CustomSlider> createState() => _CustomSliderState();
}

class _CustomSliderState extends State<CustomSlider> {
  late double currentRate;

  late bool showCursorIndicator;

  @override
  void initState() {
    showCursorIndicator = false;
    currentRate = .5;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      final double cursorPosLeft =
          constraints.maxWidth * currentRate - (constraints.maxWidth * .1);
      return Stack(
        clipBehavior: Clip.none,
        alignment: Alignment.center,
        children: [
          Container(
            height: constraints.maxWidth * .03,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(30),
              gradient:
                  const LinearGradient(colors: [Colors.white, Colors.black12]),
            ),
          ),
          Positioned(
            left: 0,
            child: Container(
              height: constraints.maxWidth * .03,
              width: constraints.maxWidth * currentRate,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(30),
                gradient: const LinearGradient(colors: [
                  Colors.lightBlueAccent,
                  Color.fromRGBO(5, 17, 143, 1.0)
                ]),
              ),
            ),
          ),
          Positioned(
            left: cursorPosLeft < 0 ? 0 : cursorPosLeft,
            child: MovingCursor(
              onDragUpdate: (details) {
                setState(() {
                  if (details.localPosition.dx.isNegative) {
                    currentRate =
                        ((details.globalPosition.dx) / constraints.maxWidth);
                    if (currentRate > 1.0) {
                      currentRate = 1;
                    } else if (currentRate < 0.0) {
                      currentRate = 0;
                    }
                  } else {
                    currentRate =
                        ((details.globalPosition.dx) / constraints.maxWidth);
                    if (currentRate > 1.0) {
                      currentRate = 1;
                    } else if (currentRate < 0.0) {
                      currentRate = 0;
                    }
                  }
                });
              },
              onDragEnd: (details) {
                // print(details.localPosition);
                setState(() {
                  showCursorIndicator = false;
                });
                final calculatedRate = calculateRate(
                    fraction: currentRate,
                    max: widget.maxVal,
                    min: widget.minVal);
                context
                    .read<ProductBloc>()
                    .add(PrepareOrderEvent(pickedPrice: calculatedRate));
              },
              onDragStart: (details) {
                setState(() {
                  showCursorIndicator = true;
                });
              },
              cursorSize: constraints.maxWidth * .1,
              onSingleTap: () {
                setState(() {
                  showCursorIndicator = !showCursorIndicator;
                });
                // print('single tap');
              },
            ),
          ),
          Visibility(
            visible: showCursorIndicator,
            child: Positioned(
                left: cursorPosLeft - (constraints.maxWidth * .1 * .4),
                top: -constraints.maxWidth * 0.19,
                child: RateIndicator(
                  rateContent: calculateRate(
                          fraction: currentRate,
                          max: widget.maxVal,
                          min: widget.minVal)
                      .toStringAsFixed(2),
                  rateIndicatorSize: constraints.maxWidth * .1,
                )),
          )
        ],
      );
    });
  }
}

double calculateRate(
    {required double fraction, required double min, required double max}) {
  if (fraction == 0.0) {
    return min;
  }
  final res = ((max - min) * fraction) + min;
  if (res.remainder(res.floor()) < 0.25) {
    return res.floorToDouble();
  } else if (res.remainder(res.floor()) < 0.5) {
    return res.truncateToDouble() + 0.25;
  } else if (res.remainder(res.floor()) < 0.6) {
    return res.floorToDouble() + 0.5;
  } else if (res.remainder(res.floor()) < 0.9) {
    return res.floorToDouble() + 0.75;
  }
  return res.ceilToDouble();
}

class MovingCursor extends StatelessWidget {
  final Function(DragStartDetails) onDragStart;
  final Function(DragEndDetails) onDragEnd;
  final Function(DragUpdateDetails) onDragUpdate;
  final VoidCallback onSingleTap;
  final double cursorSize;

  const MovingCursor(
      {super.key,
      required this.onDragUpdate,
      required this.cursorSize,
      required this.onSingleTap,
      required this.onDragStart,
      required this.onDragEnd});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onPanUpdate: (details) {
        onDragUpdate.call(details);
      },
      onTap: () {
        onSingleTap.call();
      },
      onPanStart: (details) {
        onDragStart.call(details);
      },
      onPanEnd: (details) {
        onDragEnd.call(details);
      },
      child: Stack(
        alignment: Alignment.center,
        children: [
          Container(
            height: cursorSize,
            width: cursorSize,
            decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: Colors.white, width: 3),
                gradient: const LinearGradient(colors: [
                  Colors.lightBlueAccent,
                  Color.fromRGBO(5, 17, 143, 1.0)
                ])),
          ),
          Container(
            height: cursorSize * .5,
            width: cursorSize * .5,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                    color: Colors.black12, blurRadius: 20, spreadRadius: 10)
              ],
              gradient: RadialGradient(radius: 0.8, colors: [
                Colors.lightBlueAccent,
                Color.fromRGBO(5, 17, 143, 1.0),
              ]),
            ),
          )
        ],
      ),
    );
  }
}

class RateIndicator extends StatelessWidget {
  final String rateContent;

  final double rateIndicatorSize;

  const RateIndicator(
      {super.key, required this.rateIndicatorSize, required this.rateContent});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Stack(
          alignment: Alignment.center,
          children: [
            Container(
              height: rateIndicatorSize,
              width: rateIndicatorSize * 1.8,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(rateIndicatorSize * .1),
                gradient: const LinearGradient(colors: [
                  Colors.lightBlueAccent,
                  Color.fromRGBO(5, 17, 143, 1.0),
                ]),
                boxShadow: const [
                  BoxShadow(
                      color: Colors.black12, blurRadius: 20, spreadRadius: 10)
                ],
              ),
            ),
            Container(
              height: rateIndicatorSize * .7,
              width: rateIndicatorSize * 1.8 * .8,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(rateIndicatorSize * .1),
              ),
              child: Center(
                child: Text(
                  rateContent,
                  style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
                ),
              ),
            ),
          ],
        ),
        ClipPath(
          clipper: ArrowClipper(),
          child: Container(
            height: rateIndicatorSize * .5,
            width: rateIndicatorSize * .5,
            decoration: const BoxDecoration(
                gradient: LinearGradient(colors: [
              Colors.lightBlueAccent,
              Color.fromRGBO(5, 17, 143, 1.0)
            ])),
          ),
        ),
      ],
    );
  }
}

class ArrowClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path path = Path();
    path.moveTo(0.0, 0.0);
    path.lineTo(size.width * .5, size.height);
    path.lineTo(size.width, 0.0);
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    return false;
  }
}
