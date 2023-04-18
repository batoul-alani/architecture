// // Dio Handling
//
// import 'dart:developer';
// import "package:fluttertoast/fluttertoast.dart";
// import 'package:dio/dio.dart';
// import 'package:flutter/foundation.dart';
// import 'package:what_do_i_cook/utils/app_constants.dart';
//
// // فائدة الكلاس هاد انه مايخليني معتمدة بشكل مباشر على مكتبة ال dio
// abstract class NetworkService<T> {
//   Future<T> get (String url);
//
//   Future<T> getWithToken (String url, String token);
//
//   Future<T> post (String url, Map<String, dynamic> body);
//
//   Future<T> postWithToken (String url, String token, Map<String, dynamic> body);
// }
//
// class DioNetworkService implements NetworkService<Response>{
//   Dio get _dio{
//     var dio = Dio(
//       BaseOptions(
//         baseUrl: AppConstants.baseUrl,
//         receiveTimeout: const Duration(seconds: AppConstants.dioTimeout),
//         connectTimeout: const Duration(seconds: AppConstants.dioTimeout),
//         sendTimeout: const Duration(seconds: AppConstants.dioTimeout),
//         headers: {'Accept': 'application/json'}
//       ));
//
//     dio.interceptors.addAll({DioAppInterceptors()});
//     if(kDebugMode){
//       dio.interceptors.add(LogInterceptor(requestBody: true, responseBody: true,));
//     }
//     return dio;
//   }
//
//   @override
//   Future<Response> get(String endpoint) => _dio.get(endpoint);
//
//   @override
//   Future<Response> getWithToken(String endpoint, String token) => _dio.get(endpoint, options: Options(headers: {
//   "Authorization": "Bearer $token"}));
//
//   @override
//   Future<Response> post(String url, Map<String, dynamic> body) => _dio.post(url, data: body);
//
//   @override
//   Future<Response> postWithToken(String url, String token, Map<String, dynamic> body) => _dio.post(url, data: body, options: Options(headers: {
//      "Authorization": "Bearer $token",
//     }));
// }
//
// class DioAppInterceptors extends Interceptor{
//
//   @override
//   void onError(DioError err, ErrorInterceptorHandler handler){
//     if(err.response?.statusCode == 500){
//       log(err.response.toString());
//     }
//     switch(err.type){
//       case DioErrorType.connectionTimeout:
//       case DioErrorType.sendTimeout:
//       case DioErrorType.receiveTimeout:
//       case DioErrorType.connectionError:
//       case DioErrorType.badCertificate:
//         Fluttertoast.showToast(msg: "الرجاء التحقق من الاتصال بالانترنيت");
//         throw DeadlineExceededException(err.requestOptions);
//       case DioErrorType.badResponse:
//         switch(err.response?.statusCode){
//           case 400:
//             throw BadRequestException(err.requestOptions);
//           case 401:
//             Fluttertoast.showToast(msg: err.response!.data["message"]);
//             throw UnauthorizedException(err.requestOptions);
//           case 403:
//             throw AccessForbiddenException(err.requestOptions);
//           case 404:
//             Fluttertoast.showToast(msg: "لا يوجد");
//             throw NotFoundException(err.requestOptions);
//           case 409:
//             throw ConflictException(err.requestOptions);
//           case 422:
//             Fluttertoast.showToast(msg: err.response!.data["message"]);
//             throw UndefineException(err.requestOptions);
//           case 500:
//             throw InternetServerErrorException(err.requestOptions);
//         }
//         break;
//       case DioErrorType.cancel:
//         break;
//       case DioErrorType.unknown:
//         Fluttertoast.showToast(msg: "الرجاء التحقق من الاتصال بالانترنيت");
//         throw NoInternetConnectionException(err.requestOptions);
//     }
//   }
// }
//
//
// class BadRequestException extends DioError{
//   BadRequestException(RequestOptions r): super(requestOptions: r);
//
//   @override
//   String toString(){
//     return "Bad Request";
//   }
// }
// class InternetServerErrorException extends DioError{
//   InternetServerErrorException(RequestOptions r): super(requestOptions: r);
//
//   @override
//   String toString(){
//     return "Some Thing Went Wrong, Try Again";
//   }
// }
// class ConflictException extends DioError{
//   ConflictException(RequestOptions r): super(requestOptions: r);
//
//   @override
//   String toString(){
//     return "Conflict Connection";
//   }
// }
// class UnauthorizedException extends DioError{
//   UnauthorizedException(RequestOptions r): super(requestOptions: r);
//
//   @override
//   String toString(){
//     Fluttertoast.showToast(msg: " ");
//     return "Unauthorized";
//   }
// }
// class NotFoundException extends DioError{
//   NotFoundException(RequestOptions r): super(requestOptions: r);
//
//   @override
//   String toString(){
//     return "Not Found";
//   }
// }
// class NoInternetConnectionException extends DioError{
//   NoInternetConnectionException(RequestOptions r): super(requestOptions: r);
//
//   @override
//   String toString(){
//     return "No Internet Connection";
//   }
// }
// class DeadlineExceededException extends DioError{
//   DeadlineExceededException(RequestOptions r): super(requestOptions: r);
//
//   @override
//   String toString(){
//     return "Deadline Exceeded";
//   }
// }
// class AccessForbiddenException extends DioError{
//   AccessForbiddenException(RequestOptions r): super(requestOptions: r);
//
//   @override
//   String toString(){
//     return "Access Forbidden";
//   }
// }
// class UndefineException extends DioError{
//   UndefineException(RequestOptions r): super(requestOptions: r);
//
//   @override
//   String toString(){
//     return "Error in Syntex";
//   }
// }