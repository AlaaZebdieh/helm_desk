/// Parses Helm Desk API error shape: `{ "error": { "code", "message" } }`.
String? parseApiErrorCode(dynamic data) {
  if (data is! Map) return null;
  final error = data['error'];
  if (error is Map && error['code'] != null) {
    return error['code'].toString();
  }
  return null;
}

String? parseApiErrorMessage(dynamic data) {
  if (data is! Map) return null;
  final error = data['error'];
  if (error is Map && error['message'] != null) {
    return error['message'].toString();
  }
  if (data['message'] != null) {
    return data['message'].toString();
  }
  return null;
}
