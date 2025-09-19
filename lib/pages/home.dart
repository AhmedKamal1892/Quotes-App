import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lottie/lottie.dart';
import 'package:quotes_app/db/hive_model.dart';
import 'package:quotes_app/models/favourite_cubit.dart';
import 'package:quotes_app/models/favourite_state.dart';
import 'package:quotes_app/models/quote.dart';
import 'package:quotes_app/services/dio_service.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  Quote? quote;
  @override
  void initState() {
    super.initState();
    _loadQuote();
  }

  Future<void> _loadQuote() async {
    quote = await DioService.fetchQuote();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Lottie.asset('assets/animations/quote.json', height: 60),
      ),
      body: (quote == null)
          ? Center(
              child: Text('No Quote shown'),
            )
          : SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(10),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "\"${quote?.quote}\"",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontStyle: FontStyle.italic,
                          fontWeight: FontWeight.bold,
                          fontSize: 20),
                    ),
                    const SizedBox(
                      height: 8,
                    ),
                    Text(
                      '- ${quote?.author}',
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                          color: Colors.grey),
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    BlocBuilder<FavouriteCubit, FavouriteState>(
                        builder: (context, state) {
                      return IconButton(
                          onPressed: () async {
                            if (state.favourites.contains(quote)) {
                              await HiveModel.deleteFavourite(quote?.id);
                              return;
                            }
                            await HiveModel.insertFavourite(quote!);
                            if (context.mounted) {
                              context
                                  .read<FavouriteCubit>()
                                  .addFavourite(quote!);
                            }
                          },
                          icon: (state.favourites.contains(quote))
                              ? Icon(
                                  Icons.favorite_rounded,
                                  size: 25,
                                  color: Colors.red,
                                )
                              : Icon(
                                  Icons.favorite_outline_rounded,
                                  size: 25,
                                  color: Colors.grey,
                                ));
                    })
                  ],
                ),
              ),
            ),
      bottomNavigationBar: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          IconButton(
              onPressed: () {
                Navigator.pushNamed(context, 'categoriesScreen');
              },
              icon: Icon(
                Icons.explore,
                size: 30,
              )),
          const SizedBox(width: 30),
          IconButton(
              onPressed: () {
                Navigator.pushNamed(context, 'favouriteScreen');
              },
              icon: Icon(
                Icons.favorite_rounded,
                size: 30,
                color: Colors.red,
              )),
          const SizedBox(width: 30),
          IconButton(
              onPressed: () {
                Navigator.pushNamed(context, 'modeScreen');
              },
              icon: Icon(
                Icons.brightness_6,
                size: 30,
              ))
        ],
      ),
    );
  }
}
