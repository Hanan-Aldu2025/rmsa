// ignore_for_file: unreachable_switch_default

import 'package:dio/dio.dart';

/// 📝 كلاس أساسي للأخطاء
abstract class Failure {
  final String errorMessage;
  const Failure(this.errorMessage);
}

/// 📝 أخطاء قادمة من السيرفر / API
class FailureServer extends Failure {
  const FailureServer(super.errorMessage);

  /// ✅ تحويل خطأ [DioException] إلى Failure مناسب
  factory FailureServer.fromDioError(DioException dioError) {
    switch (dioError.type) {
      case DioExceptionType.connectionTimeout:
        return const FailureServer("Connection Timeout Error");

      case DioExceptionType.sendTimeout:
        return const FailureServer("Send Timeout Error");

      case DioExceptionType.receiveTimeout:
        return const FailureServer("Receive Timeout Error");

      case DioExceptionType.badCertificate:
        return const FailureServer("Bad Certificate Error");

      case DioExceptionType.badResponse:
        return FailureServer.fromResponse(
          dioError.response?.statusCode ?? 0,
          dioError.response?.data,
        );

      case DioExceptionType.cancel:
        return const FailureServer("Request was Cancelled");

      case DioExceptionType.connectionError:
        return const FailureServer("Connection Error");

      case DioExceptionType.unknown:
        if (dioError.message != null &&
            dioError.message!.contains('SocketException')) {
          return const FailureServer("No Internet Connection");
        }
        return const FailureServer("Unexpected Error, Please Try Again");

      default:
        return const FailureServer("Oops! There was an error, Please try later");
    }
  }

  /// ✅ معالجة الخطأ بناءً على كود الاستجابة
  factory FailureServer.fromResponse(int statusCode, dynamic response) {
    if (statusCode == 400|| statusCode == 403) {
      return FailureServer(response['error']['message'] ?? "Unauthorized Error");
    } else if (statusCode == 404) {
      return const FailureServer("Your request was not found, Please Try later");
    } else if (statusCode == 500 || statusCode == 405) {
      return const FailureServer("Internal Server Error, Please Try later");
    } else {
      return const FailureServer("Oops! There was an error, Please try later");
    }
  }
}