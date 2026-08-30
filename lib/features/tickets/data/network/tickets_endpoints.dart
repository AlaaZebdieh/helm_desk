class TicketsEndpoints {
  static const String tickets = '/tickets';
  static String ticket(String id) => '/tickets/$id';
  static String claim(String id) => '/tickets/$id/claim';
  static String replies(String id) => '/tickets/$id/replies';
  static const String attachments = '/attachments';
  static String attachment(String id) => '/attachments/$id';
  static const String events = '/events';
}
