import 'package:dio/dio.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ApiFailure implements Exception {
  const ApiFailure(this.message, {this.statusCode});
  final String message;
  final int? statusCode;
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

  Future<dynamic> request(
    String path, {
    String method = 'GET',
    Map<String, dynamic>? query,
    Object? data,
    bool ai = false,
  }) async {
    final target = Uri.tryParse(path);
    if (target == null ||
        !path.startsWith('/') ||
        path.startsWith('//') ||
        path.contains('\\') ||
        target.hasScheme ||
        target.hasAuthority) {
      throw const ApiFailure('Choose a path within the configured API.');
    }
    try {
      final response = await _dio.request<dynamic>(
        path,
        queryParameters: query,
        data: data,
        options: Options(
          method: method,
          receiveTimeout: ai
              ? const Duration(seconds: 45)
              : const Duration(seconds: 10),
        ),
      );
      return response.data;
    } on DioException catch (error) {
      final status = error.response?.statusCode;
      final body = error.response?.data;
      final detail = body is Map ? body['detail'] : null;
      if (detail is String) throw ApiFailure(detail, statusCode: status);
      if (status == 422) {
        throw const ApiFailure(
          'Check your form values and try again.',
          statusCode: 422,
        );
      }
      if (status == 401) {
        throw const ApiFailure(
          'Your session has expired. Sign in again.',
          statusCode: 401,
        );
      }
      if (error.error is ApiFailure) throw error.error!;
      throw ApiFailure(
        status == null
            ? 'Could not connect. Check your connection and retry.'
            : 'The request could not be completed. Please retry.',
        statusCode: status,
      );
    }
  }

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
