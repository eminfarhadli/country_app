import 'package:bloc/bloc.dart';
import '../models/country_model.dart';
import '../services/api_service.dart';
import '../services/storage_service.dart';
import 'country_state.dart';
import 'dart:math';

class CountryCubit extends Cubit<CountryState> {
  final ApiService apiService;
  final StorageService storageService;

  CountryCubit({required this.apiService, required this.storageService}) : super(CountryInitial());

  void fetchCountries() async {
    emit(CountryLoading());
    try {
      final countries = await apiService.getAllCountries();
      // sort alphabetically initially
      countries.sort((a, b) => a.name.compareTo(b.name));
      
      final favorites = storageService.getFavorites();

      emit(CountryLoaded(
        allCountries: countries,
        displayedCountries: countries,
        favoriteCca3s: favorites,
      ));
    } catch (e) {
      emit(CountryError(e.toString()));
    }
  }

  void searchAndFilter(String query, String region, String sortType) {
    if (state is! CountryLoaded) return;
    final currentState = state as CountryLoaded;
    
    List<CountryModel> filtered = List.from(currentState.allCountries);

    // Filter by Region
    if (region != 'All') {
      filtered = filtered.where((c) => c.region == region).toList();
    }

    // Filter by Search Query
    if (query.isNotEmpty) {
      filtered = filtered
          .where((c) => c.name.toLowerCase().contains(query.toLowerCase()))
          .toList();
    }

    // Sort
    if (sortType == 'population') {
      filtered.sort((a, b) => b.population.compareTo(a.population));
    } else if (sortType == 'area') {
      filtered.sort((a, b) => b.area.compareTo(a.area));
    } else {
      // alphabetical
      filtered.sort((a, b) => a.name.compareTo(b.name));
    }

    emit(currentState.copyWith(
      displayedCountries: filtered,
      searchQuery: query,
      selectedRegion: region,
      sortType: sortType,
    ));
  }

  void toggleFavorite(String cca3) async {
    if (state is! CountryLoaded) return;
    final currentState = state as CountryLoaded;

    await storageService.toggleFavorite(cca3);
    final updatedFavorites = storageService.getFavorites();

    emit(currentState.copyWith(favoriteCca3s: updatedFavorites));
  }

  CountryModel? getRandomCountry() {
    if (state is! CountryLoaded) return null;
    final countries = (state as CountryLoaded).allCountries;
    if (countries.isEmpty) return null;
    final randomIndex = Random().nextInt(countries.length);
    return countries[randomIndex];
  }

  CountryModel? getCountryByCca3(String cca3) {
    if (state is! CountryLoaded) return null;
    final countries = (state as CountryLoaded).allCountries;
    try {
      return countries.firstWhere((c) => c.cca3 == cca3);
    } catch (_) {
      return null;
    }
  }
}
