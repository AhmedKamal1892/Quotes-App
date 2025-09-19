import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quotes_app/db/hive_model.dart';
import 'package:quotes_app/models/favourite_state.dart';
import 'package:quotes_app/models/quote.dart';

class FavouriteCubit extends Cubit<FavouriteState> {
  FavouriteCubit() : super(FavouriteState([]));

  void loadFavourites() async {
    final stateFavourites = await HiveModel.fetchFavourites();
    emit(FavouriteState(stateFavourites));
  }

  void addFavourite(Quote quote) {
    emit(FavouriteState([...state.favourites, quote]));
  }

  void removeFavourite(Quote quote) {
    emit(FavouriteState(state.favourites..remove(quote)));
  }

  void clearFavourites() {
    emit(FavouriteState([]));
  }
}
