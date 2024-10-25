import 'dart:io';

import 'package:dio/dio.dart';


abstract class FileDownloaderHandler{

  static Future<File?>downloadFile({
    required Directory directory,
    required String fileUrl,
    required Dio dioInstance,
    required Function(int,int) progressCallback
})async{

    String fileName = fileUrl.split('/').last;
    final res = await dioInstance.download(fileUrl, '${directory.path}/$fileName',
    onReceiveProgress: progressCallback,
    deleteOnError: true,
    options: Options(
    headers: {
    Headers.contentTypeHeader: 'multipart/form-data',
    },
    responseType: ResponseType.bytes,
    followRedirects: false,
        validateStatus: (status) {
      return ((status ?? 500) < 500);
    },),
    );
    
  return File('${directory.path}/$fileName');
  }

}