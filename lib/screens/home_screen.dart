import 'package:country_app/cubit/language_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../cubit/country_cubit.dart';
import '../cubit/country_state.dart';
import '../widgets/country_card.dart';
import '../widgets/home_search_bar.dart';
import '../widgets/filter_sort_sheet.dart';
import '../l10n/app_localizations.dart';
import 'detail_screen.dart';
import 'favorites_screen.dart';
import 'compare_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController _searchController = TextEditingController();

  final List<String> regions = ['All', 'Africa', 'Americas', 'Antarctica', 'Asia', 'Europe', 'Oceania'];
  final List<String> sortTypes = ['alphabetical', 'population', 'area'];

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _onSearchChanged(String query) {
    final state = context.read<CountryCubit>().state;
    if (state is CountryLoaded) {
      context.read<CountryCubit>().searchAndFilter(
            query,
            state.selectedRegion,
            state.sortType,
          );
    }
  }

  void _showFilterSortSheet(BuildContext context, CountryLoaded state) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) {
        return FilterSortSheet(
          initialRegion: state.selectedRegion,
          initialSortType: state.sortType,
          regions: regions,
          sortTypes: sortTypes,
          onApply: (region, sortType) {
            context.read<CountryCubit>().searchAndFilter(
                  _searchController.text,
                  region,
                  sortType,
                );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return Scaffold(
      appBar: AppBar(
  title: Text(l10n.appTitle),
  actions: [
    BlocBuilder<LanguageCubit, Locale>(
      builder: (context, locale) {
        // Cari dilin Azərbaycan dili olub-olmadığını yoxlayırıq
        final isAz = locale.languageCode == 'az';
        
        return TextButton(
          onPressed: () {
            context.read<LanguageCubit>().changeLanguage(isAz ? 'en' : 'az');
          },
          child: Text(
            isAz ? 'AZ' : 'EN',
            style: const TextStyle(
              color: Colors.white, 
              fontWeight: FontWeight.bold,
            ),
          ),
        );
      },
    ),
    IconButton(
      icon: const Icon(Icons.shuffle),
      tooltip: l10n.randomCountry,
      onPressed: () {
        final randomCountry = context.read<CountryCubit>().getRandomCountry();
        if (randomCountry != null) {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => DetailScreen(country: randomCountry)),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(l10n.noCountryAvailable)),
          );
        }
      },
    ),
    IconButton(
      icon: const Icon(Icons.favorite),
      tooltip: l10n.favorites,
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const FavoritesScreen()),
        );
      },
    ),
    IconButton(
      icon: const Icon(Icons.compare_arrows),
      tooltip: l10n.compare,
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const CompareScreen()),
        );
      },
    ),
  ],
),
      body: BlocListener<CountryCubit, CountryState>(
        listener: (context, state) {
          if (state is CountryLoaded) {
            if (state.searchQuery != _searchController.text) {
              _searchController.text = state.searchQuery;
              _searchController.selection = TextSelection.fromPosition(
                TextPosition(offset: state.searchQuery.length),
              );
            }
          }
        },
        child: BlocBuilder<CountryCubit, CountryState>(
          builder: (context, state) {
            if (state is CountryInitial || state is CountryLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is CountryError) {
              final msg = state.message == 'error_network'
                  ? l10n.errorNetwork
                  : state.message == 'error_server'
                      ? l10n.errorServer
                      : l10n.errorUnexpected;
              return Center(child: Text(msg));
            } else if (state is CountryLoaded) {
              return Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Row(
                      children: [
                        Expanded(
                          child: HomeSearchBar(
                            controller: _searchController,
                            onChanged: _onSearchChanged,
                            onClear: () {
                              _searchController.clear();
                              _onSearchChanged('');
                            },
                          ),
                        ),
                        const SizedBox(width: 8),
                        IconButton(
                          icon: const Icon(Icons.filter_list),
                          onPressed: () => _showFilterSortSheet(context, state),
                        )
                      ],
                    ),
                  ),
                  Expanded(
                    child: state.displayedCountries.isEmpty
                        ? Center(child: Text(l10n.noCountriesFound))
                        : ListView.builder(
                            itemCount: state.displayedCountries.length,
                            itemBuilder: (context, index) {
                              final country = state.displayedCountries[index];
                              final isFavorite = state.favoriteCca3s.contains(country.cca3);
                              return CountryCard(
                                country: country,
                                isFavorite: isFavorite,
                              );
                            },
                          ),
                  ),
                ],
              );
            }
            return const SizedBox();
          },
        ),
      ),
    );
  }
}