import 'api_response.dart';

abstract class ApiClient {
  Future<ApiResponse> get(String path, {Map<String, dynamic>? queryParameters});
  Future<ApiResponse> post(
    String path, {
    Map<String, dynamic>? body,
    bool formDataIsEnabled = false,
    Map<String, dynamic>? queryParameters,
  });
  Future<ApiResponse> put(
    String path, {
    Map<String, dynamic>? body,
    Map<String, dynamic>? queryParameters,
  });
  Future<ApiResponse> delete(
    String path, {
    Map<String, dynamic>? body,
    Map<String, dynamic>? queryParameters,
  });
  Future<ApiResponse> download(
    String url,
    String savePath, {
    Function(int received, int total)? onProgress,
  });
}
