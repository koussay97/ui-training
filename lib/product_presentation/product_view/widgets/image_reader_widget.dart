

import 'package:flutter/material.dart';
import 'package:liquid_progress_indicator/liquid_progress_indicator.dart';


class ImageReaderWidget extends StatefulWidget {
  final double width;
  final String imageUrl;
  final double? imageBoxRadius;
  final Color? loaderEmptyColor;
  final Color? textColor;
  final Color? loaderFillColor;
  final Color? loaderBorderColor;
  final double height;
  final double? innerPadding;
  final BoxFit? fit;
  final bool employ404image;
  final Function(bool)? onImageErrorHideActionCallBack;
  const ImageReaderWidget({
    super.key,
    this.textColor,
    this.onImageErrorHideActionCallBack,
    this.loaderBorderColor,
    this.loaderFillColor,
    this.loaderEmptyColor,
    this.imageBoxRadius,
    this.innerPadding,
    required this.employ404image,
    required this.imageUrl,
    required this.width,
    required this.height,
    required this.fit,
  });

  @override
  ImageReaderWidgetState createState() => ImageReaderWidgetState();
}

class ImageReaderWidgetState extends State<ImageReaderWidget> {
  double _loadingProgress = 0.0;
  late ImageStream stream;
  late ImageStreamListener listener;
 late bool haseError;
  @override
  void initState() {
    super.initState();
    haseError = false;
    listener =  ImageStreamListener(
            (info, call) {
          /// Handle image loaded completely
          setState(() {
            _loadingProgress = 1.0;
          });
          if(widget.onImageErrorHideActionCallBack!=null){
            widget.onImageErrorHideActionCallBack!(false);
          }
        },

        onChunk: (ImageChunkEvent event) {
          if(widget.onImageErrorHideActionCallBack!=null){
            widget.onImageErrorHideActionCallBack!(false);
          }
          /// Calculate loading progress
          final totalBytes = event.expectedTotalBytes ?? 1;
          final cumulativeBytes = event.cumulativeBytesLoaded;
          setState(() {
            _loadingProgress = cumulativeBytes / totalBytes;
          });
        },
        onError: (e,s){
          /// handle error
          /// on this phase we want to toggle the visibility of the imageIcons
          debugPrint('Safe error Print :: error image ERR:: $e');
          setState(() {
            haseError=true;
          });
          if(widget.onImageErrorHideActionCallBack!=null){
            widget.onImageErrorHideActionCallBack!(true);
          }
        },
    );
      stream = Image.network(widget.imageUrl).image.resolve(const ImageConfiguration())..addListener(listener);


  }



  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(widget.innerPadding ?? 0),
      height: widget.height,
      width: widget.width,
      decoration: BoxDecoration(
        color: widget.loaderEmptyColor ?? Colors.white,
        image: const DecorationImage(
          image: AssetImage('assets/images/image_placeholder.jpeg'),
          fit: BoxFit.cover,
        ),
        borderRadius: BorderRadius.circular(widget.imageBoxRadius ?? 0.0),
      ),
      child: _loadingProgress < 1.0&&!haseError
          ? Center(
        child: SizedBox(
          height: widget.height * 0.5,
          width: widget.height * 0.5,
          child: LiquidCircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation(
                widget.loaderFillColor ?? Colors.blueGrey),
            borderColor: widget.loaderBorderColor ?? Colors.blueGrey,
            backgroundColor: widget.loaderEmptyColor ?? Colors.white,
            borderWidth: 2,
            direction: Axis.vertical,
            value: _loadingProgress,
            center: Text(
              '${(_loadingProgress * 100).toStringAsFixed(0)}%',
              style: TextStyle(color: widget.textColor ?? Colors.black),
            ),
          ),
        ),
      )
          : Image.network(
        widget.imageUrl,
        fit: widget.fit ?? BoxFit.cover,
        errorBuilder: (context, e,s){
           return Image.asset(
            widget.employ404image?'assets/images/image_not_found_placeholder.png':'assets/images/image_placeholder.jpeg',
            fit: widget.fit,
          );
        },
      ),
    );
  }

  @override
  void dispose() {
    stream.removeListener(listener);
    super.dispose();
  }
}