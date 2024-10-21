
import 'package:flutter/material.dart';
class ValuePairsBlock extends StatelessWidget {
  final String title;
  final String value;
  final double deviceWidth;

  const ValuePairsBlock(
      {super.key,
        required this.title,
        required this.value,
        required this.deviceWidth});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(
              width: deviceWidth * .4,
              child: Text(
                '$title :',
                maxLines: 1,
                overflow: TextOverflow.fade,
                style: const TextStyle(fontWeight: FontWeight.w500),
              ),
            ),
            Expanded(
              child: Text(
                '$value',
                maxLines: 2,
                overflow: TextOverflow.fade,
                style: const TextStyle(fontWeight: FontWeight.w400),
              ),
            ),
          ],
        ),
        SizedBox(
          height: deviceWidth * .03,
        ),
      ],
    );
  }
}