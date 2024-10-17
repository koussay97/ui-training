

import 'package:flutter/material.dart';

class PaymentUiBloc extends StatelessWidget {
  final double height;
  final double width;
  final String totalPrice;

  const PaymentUiBloc({super.key,required this.totalPrice, required this.height, required this.width});

  @override
  Widget build(BuildContext context) {
    final double deviceWidth= MediaQuery.of(context).size.width;
    return Container(
     // height: height,
      width: width,

      decoration:  BoxDecoration(
        color: Colors.white,
         borderRadius: BorderRadius.circular(10),
      ),

      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
              const Text('Total Price: ', style: TextStyle(color: Colors.black87, fontWeight: FontWeight.w800 , ),),
              Text(totalPrice, style: const TextStyle(color: Colors.green, fontWeight: FontWeight.w800 , ),),
            ],
            ),
          SizedBox(height: 20,),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
             // FilledButton(deviceWidth:deviceWidth , title: 'Share with your friends',),
              FilledButton(deviceWidth:deviceWidth , title: 'Share with your friends', onTapFilledBtn: (){ },),
              OutlineButton(deviceWidth:deviceWidth , title: 'Share with your friends',onTapOutlineBtn: (){

              },),
            ],
          )
          ],
        ),
      ),
    );
  }
}

class FilledButton extends StatelessWidget {
  final VoidCallback onTapFilledBtn;
  final double deviceWidth;
  final String title;
  const FilledButton({
    super.key,
     required this.onTapFilledBtn,
    required this.title,
    required this.deviceWidth
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
     onTap: (){
       onTapFilledBtn.call();
       debugPrint('tappede peculiar outline btn outline');

     },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        height: deviceWidth*.1,
        width: deviceWidth*.4,
        decoration:  BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          gradient: const LinearGradient(colors: [
            Colors.lightBlueAccent,
            Color.fromRGBO(5, 17, 143, 1.0)
          ]),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              title,
              style:
            const TextStyle(
              color: Colors.white,
                 fontSize:  9, fontWeight: FontWeight.w700),
            ),
        // SizedBox(width: 5,),
         Container(
           alignment: Alignment.center,
           height: 15,
             width: 15,
             decoration: BoxDecoration(
               borderRadius: BorderRadius.circular(40),
               color: Colors.white,
             ),
             child: ShaderMask(
                 shaderCallback: (rect){
                   return  const LinearGradient(colors: [
                     Colors.lightBlueAccent,
                     Color.fromRGBO(5, 17, 143, 1.0)

                   ]).createShader(rect);
                 },
                 child: const Icon(Icons.send,size: 10, color: Colors.white,))),
          ],
        ),
      ),
    );
  }
}

class OutlineButton extends StatelessWidget {
  final String title;
  final double deviceWidth;
  final VoidCallback onTapOutlineBtn;
  const OutlineButton({super.key,
    required this.onTapOutlineBtn,
    required this.deviceWidth, required this.title});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (){
        onTapOutlineBtn.call();
        debugPrint('tappede peculiar outline btn outline');
      },
      child: Stack(
        alignment: Alignment.center,
        children: [
          Container(
            //padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
            height: deviceWidth*.1,
            width: deviceWidth*.4,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              gradient:  const LinearGradient(colors: [
                Colors.lightBlueAccent,
                Color.fromRGBO(5, 17, 143, 1.0)
              ])

            ),
          ),
          Container(
            alignment: Alignment.center,
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            height: deviceWidth*.08,
            width: deviceWidth*.38,
            decoration: BoxDecoration(
              color: Colors.white,

              borderRadius: BorderRadius.circular(9)
            ),
            child: ShaderMask(
            shaderCallback: (rect){
              return const LinearGradient(colors: [
                Colors.lightBlueAccent,
                Color.fromRGBO(5, 17, 143, 1.0)
              ]).createShader(rect);
            },
              child: Row(
                children: [
                  Text(
                    title,
                    style:
                    const TextStyle(
                        color: Colors.white,
                        fontSize:  9, fontWeight: FontWeight.w700),
                  ),
                  Icon(Icons.share, size: 15,color: Colors.white,)

                ],
              )
            ),
          )

        ],
      ),
    );
  }
}
