import 'package:get/get.dart';

abstract class APIErrors implements Exception {
  final code;
  final message;
  final details;

  APIErrors({this.code, this.message, this.details}) {}

  @override
  String toString() {
    // TODO: implement toString
    return "[$code]: $message \n $details";
  }
}

class FetchDataError extends APIErrors {
  FetchDataError(String? details, {dynamic code})
      : super(
            code: code ?? "Network_FetchDataError",
            message: "Network_FetchDataError",
            details: details ?? "Network_FetchDataError");
}

class TimeOutError extends APIErrors {
  TimeOutError(String? details, {dynamic code})
      : super(
            code: code ?? "Network_TimeOutError",
            message: "Network_TimeOutError",
            details: details ?? "Network_TimeOutError");
}
