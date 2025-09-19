import 'dart:convert';

import 'package:hive_flutter/hive_flutter.dart';
import 'package:quotes_app/models/quote.dart';

class HiveModel {
  static final String boxName = 'Favourites';
  static final String key = 'favourites';
  static late Box _box;
  static Future<void> initDatabase() async {
    await Hive.initFlutter();
    _box = await Hive.openBox(boxName);
  }

  static Future<List<Quote>> fetchFavourites() async {
    final quoteJson = await _box.get(key);
    if (quoteJson == null) return [];
    final quoteMaps = jsonDecode(quoteJson) as List;
    final quoteObjects = quoteMaps.map((e) => Quote.fromMap(e)).toList();
    return quoteObjects;
  }

  static Future<void> insertFavourite(Quote quote) async {
    final quotes = await HiveModel.fetchFavourites();
    quote.id = DateTime.now().microsecondsSinceEpoch;
    quotes.add(quote);
    final quoteMaps = quotes.map((e) => e.toMap()).toList();
    final quoteJson = jsonEncode(quoteMaps);
    await _box.put(key, quoteJson);
  }

  static Future<void> deleteFavourite(int? id) async {
    final quotes = await HiveModel.fetchFavourites();
    quotes.removeWhere((e) => e.id == id);
    final quoteMaps = quotes.map((e) => e.toMap()).toList();
    final quoteJson = jsonEncode(quoteMaps);
    await _box.put(key, quoteJson);
  }
}
