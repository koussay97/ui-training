import 'package:flutter/material.dart';

class PageIndicator extends StatelessWidget {

  final double dotSize;
  final List<Color> selectedColors;
  final List<Color> emptyColors;
  final int selectedIndex;
  final int itemsLength;

  const PageIndicator(
      {super.key,

      required this.selectedIndex,
      required this.dotSize,
      required this.emptyColors,
      required this.itemsLength,
      required this.selectedColors});

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      scrollDirection: Axis.horizontal,
      padding: EdgeInsets.zero,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
        itemBuilder: (context, index){
        return Container(
          height: dotSize,
          width: dotSize,
          decoration: BoxDecoration(
            gradient: LinearGradient(colors: index==selectedIndex? selectedColors: emptyColors),
            shape: BoxShape.circle,
            boxShadow: const [BoxShadow(color: Colors.black12,blurRadius: 20,spreadRadius: 10)],

          ),
        );
        },
        separatorBuilder: (context , index){
        if(index==itemsLength-1){
          return const SizedBox.shrink();
        }
        return SizedBox(width: dotSize*.5,);
        },
        itemCount: itemsLength);
  }
}
