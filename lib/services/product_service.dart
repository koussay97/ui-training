import 'dart:async';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import 'package:rxdart/rxdart.dart';
import 'package:test_project/product_presentation/product_model.dart';
import 'package:test_project/services/download_file_service.dart';

abstract interface class IMockProductService {
  Stream<double> get downloadProgress;

  Future<List<Product>> getAllProductsFromApi();

  Future<List<File?>> downloadFiles(
      {required List<String> filesPath,});


  void dispose();
}

class MockProductService implements IMockProductService {
  final Dio dioInstance;

  MockProductService({
    required this.dioInstance,
  });

  final BehaviorSubject<double> _downloadStreamController =
      BehaviorSubject<double>();

  @override
  Future<List<Product>> getAllProductsFromApi() {
    return Future.delayed(
      const Duration(milliseconds: 300),
      () => [],
    );
  }



  @override
  Stream<double> get downloadProgress => _downloadStreamController.stream;

  @override
  Future<List<File?>> downloadFiles({
    required List<String> filesPath,

  }) async {
    final directory = await getDownloadsDirectory();
    if (directory == null) {
      throw PlatformException(
        message: 'Could not retrieve download directory',
        stacktrace: 'MockProductService :: downloadFiles',
        code: '101',
      );
    }


    List<StreamController<(int progress, int total)>> streamControllers = [];
    try {
      final List<Future<File?>> downloadFutures = filesPath.map((fileUrl) {
        final StreamController<(int progress, int total)> streamController =
        StreamController<(int, int)>();
        streamControllers.add(streamController);
        return FileDownloaderHandler.downloadFile(
          directory: directory,
          fileUrl: fileUrl,
          dioInstance: dioInstance,
          progressCallback: (progress, total) {
            streamController.add((progress, total));
          },
        );
      }).toList();

      List<Stream<(int, int)>> progressStreams = streamControllers
          .map((controller) => controller.stream)
          .toList();


      StreamSubscription? subscription = CombineLatestStream(
        progressStreams,
            (List<(int progress, int total)> progresses) {
          progresses.sort((a, b) => b.$2.compareTo(a.$2));
          final largestFileProgress = progresses.first;
          final double progressPercentage =
          largestFileProgress.$2 > 0
              ? largestFileProgress.$1 / largestFileProgress.$2
              : 0.0;


          _downloadStreamController.add(progressPercentage);
        },
      ).listen((data) {
        print(data);
      });


      final List<File?> files = await Future.wait(downloadFutures);


      await subscription?.cancel();
      for (var controller in streamControllers) {
        await controller.close();
      }

      return files;
    } catch (e) {
      throw PlatformException(code: "100", message: '$e');
    }
  }

  @override
  void dispose() {
    _downloadStreamController.close();
  }
}
