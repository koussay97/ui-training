import 'package:flutter/material.dart';

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
          CustomDropDown(
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

class CustomDropDown extends StatefulWidget {
  final double deviceWidth;
  final List<String> items;
  final int initialItemIndex;

  const CustomDropDown(
      {super.key,
      required this.deviceWidth,
      required this.initialItemIndex,
      required this.items});

  @override
  State<CustomDropDown> createState() => _CustomDropDownState();
}

class _CustomDropDownState extends State<CustomDropDown> {
  late String currentValue;

  @override
  void initState() {
    currentValue = widget.items[widget.initialItemIndex];
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border.all(color: Colors.black87),
            borderRadius: BorderRadius.circular(30),
          ),
          child: DropdownButton<String>(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              //borderRadius: BorderRadius.circular(30),

              isExpanded: true,
              menuWidth: widget.deviceWidth,
              style: const TextStyle(
                  fontWeight: FontWeight.w700, color: Colors.black),
              value: currentValue.isNotEmpty ? currentValue : null,
              icon: const Icon(Icons.arrow_drop_down),
              items: widget.items
                  .map((e) => DropdownMenuItem<String>(
                        value: e,
                        child: Text(
                          overflow: TextOverflow.fade,
                          maxLines: 2,
                          e,
                          style: const TextStyle(color: Colors.black),
                        ),
                      ))
                  .toList(),
              onChanged: (v) {
                if (v != null) {
                  setState(() {
                    currentValue = v;
                  });
                }
              }),
        ),
        SizedBox(
          height: widget.deviceWidth * .03,
        ),
      ],
    );
  }
}

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
        Container(
          height: deviceWidth * .05,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(30),
            gradient: const LinearGradient(
                colors: [Colors.redAccent, Colors.deepPurpleAccent]),
          ),
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
