import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../cubit/country_cubit.dart';
import '../cubit/country_state.dart';
import '../widgets/country_card.dart';
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

  // API (restcountries) datasına uyğun düzəldilmiş region siyahısı
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
      // Axtarış zamanı mövcud region və sıralama növünü qoruyuruq
      context.read<CountryCubit>().searchAndFilter(
            query,
            state.selectedRegion,
            state.sortType,
          );
    }
  }

  void _showFilterSortSheet(BuildContext context, CountryLoaded state) {
    String tempRegion = state.selectedRegion;
    String tempSort = state.sortType;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true, // Ekranı tam örtməməsi və rahat yerləşməsi üçün
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setModalState) {
            return Padding(
              padding: EdgeInsets.only(
                top: 16.0,
                left: 16.0,
                right: 16.0,
                bottom: MediaQuery.of(context).viewInsets.bottom + 16.0, // Klaviatura açılarsa sıxılmaması üçün
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Filter by Region', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 8,
                    runSpacing: 4,
                    children: regions.map((r) {
                      return ChoiceChip(
                        label: Text(r),
                        selected: tempRegion.toLowerCase() == r.toLowerCase(),
                        onSelected: (selected) {
                          if (selected) {
                            setModalState(() => tempRegion = r);
                          }
                        },
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 16),
                  const Text('Sort by', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 8,
                    children: sortTypes.map((s) {
                      return ChoiceChip(
                        label: Text(s.toUpperCase()),
                        selected: tempSort == s,
                        onSelected: (selected) {
                          if (selected) {
                            setModalState(() => tempSort = s);
                          }
                        },
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 24),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                      onPressed: () {
                        context.read<CountryCubit>().searchAndFilter(
                              _searchController.text,
                              tempRegion,
                              tempSort,
                            );
                        Navigator.pop(context);
                      },
                      child: const Text('Apply', style: TextStyle(fontSize: 16)),
                    ),
                  )
                ],
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Country Explorer'),
        actions: [
          IconButton(
            icon: const Icon(Icons.shuffle),
            tooltip: 'Random Country',
            onPressed: () {
              final randomCountry = context.read<CountryCubit>().getRandomCountry();
              if (randomCountry != null) {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => DetailScreen(country: randomCountry)),
                );
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('No country available')),
                );
              }
            },
          ),
          IconButton(
            icon: const Icon(Icons.favorite),
            tooltip: 'Favorites',
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const FavoritesScreen()),
              ).then((_) {
                // Favorilərdən qayıdanda ana səhifəni yeniləmək lazımdırsa Cubit-i yenidən tetikləyə bilərsiniz
              });
            },
          ),
          IconButton(
            icon: const Icon(Icons.compare_arrows),
            tooltip: 'Compare',
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const CompareScreen()),
              );
            },
          ),
        ],
      ),
      body: BlocBuilder<CountryCubit, CountryState>(
        builder: (context, state) {
          if (state is CountryInitial || state is CountryLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is CountryError) {
            return Center(child: Text('Error: ${state.message}'));
          } else if (state is CountryLoaded) {
            return Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: _searchController,
                          onChanged: _onSearchChanged,
                          decoration: InputDecoration(
                            hintText: 'Search by country name...',
                            prefixIcon: const Icon(Icons.search),
                            suffixIcon: _searchController.text.isNotEmpty
                                ? IconButton(
                                    icon: const Icon(Icons.clear),
                                    onPressed: () {
                                      _searchController.clear();
                                      _onSearchChanged('');
                                    },
                                  )
                                : null,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            filled: true,
                            fillColor: Colors.grey[100],
                            contentPadding: const EdgeInsets.symmetric(vertical: 0),
                          ),
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
                      ? const Center(child: Text('No countries found'))
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
    );
  }
}