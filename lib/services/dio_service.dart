import 'package:dio/dio.dart';
import 'package:quotes_app/models/quote.dart';

class DioService {
  static final String baseUrl = 'https://dummyjson.com/quotes';
  static final _dio = Dio();

  static Future<Quote> fetchQuote() async {
    final url = '$baseUrl/random';
    final response = await _dio.get(url,
        options: Options(headers: {'Accept': 'application/json'}));
    if (response.statusCode == 200 ||
        response.statusCode == 201 ||
        response.statusCode == 202) {
      final dataFromServer = response.data;
      final quoteObject = Quote.fromMap(dataFromServer);
      return quoteObject;
    } else {
      throw Exception('Failed to load quote');
    }
  }

  static Future<List<Quote>> fetchQuotes() async {
    final url = baseUrl;
    final response = await _dio.get(url,
        options: Options(headers: {'Accept': 'application/json'}));
    if (response.statusCode == 200 ||
        response.statusCode == 201 ||
        response.statusCode == 202) {
      final dataFromServer = response.data;
      final quotesMap = dataFromServer['quotes'] as List;
      final quoteObjects = quotesMap.map((e) => Quote.fromMap(e)).toList();
      return quoteObjects;
    } else {
      throw Exception('Failed to load quotes');
    }
  }
}
