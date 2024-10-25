
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:test_project/product_presentation/product_bloc/product_bloc.dart';
import 'package:test_project/product_presentation/product_bloc/product_bloc_utils.dart';
import 'package:test_project/product_presentation/product_view/product_view_widgets.dart';
class CustomDropDownTextField extends StatefulWidget {
  final double deviceWidth;
  final List<String> items;
  final int initialItemIndex;


  const CustomDropDownTextField(
      {super.key,
        required this.deviceWidth,
        required this.initialItemIndex,
        required this.items});

  @override
  State<CustomDropDownTextField> createState() => _CustomDropDownTextFieldState();
}

class _CustomDropDownTextFieldState extends State<CustomDropDownTextField> {

  final OverlayPortalController _overlayPortalController = OverlayPortalController();

  final _link = LayerLink();

  late int currentIndex;
  late TextEditingController controller;
  @override
  void initState() {
    currentIndex = widget.initialItemIndex;
    controller = TextEditingController(text: widget.items[currentIndex]);
    super.initState();
  }


  @override
  void dispose() {
    _overlayPortalController.hide();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Stack(
          clipBehavior: Clip.none,
          alignment: Alignment.center,
          children: [
            Container(
                padding: const EdgeInsets.only(left: 10),
                decoration: const BoxDecoration(
                  color: Colors.white,
                 // boxShadow:  [BoxShadow(color: Colors.black12,blurRadius: 20,spreadRadius: 10)],
                  borderRadius:   BorderRadius.only(topRight: Radius.circular(10), bottomLeft: Radius.circular(10) ),
                ),
                height: widget.deviceWidth*.13,
                width: widget.deviceWidth,
                child: Center(
                  child: TextField(
                    onChanged: (value){
                      context.read<ProductBloc>().add(PrepareOrderEvent(colorVariant: value));
                    },
                    style: const TextStyle(color: Colors.black, fontWeight: FontWeight.w700),
                    controller: controller,
                    decoration: const InputDecoration(
                        enabled: false,
                        border: InputBorder.none
                    ),
                  ),
                )
            ),

            Positioned(
              right: 10,
              child: DropDownButton(
                overLayDropDownMenuVerticalOffset: 30,
                overLayDropDownMenuHorizontalOffset: 10,
                initialIndex: currentIndex,
                onSelectionChanges: (selectedElementIndex){
                  setState(() {
                    controller.text = widget.items[selectedElementIndex];
                    currentIndex = selectedElementIndex;
                  });
                },
                link:_link ,
                buttonSize: 30,
                dropDownMenuHeight: 200,
                listOfItems: widget.items,
                overlayPortalController: _overlayPortalController,
                btnBackground: Colors.white,
                btnColor: Colors.teal,
                dropDownMenuWidth: widget.deviceWidth - 20,

              ),),

          ],
        ),
        SizedBox(
          height: widget.deviceWidth * .03,
        ),

      ],
    );
  }
}

class DropDownButton extends StatefulWidget {

  final double overLayDropDownMenuVerticalOffset;
  final double overLayDropDownMenuHorizontalOffset;
  final int initialIndex;
  final List<String> listOfItems;
  final double dropDownMenuHeight;
  final double dropDownMenuWidth;
  final Color? btnBackground;
  final Color? btnColor;
  final RadialGradient? gradient;
  final double buttonSize;
  final OverlayPortalController overlayPortalController;
  final LayerLink link;
  final Function(int) onSelectionChanges;

  const DropDownButton({
    super.key,
    required this.overLayDropDownMenuVerticalOffset,
    required this.overLayDropDownMenuHorizontalOffset,
    required this.initialIndex,
    required this.onSelectionChanges,
    required this.dropDownMenuWidth,
    required this.listOfItems,

    required this.dropDownMenuHeight,
    this.btnColor,
    this.gradient,
    required this.buttonSize,
    required this.overlayPortalController,
    this.btnBackground,
    required this.link});

  @override
  State<DropDownButton> createState() => _DropDownButtonState();
}

class _DropDownButtonState extends State<DropDownButton> {
  @override
  Widget build(BuildContext context) {
    final double deviceWidth= MediaQuery.of(context).size.width;

    return CompositedTransformTarget(
      link: widget.link,
      child: OverlayPortal(
        controller: widget.overlayPortalController,
        overlayChildBuilder: (context){
          return Positioned(
            width: widget.dropDownMenuWidth,
            child: CustomDropdownBox(
              onSelectionChanges: (index)async{
                print('picked ======== index');
                print(index);
                widget.onSelectionChanges.call(index);
                await Future.delayed(const Duration(milliseconds: 100));
                widget.overlayPortalController.hide();
              },
              offsetX: widget.overLayDropDownMenuHorizontalOffset,
              offsetY: widget.overLayDropDownMenuVerticalOffset,
              link: widget.link,
              initialIndex: widget.initialIndex,
              dropDownMaxHeight: widget.dropDownMenuHeight,
              dropDownWidth: widget.dropDownMenuWidth,
              items: widget.listOfItems,
            ),
          );
        },
        child: GestureDetector(
          onTap: (){
          widget.overlayPortalController.toggle();
          },
          child: Container(
            padding: EdgeInsets.all(widget.buttonSize*.06),
            height: widget.buttonSize,
            width: widget.buttonSize,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(widget.buttonSize* .1),
              boxShadow: const [BoxShadow(color: Colors.black12,blurRadius: 20,spreadRadius: 10)],
              color: widget.btnBackground,
              gradient: widget.gradient,
            ),
            child: Center(
              child: Icon(
                Icons.arrow_drop_down,
                color: widget.btnColor,),
            ),
          ),
        ),
      ),
    );
  }
}

class CustomDropdownBox extends StatefulWidget {

  final double offsetX;

  final double offsetY;

  final double dropDownWidth;

  final double dropDownMaxHeight;

  final LayerLink link;

  final List<String>items;

  final int initialIndex;

  final Function(int) onSelectionChanges;
  const CustomDropdownBox({
    super.key,
    required this.offsetX,
    required this.onSelectionChanges,
    required this.offsetY,
    required this.dropDownMaxHeight,
    required this.dropDownWidth,
    required this.items,
    required  this.initialIndex,
    required this.link});

  @override
  State<CustomDropdownBox> createState() => _CustomDropdownBoxState();
}

class _CustomDropdownBoxState extends State<CustomDropdownBox> {
  late int currentIndex;
  @override
  void initState() {
   currentIndex = widget.initialIndex;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return CompositedTransformFollower(
      offset: Offset(widget.offsetX,widget.offsetY),
      showWhenUnlinked: false,
      followerAnchor: Alignment.topRight,
      targetAnchor: Alignment.bottomRight,
      link: widget.link,
      child: Container(
        clipBehavior: Clip.hardEdge,
        height: widget.dropDownMaxHeight,
        padding: const EdgeInsets.all(10),
        decoration: const BoxDecoration(
          boxShadow:  [BoxShadow(color: Colors.black12,blurRadius: 20,spreadRadius: 10)],
          borderRadius: BorderRadius.only(topLeft: Radius.circular(10),bottomRight: Radius.circular(10)),
          gradient: RadialGradient(
              colors: [
                Color.fromRGBO(255, 255, 255, 1.0),
                Color.fromRGBO(255, 255, 255, 1.0),
              ],
              radius: 2,
              stops: [0.2, 1,]
          ),
        ),
        child: ListView.separated(
          shrinkWrap: true,
          itemBuilder: (context , index){
              return GestureDetector(
              onTap: (){
                setState(() {
                  currentIndex =index;
                });
              },
                child: AnimatedContainer(
                  onEnd: (){
                    widget.onSelectionChanges.call(currentIndex);
                  },
                  duration: const Duration(milliseconds: 200),
                  curve: Curves.easeOutExpo,
                  padding: index == currentIndex? const EdgeInsets.symmetric(horizontal: 20):EdgeInsets.zero,
                  height: 40,
                 width: double.infinity,
                 decoration: BoxDecoration(
                   borderRadius: BorderRadius.circular(widget.dropDownMaxHeight*.01),
                   color: currentIndex ==index? const Color.fromRGBO(33, 33, 33, 1.0): Colors.white
                 ),
                 child: Row(
                   crossAxisAlignment: CrossAxisAlignment.center,
                   mainAxisSize: MainAxisSize.min,
                   children: [
                     Text(
                       widget.items[index],
                       style:  TextStyle(
                         fontSize: 15,
                         fontWeight: FontWeight.w600,
                         color: currentIndex ==index? Colors.white : const Color.fromRGBO(100, 99, 99, 1.0),
                       ),)
                   ],),
                ),
              );


          },
          separatorBuilder: (context , index) {
            return  SizedBox(
              width: widget.dropDownWidth,
              height: 10,
              child: const DashedSeparator(),
            );
          },
          itemCount: widget.items.length,

        ),
      ),
    );
  }
}


