class QuotesModel {
  late String quote;

  QuotesModel.fromJson(Map<String, dynamic> json) {
    quote = json['quote'];
  }
}