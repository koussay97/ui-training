
import 'package:flutter/material.dart';
class BackButtonWidget extends StatelessWidget {
  const BackButtonWidget({super.key});

  @override
  Widget build(BuildContext context) {
    double deviceWidth= MediaQuery.of(context).size.width;
    return GestureDetector(
      onTap: (){
        debugPrint('back to home screen');
        // Navigator.of(context).pop();
      },
      child: SizedBox(
        height: deviceWidth*0.08,
        width: deviceWidth*0.08,
        // todo :: replace the icon with the SVG from figma
        child:  Icon(Icons.chevron_left, size: deviceWidth*0.08,),
      ),
    );
  }
}
