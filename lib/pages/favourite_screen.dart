import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lottie/lottie.dart';
import 'package:quotes_app/db/hive_model.dart';
import 'package:quotes_app/models/favourite_cubit.dart';
import 'package:quotes_app/models/favourite_state.dart';

class FavouriteScreen extends StatefulWidget {
  const FavouriteScreen({super.key});

  @override
  State<FavouriteScreen> createState() => _FavouriteScreenState();
}

class _FavouriteScreenState extends State<FavouriteScreen> {
  @override
  void initState() {
    super.initState();
    context.read<FavouriteCubit>().loadFavourites();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Lottie.asset('assets/animations/love.json', height: 30),
      ),
      body: BlocBuilder<FavouriteCubit, FavouriteState>(
        builder: (context, state) => (state.favourites.isEmpty)
            ? Center(child: Text('No favourites to show'))
            : ListView.builder(
                itemCount: state.favourites.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.all(10),
                    child: Card(
                      elevation: 4,
                      child: ListTile(
                        title: Text(
                          "\"${state.favourites[index].quote}\"",
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 12),
                        ),
                        subtitle: Text(
                          "- ${state.favourites[index].author}",
                          style: TextStyle(fontSize: 10),
                        ),
                        trailing: IconButton(
                            onPressed: () async {
                              await HiveModel.deleteFavourite(
                                  state.favourites[index].id);
                              if (context.mounted) {
                                context
                                    .read<FavouriteCubit>()
                                    .removeFavourite(state.favourites[index]);
                              }
                            },
                            icon: Icon(
                              Icons.favorite_rounded,
                              color: Colors.red,
                              size: 20,
                            )),
                      ),
                    ),
                  );
                }),
      ),
    );
  }
}
