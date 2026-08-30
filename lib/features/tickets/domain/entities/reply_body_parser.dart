import 'reply_attachment.dart';

class ReplyBodyParser {
  static final RegExp _attachmentPattern = RegExp(
    r'\[مرفق:\s*(.+?)\s*\((at_[^)]+)\)\]',
  );

  const ReplyBodyParser._();

  static ({String text, ReplyAttachment? attachment}) parse(String body) {
    final match = _attachmentPattern.firstMatch(body);
    if (match == null) {
      return (text: body, attachment: null);
    }

    final attachment = ReplyAttachment(
      id: match.group(2)!,
      filename: match.group(1)!.trim(),
    );
    final text = body.replaceFirst(_attachmentPattern, '').trim();

    return (text: text, attachment: attachment);
  }
}
