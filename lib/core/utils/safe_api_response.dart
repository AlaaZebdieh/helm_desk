import '../network/api_response.dart';
import 'safe_from_json.dart';

/// هذا يحوّل أي response.data لموديل بشكل آمن
Future<T> safeApiResponse<T>(
  Future<ApiResponse> apiCall,
  T Function(dynamic) fromJson,
) async {
  final response = await apiCall;
  return safeFromJson<T>(response.data, fromJson);
}
