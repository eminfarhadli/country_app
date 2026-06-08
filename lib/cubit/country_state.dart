import 'package:equatable/equatable.dart';
import '../models/country_model.dart';

abstract class CountryState extends Equatable {
  const CountryState();

  @override
  List<Object?> get props => [];
}

class CountryInitial extends CountryState {}

class CountryLoading extends CountryState {}

class CountryLoaded extends CountryState {
  final List<CountryModel> allCountries;
  final List<CountryModel> displayedCountries;
  final List<String> favoriteCca3s;
  final String searchQuery;
  final String selectedRegion;
  final String sortType; // 'population', 'area', 'alphabetical'

  const CountryLoaded({
    required this.allCountries,
    required this.displayedCountries,
    required this.favoriteCca3s,
    this.searchQuery = '',
    this.selectedRegion = 'All',
    this.sortType = 'alphabetical',
  });

  CountryLoaded copyWith({
    List<CountryModel>? allCountries,
    List<CountryModel>? displayedCountries,
    List<String>? favoriteCca3s,
    String? searchQuery,
    String? selectedRegion,
    String? sortType,
  }) {
    return CountryLoaded(
      allCountries: allCountries ?? this.allCountries,
      displayedCountries: displayedCountries ?? this.displayedCountries,
      favoriteCca3s: favoriteCca3s ?? this.favoriteCca3s,
      searchQuery: searchQuery ?? this.searchQuery,
      selectedRegion: selectedRegion ?? this.selectedRegion,
      sortType: sortType ?? this.sortType,
    );
  }

  @override
  List<Object?> get props => [
        allCountries,
        displayedCountries,
        favoriteCca3s,
        searchQuery,
        selectedRegion,
        sortType,
      ];
}

class CountryError extends CountryState {
  final String message;
  const CountryError(this.message);

  @override
  List<Object?> get props => [message];
}
