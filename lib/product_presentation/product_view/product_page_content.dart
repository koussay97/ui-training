import 'package:flutter/material.dart';
import 'package:test_project/product_presentation/product_model.dart';
import 'package:test_project/product_presentation/product_view/widgets/back_button_widget.dart';
import 'package:test_project/product_presentation/product_view/widgets/cart_notif_widget.dart';
import 'package:test_project/product_presentation/product_view/widgets/image_reader_widget.dart';
import 'package:test_project/product_presentation/product_view/widgets/view_image_btn.dart';

import 'widgets/product_veiew_widget.dart';

class ProductPageContent extends StatefulWidget {

  final Product? product;

  const ProductPageContent({super.key, required this.product});

  @override
  State<ProductPageContent> createState() => _ProductPageContentState();
}

class _ProductPageContentState extends State<ProductPageContent> {
 late ScrollController scrollController;
 late CarouselController  carouselController;
 late bool shouldHideActionBtns;
 @override
  void initState() {
   carouselController = CarouselController( initialItem: 0);
   shouldHideActionBtns=false;
   scrollController= ScrollController(initialScrollOffset: 0.0);
   super.initState();
  }
  @override
  Widget build(BuildContext context) {

    double deviceWidth = MediaQuery
        .of(context)
        .size
        .width;

    return Scaffold(
      backgroundColor: const Color.fromRGBO(229, 228, 228, 1.0),
      appBar: AppBar(

        actions: const [
          CartNotificationWidget(),
        ],
        leading: const BackButtonWidget(),
        centerTitle: true,
        backgroundColor: const Color.fromRGBO(229, 228, 228, 1.0),
        title: Text(pTest.name, style: const TextStyle(fontWeight: FontWeight.w700),),
        elevation: 2,
      ),

      body: CustomScrollView(
      scrollDirection: Axis.vertical,
        controller: scrollController,
        slivers: [
          SliverAppBar(
            actions: shouldHideActionBtns?null:[
              ViewImageBtn(width: deviceWidth*0.1,height: deviceWidth*0.1, icon: Icons.remove_red_eye_outlined,),
              ViewImageBtn(width: deviceWidth*0.1,height: deviceWidth*0.1, icon: Icons.arrow_drop_down_circle_outlined,),
              ViewImageBtn(width: deviceWidth*0.1,height: deviceWidth*0.1, icon: Icons.cloud_download_outlined,)
            ],
            backgroundColor: Colors.white.withOpacity(0.0),
            pinned: true,
            floating: true,
            expandedHeight: deviceWidth,
            collapsedHeight: deviceWidth*.6,
            flexibleSpace: CarouselView(
              onTap: (imageIndex){

              },
              controller: carouselController,
              padding: EdgeInsets.zero,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),),
              itemSnapping: true,
              scrollDirection: Axis.horizontal,
              shrinkExtent: deviceWidth,
              itemExtent: deviceWidth,
              children: [
                ... (pTest?.images ?? []).isNotEmpty ? pTest!.images.map((
                    el) =>
                    ImageReaderWidget(
                      onImageErrorHideActionCallBack: (val){
                        WidgetsBinding.instance.addPostFrameCallback((_){
                          setState(() {
                            shouldHideActionBtns=val;
                          });
                        });
                      },
                      fit: BoxFit.cover,
                      width: deviceWidth,
                      height: deviceWidth * .6,
                      employ404image: true,
                      imageUrl: el,
                    )).toList() : [
                      ImageReaderWidget(
                  fit: BoxFit.cover,
                  width: deviceWidth,
                  height: deviceWidth * .6,
                  employ404image: true,
                  imageUrl: '--',
                )
                ],
              ],

            ),

          ),

          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
            sliver: SliverMainAxisGroup(
                slivers: [
                  SliverToBoxAdapter(
                    child: ProductDescriptionBlock(
                      blocTitle: ['Category',pTest.category??'--'],
                      contentTypeEnum: ContentTypeEnum.plainText,
                      data: [pTest?.categoryDescription??''],
                    ),
                  ),
                  SliverToBoxAdapter(
                    child: ProductDescriptionBlock(
                      blocTitle: ['Criteria'],
                      contentTypeEnum: ContentTypeEnum.valuePairs,
                      data: [
                        {'key': 'Manifacturing Place', 'value': pTest?.manifacturerLocation??'--'},
                        {'key': 'Type of Importation', 'value': pTest?.typeOfImportation??'--'},
                        {'key': 'Target gender', 'value': pTest?.targetGender??'--'},
                        {'key': 'Benchmark Name', 'value': pTest?.benchMarkName??'--'},
                        {'key': 'Usage', 'value': pTest?.whereToUse??'--'},
                        {'key': 'Function', 'value': pTest?.function??'--'},
                        {'key': 'Type', 'value': pTest?.whereToUse??'--'},
                      ],
                    ),

                  ),
                  SliverToBoxAdapter(
                    child: ProductDescriptionBlock(
                      blocTitle: ['Color Of Product'],
                      contentTypeEnum: ContentTypeEnum.dropDow,
                      data:
                      pTest.availableColors,
                    ),
                  ),
                  SliverToBoxAdapter(
                    child: ProductDescriptionBlock(
                      data:   [
                              {'keys' : ['Min Customer value', 'Max Customer Value'], 'values' : [pTest.minPrice, pTest.maxPrice] },
                             ],
                      contentTypeEnum: ContentTypeEnum.maxMinRate,
                      blocTitle: ['Customer Price'],
                    ),
                  ),

                ]
            ),
          ),

          SliverToBoxAdapter(
            child: PaymentUiBloc(
              totalPrice: '11170 USD',
              width: deviceWidth,
              height: deviceWidth*.3,
            ),
          ),

        ]

      ),


    );
  }
 static Product pTest = Product(

   categoryDescription: 'decorate your pocket',
   targetGender: 'All Genders',
   name: 'Mighty IPhone 20',
     images: [
       'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTL2nQIfCo451Zl-_pbY4R1s1tMHueIhJkdCA&s',
       'https://media.istockphoto.com/id/1415633498/vector/3d-realistic-high-quality-smartphone-mockup-isolated-with-white-blank-screen-smart-phone.webp?s=2048x2048&w=is&k=20&c=FfgHjmLFiDVylDj7kyYh_6ZgSPUj97HnZR3ZEpvCMzw=',
       'https://i.ytimg.com/vi/XYo0VbxloN4/hq720.jpg?sqp=-oaymwEhCK4FEIIDSFryq4qpAxMIARUAAAAAGAElAADIQj0AgKJD&rs=AOn4CLDIUPNTZogzT0xkC9j7jpF5p9so7g',
       'https://data:image/jpeg;base64,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',
     ],
     availableColors: ['red', 'pink', 'blue', 'magento', 'Brigah Zayanaaah'],
     id: '34',
     benchMarkName: 'Samsung',
     category: 'smart-phones',
     color: 'red',
     createdAt: DateTime(2022,02,01),
     function: 'dial with it',
     manifacturerLocation: 'Great China',
     maxPrice: 3400,
     minPrice: 3250,
     typeOfImportation: 'by sea',
     updatedAt: DateTime.now(),
     whereToUse: 'where people usually use iphones');
}

