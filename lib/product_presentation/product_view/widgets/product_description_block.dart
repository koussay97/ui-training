import 'package:flutter/material.dart';
import 'package:test_project/product_presentation/product_view/product_view_widgets.dart';
import 'package:test_project/product_presentation/product_view/widgets/test_dropDown.dart';

enum ContentTypeEnum { valuePairs, dropDow, maxMinRate, plainText }

/// to use this widget :
/// 1- you need to pass [ContentTypeEnum],
/// 2- pass the [blocTitle] in the form of a [List]of[String],
///   ==> the first element will be noted as the key of blockTitle like 'Category' for example
///   the second element is optional, in supplied will be passed as an inline arg to the title
/// 3 - passing the bloc data:
///   ==> if you choose [ContentTypeEnum.valuePairs] :
///       your data should be passed in this format :
///       [{'value': 'bla bla bla value', 'key':'bla bla key'}]
///   ==> if you choose [ContentTypeEnum.maxMinRate] :
///        [
///        {'keys' : ['max customer value', 'min Customer Value']},
///        {'values' : ['3454.0 USD', '4523.0 USD']}
///        ]
///   ==> if you choose [ContentTypeEnum.dropDow]
///       your data like this:
///       ['first item, 'second item' ...']
///   ==> if you choose [ContentTypeEnum.plainText]
///       your data like this :
///       ['bla bla bla ']
class ProductDescriptionBlock extends StatelessWidget {
  final ContentTypeEnum contentTypeEnum;

  /// struct must be passed like this
  /// [
  /// 'category',
  /// 'cosmetics'
  ///  ]
  final List<String> blocTitle;
  final List<dynamic> data;

  const ProductDescriptionBlock(
      {super.key,
      required this.contentTypeEnum,
      required this.blocTitle,
      required this.data});

  @override
  Widget build(BuildContext context) {
    final double deviceWidth = MediaQuery.of(context).size.width;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        /// title section
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.max,
          children: [
            SizedBox(
              //color: Colors.deepPurpleAccent,
              width: deviceWidth * .4,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                        style: const TextStyle(
                            fontSize: 20, fontWeight: FontWeight.w600),
                        maxLines: 1,
                        overflow: TextOverflow.fade,
                        '${blocTitle[0]}:'),
                  ),
                ],
              ),
            ),
            blocTitle.length > 1
                ? Text(
                    maxLines: 1,
                    overflow: TextOverflow.fade,
                    blocTitle[1],
                    style: const TextStyle(color: Colors.black),
                  )
                : const SizedBox.shrink(),
          ],
        ),

        /// content section
        SizedBox(
          height: deviceWidth * .05,
        ),
        ...getListOfContentWidgetsBasedUponEnum(
            contentType: contentTypeEnum, data: data, deviceWidth: deviceWidth),
      ],
    );
  }

  List<Widget> getListOfContentWidgetsBasedUponEnum({
    required ContentTypeEnum contentType,
    required List<dynamic> data,
    required double deviceWidth,
  }) {
    switch (contentType) {
      case ContentTypeEnum.dropDow:
        return [
          CustomDropDownTextField(
              deviceWidth: deviceWidth,
              initialItemIndex: 0,
              items: data as List<String>)
        ];
      case ContentTypeEnum.maxMinRate:
        return data
            .map((e) => MaxMinRateWidget(
                  deviceWidth: deviceWidth,
                  keys: e['keys'],
                  values: e['values'],
                ))
            .toList();
      case ContentTypeEnum.valuePairs:
        return data
            .map(
              (e) => ValuePairsBlock(
                title: e['key'],
                value: e['value'],
                deviceWidth: deviceWidth,
              ),
            )
            .toList();
      default:
        return [
          Column(
            children: [
              Text(
                maxLines: 2,
                overflow: TextOverflow.fade,
                '${data[0]}',
                style: const TextStyle(fontWeight: FontWeight.w400),
              ),
              SizedBox(
                height: deviceWidth * .05,
              ),
            ],
          )
        ];
    }
  }
}