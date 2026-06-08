import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../cubit/country_cubit.dart';
import '../cubit/country_state.dart';
import '../widgets/country_card.dart';
import '../l10n/app_localizations.dart';

class FavoritesScreen extends StatelessWidget {
  const FavoritesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.favorites),
      ),
      body: BlocBuilder<CountryCubit, CountryState>(
        builder: (context, state) {
          if (state is CountryLoaded) {
            final favorites = state.allCountries
                .where((c) => state.favoriteCca3s.contains(c.cca3))
                .toList();

            if (favorites.isEmpty) {
              return Center(child: Text(l10n.noFavorites));
            }

            return ListView.builder(
              itemCount: favorites.length,
              itemBuilder: (context, index) {
                return CountryCard(
                  country: favorites[index],
                  isFavorite: true,
                );
              },
            );
          }
          return const Center(child: CircularProgressIndicator());
        },
      ),
    );
  }
}
