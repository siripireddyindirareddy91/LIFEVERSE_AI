import 'package:dio/dio.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ApiFailure implements Exception {
  const ApiFailure(this.message);
  final String message;
  @override
  String toString() => message;
}

class ApiClient {
  ApiClient(String baseUrl, SupabaseClient? auth)
    : _dio = Dio(
        BaseOptions(
          baseUrl: baseUrl,
          connectTimeout: const Duration(seconds: 8),
          receiveTimeout: const Duration(seconds: 10),
          sendTimeout: const Duration(seconds: 10),
          followRedirects: false,
        ),
      ) {
    _dio.interceptors.add(
      QueuedInterceptorsWrapper(
        onRequest: (options, handler) async {
          try {
            var session = auth?.auth.currentSession;
            if (session?.isExpired ?? false) {
              session = (await auth!.auth.refreshSession()).session;
            }
            if (session != null) {
              options.headers['Authorization'] =
                  'Bearer ${session.accessToken}';
            }
            handler.next(options);
          } catch (_) {
            handler.reject(
              DioException(
                requestOptions: options,
                error: const ApiFailure('Session expired. Sign in again.'),
              ),
            );
          }
        },
      ),
    );
  }

  final Dio _dio;

  Future<bool> checkReadiness() async {
    try {
      final response = await _dio.get<Map<String, dynamic>>('/health/ready');
      return response.data?['status'] == 'ready';
    } on DioException catch (error) {
      if (error.response?.statusCode == 503) {
        throw const ApiFailure(
          'Backend needs Supabase configuration or database setup.',
        );
      }
      throw const ApiFailure(
        'Cannot reach the backend. Check the API address and connection.',
      );
    }
  }

  void dispose() => _dio.close();
}
