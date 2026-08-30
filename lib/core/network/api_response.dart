class ApiResponse<T> {
  final T? data;
  final int statusCode;
  final String message;
  final bool success;

  ApiResponse({
    this.data,
    required this.statusCode,
    required this.message,
    required this.success,
  });

  factory ApiResponse.success(T data, int statusCode) {
    return ApiResponse(
      data: data,
      statusCode: statusCode,
      message: "Success",
      success: true,
    );
  }
}
