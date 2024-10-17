import 'dart:math';

import 'package:flutter/material.dart';

class ViewImageBtn extends StatelessWidget {
  final IconData icon;
  final double height;
  final double width;
  const ViewImageBtn({super.key, required this.height, required this.width, required this.icon});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 10),
      child: GestureDetector(
        onTap: (){
          debugPrint('tapped peculiar icon');
        },
        child: Stack(
          alignment: Alignment.center,
          children: [
            ClipPath(
              clipper: const HoleClipper(holeRadiusRatio: 0.7),
              child: Container(
                width: width,
                height: width,
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(width*2)
                ),

              ),
            ),
            Positioned(
              width: width*0.4,
                child: Container(
                  height: width*.4,
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(width)
                  ),
                  child: Center(child: Icon(icon, color: Colors.black,size: width*0.3,)),
                ))
          ],
        ),
      ),
    );
  }
}


class HoleClipper extends CustomClipper<Path> {
  const HoleClipper({
    this.holeRadiusRatio = 0.5,
  });

  final double holeRadiusRatio;

  @override
  Path getClip(Size size) {
    Path path = Path();
    path.fillType = PathFillType.evenOdd;
    path.addRect(Rect.fromLTWH(0, 0, size.width, size.height));

    final holeSize = min(size.width, size.height) * holeRadiusRatio;
    path.addOval(
      Rect.fromCenter(
        center: Offset(size.width / 2, size.height / 2),
        width: holeSize,
        height: holeSize,
      ),
    );

    return path;
  }

  @override
  bool shouldReclip(covariant HoleClipper oldClipper) =>false;
}
