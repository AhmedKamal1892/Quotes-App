import 'package:flutter/material.dart';
import 'package:quotes_app/models/quote.dart';
import 'package:quotes_app/pages/category_screen.dart';
import 'package:quotes_app/services/dio_service.dart';

class CategoriesScreen extends StatefulWidget {
  const CategoriesScreen({super.key});

  @override
  State<CategoriesScreen> createState() => _CategoriesScreenState();
}

class _CategoriesScreenState extends State<CategoriesScreen> {
  List<Quote> categoryList = [];
  @override
  void initState() {
    super.initState();
    _loadQuotes();
  }

  Future<void> _loadQuotes() async {
    categoryList = await DioService.fetchQuotes();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Padding(
      padding: const EdgeInsets.all(8.0),
      child: GridView.builder(
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2, crossAxisSpacing: 2.0, mainAxisSpacing: 2.0),
          itemCount: categoryList.length,
          itemBuilder: (context, index) {
            return GestureDetector(
              onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => CategoryScreen(
                            category: categoryList[index],
                          ))),
              child: Card(
                  elevation: 4,
                  child: Center(
                      child: Text(
                    'Quote ${categoryList[index].id}',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ))),
            );
          }),
    ));
  }
}
