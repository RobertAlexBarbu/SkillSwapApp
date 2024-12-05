import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';

class JwtInterceptor extends Interceptor {
  @override
  Future<void> onRequest(
      RequestOptions options, RequestInterceptorHandler handler) async {
    String? idToken = await FirebaseAuth.instance.currentUser?.getIdToken();

    if (idToken != null) {
      options.headers['Authorization'] = 'Bearer $idToken';
    }

    super.onRequest(options, handler);
  }
}

Dio createDio() {
  final dio = Dio();
  dio.interceptors.add(JwtInterceptor());
  return dio;
}