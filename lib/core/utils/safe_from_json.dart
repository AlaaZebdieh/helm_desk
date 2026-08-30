import '../errors/exceptions/data_parsing_exception.dart';

T safeFromJson<T>(dynamic data, T Function(dynamic) fromJson) {
  try {
    return fromJson(data);
  } on FormatException catch (e) {
    throw DataParsingException(
      msg: 'FormatException: ${e.message}',
      data: data,
    );
  } on TypeError catch (e) {
    throw DataParsingException(msg: 'TypeError: ${e.toString()}', data: data);
  } catch (e) {
    throw DataParsingException(
      msg: 'Unknown error: ${e.toString()}',
      data: data,
    );
  }
}
