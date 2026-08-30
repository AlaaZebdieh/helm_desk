class ApiResponse<T> {
  final T? data;
  final int statusCode;
  final String message;
  final bool success;
  final Map<String, List<String>> headers;

  ApiResponse({
    this.data,
    required this.statusCode,
    required this.message,
    required this.success,
    this.headers = const {},
  });

  factory ApiResponse.success(
    T data,
    int statusCode, {
    Map<String, List<String>> headers = const {},
  }) {
    return ApiResponse(
      data: data,
      statusCode: statusCode,
      message: "Success",
      success: true,
      headers: headers,
    );
  }

  String? header(String name) {
    final value = headers[name.toLowerCase()];
    return value != null && value.isNotEmpty ? value.first : null;
  }
}
