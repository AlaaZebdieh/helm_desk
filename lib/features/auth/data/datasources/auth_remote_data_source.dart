import '../../../../core/network/api_client.dart';
import '../../../../core/utils/safe_api_response.dart';
import '../models/login_response_model.dart';
import '../network/auth_endpoints.dart';

abstract class AuthRemoteDataSource {
  Future<LoginResponseModel> login({
    required String username,
    required String password,
  });
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final ApiClient apiClient;

  AuthRemoteDataSourceImpl({required this.apiClient});

  @override
  Future<LoginResponseModel> login({
    required String username,
    required String password,
  }) async {
    return safeApiResponse<LoginResponseModel>(
      apiClient.post(
        AuthEndpoints.login,
        body: {'username': username, 'password': password},
      ),
      (json) => LoginResponseModel.fromJson(json as Map<String, dynamic>),
    );
  }
}
