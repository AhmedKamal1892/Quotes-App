import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quotes_app/db/hive_model.dart';
import 'package:quotes_app/models/favourite_cubit.dart';
import 'package:quotes_app/models/favourite_state.dart';
import 'package:quotes_app/models/quote.dart';

class CategoryScreen extends StatefulWidget {
  final Quote category;
  const CategoryScreen({super.key, required this.category});

  @override
  State<CategoryScreen> createState() => _CategoryScreenState();
}

class _CategoryScreenState extends State<CategoryScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Quote ${widget.category.id}',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 30),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              '"${widget.category.quote}"',
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontStyle: FontStyle.italic,
                  fontSize: 20),
            ),
            const SizedBox(
              height: 10,
            ),
            Text(
              '"${widget.category.author}"',
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                  color: Colors.grey),
            ),
            const SizedBox(
              height: 15,
            ),
            BlocBuilder<FavouriteCubit, FavouriteState>(
                builder: (context, state) => IconButton(
                    onPressed: () async {
                      if (state.favourites.contains(widget.category)) {
                        await HiveModel.deleteFavourite(widget.category.id);
                        return;
                      }
                      await HiveModel.insertFavourite(widget.category);
                      if (context.mounted) {
                        context
                            .read<FavouriteCubit>()
                            .addFavourite(widget.category);
                      }
                    },
                    icon: (state.favourites.contains(widget.category))
                        ? Icon(
                            Icons.favorite_rounded,
                            color: Colors.red,
                            size: 20,
                          )
                        : Icon(
                            Icons.favorite_border_rounded,
                            size: 20,
                            color: Colors.grey,
                          )))
          ],
        ),
      ),
    );
  }
}
