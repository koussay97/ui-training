

import 'package:equatable/equatable.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';

abstract interface class INetworkChecker {
  Future<bool> get isConnected;

  Stream<NetworkStatus> get onConnectionChange;
}

class NetworkCheckerIMPL implements INetworkChecker {
  final InternetConnection checker;

  NetworkCheckerIMPL({required this.checker});

  @override
  Future<bool> get isConnected => checker.hasInternetAccess;

  @override
  Stream<NetworkStatus> get onConnectionChange =>
      checker.onStatusChange.map((event) {
        if (event == InternetStatus.connected) {
          return NetworkStatus.hasInternetAccess;
        }
        return NetworkStatus.noInternetAccess;
      });
}

enum NetworkStatus { hasInternetAccess, noInternetAccess }

sealed class ApplicationErrors extends Equatable{
final String errorMessage;
final int? errorCode;
final String? stackTrace;

const ApplicationErrors({required this.errorMessage, this.errorCode, this.stackTrace});

void mather({
    required Function( String message, int? code, String? stackTrace) onApiError,
    required Function(String message,int? code,String?  stackTrace) onNetworkError,
    Function(String message , int?code, String?  stackTrace)? onParsingError,
  }){
  if(this is ApiError){
    onApiError.call(errorMessage,errorCode,stackTrace);
  }else if(this is ParsingError){
    onParsingError?.call(errorMessage,errorCode,stackTrace);
  }else{
    onNetworkError.call(errorMessage,errorCode,stackTrace);

  }
}
}

final class ApiError extends ApplicationErrors{
  const ApiError({required super.errorMessage, super.errorCode, super.stackTrace});

  @override
  List<Object?> get props => [errorMessage];
}
final class NetworkError extends ApplicationErrors{
  const NetworkError({required super.errorMessage, super.errorCode, super.stackTrace});

  @override
  List<Object?> get props => [errorMessage];
}
final class ParsingError extends ApplicationErrors{
 const ParsingError({required super.errorMessage, super.errorCode,super.stackTrace});

  @override
  List<Object?> get props =>[errorMessage];

}