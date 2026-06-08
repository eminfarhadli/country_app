import 'package:flutter/material.dart';

class AppLocalizations {
  final Locale locale;
  AppLocalizations(this.locale);

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  static const _localizedValues = {
    'en': {
      'app_title': 'Country Explorer',
      'search_hint': 'Search by country name...',
      'filter_by_region': 'Filter by Region',
      'sort_by': 'Sort by',
      'apply': 'Apply',
      'no_countries_found': 'No countries found',
      'random_country': 'Random Country',
      'favorites': 'Favorites',
      'compare': 'Compare',
      'no_country_available': 'No country available',
      'compare_countries': 'Compare Countries',
      'country_1': 'Country 1',
      'country_2': 'Country 2',
      'capital': 'Capital',
      'region': 'Region',
      'population': 'Population',
      'area': 'Area',
      'timezones': 'Timezones',
      'subregion': 'Subregion',
      'languages': 'Languages',
      'currencies': 'Currencies',
      'borders': 'Borders',
      'map': 'Map',
      'error_loading': 'Error loading countries',
      'no_favorites': 'No favorites yet.',
      'country_not_found': 'Country data not found',
      'error_network': 'Network error. Please check your internet connection.',
      'error_server': 'Server error. Please try again later.',
      'error_unexpected': 'Unexpected error occurred.',
      'all': 'All',
      'alphabetical': 'Alphabetical',
      'search_by_country_name': 'Search by country name...',
      'vs': 'VS',
    },
    'az': {
      'app_title': 'Ölkə Bələdçisi',
      'search_hint': 'Ölkə adına görə axtar...',
      'filter_by_region': 'Region üzrə filtrlə',
      'sort_by': 'Sırala',
      'apply': 'Tətbiq et',
      'no_countries_found': 'Ölkə tapılmadı',
      'random_country': 'Təsadüfi Ölkə',
      'favorites': 'Sevimlilər',
      'compare': 'Müqayisə et',
      'no_country_available': 'Mövcud ölkə yoxdur',
      'compare_countries': 'Ölkələri Müqayisə Et',
      'country_1': 'Ölkə 1',
      'country_2': 'Ölkə 2',
      'capital': 'Paytaxt',
      'region': 'Region',
      'population': 'Əhali',
      'area': 'Sahə',
      'timezones': 'Saat qurşaqları',
      'subregion': 'Subregion',
      'languages': 'Dillər',
      'currencies': 'Valyutalar',
      'borders': 'Sərhədlər',
      'map': 'Xəritə',
      'error_loading': 'Ölkələri yükləyərkən xəta baş verdi',
      'no_favorites': 'Hələ ki sevimli ölkə yoxdur.',
      'country_not_found': 'Ölkə məlumatı tapılmadı',
      'error_network': 'Şəbəkə xətası. İnternet bağlantınızı yoxlayın.',
      'error_server': 'Server xətası. Zəhmət olmasa sonra yenidən cəhd edin.',
      'error_unexpected': 'Gözlənilməz xəta baş verdi.',
      'all': 'Hamısı',
      'alphabetical': 'Əlifba sırası',
      'search_by_country_name': 'Ölkə adına görə axtar...',
      'vs': 'MƏQ',
    },
  };

  String get appTitle => _localizedValues[locale.languageCode]!['app_title']!;
  String get searchHint => _localizedValues[locale.languageCode]!['search_hint']!;
  String get filterByRegion => _localizedValues[locale.languageCode]!['filter_by_region']!;
  String get sortBy => _localizedValues[locale.languageCode]!['sort_by']!;
  String get apply => _localizedValues[locale.languageCode]!['apply']!;
  String get noCountriesFound => _localizedValues[locale.languageCode]!['no_countries_found']!;
  String get randomCountry => _localizedValues[locale.languageCode]!['random_country']!;
  String get favorites => _localizedValues[locale.languageCode]!['favorites']!;
  String get compare => _localizedValues[locale.languageCode]!['compare']!;
  String get noCountryAvailable => _localizedValues[locale.languageCode]!['no_country_available']!;
  String get compareCountries => _localizedValues[locale.languageCode]!['compare_countries']!;
  String get country1Label => _localizedValues[locale.languageCode]!['country_1']!;
  String get country2Label => _localizedValues[locale.languageCode]!['country_2']!;
  String get capital => _localizedValues[locale.languageCode]!['capital']!;
  String get region => _localizedValues[locale.languageCode]!['region']!;
  String get population => _localizedValues[locale.languageCode]!['population']!;
  String get area => _localizedValues[locale.languageCode]!['area']!;
  String get timezones => _localizedValues[locale.languageCode]!['timezones']!;
  String get subregion => _localizedValues[locale.languageCode]!['subregion']!;
  String get languages => _localizedValues[locale.languageCode]!['languages']!;
  String get currencies => _localizedValues[locale.languageCode]!['currencies']!;
  String get borders => _localizedValues[locale.languageCode]!['borders']!;
  String get map => _localizedValues[locale.languageCode]!['map']!;
  String get errorLoading => _localizedValues[locale.languageCode]!['error_loading']!;
  String get noFavorites => _localizedValues[locale.languageCode]!['no_favorites']!;
  String get countryNotFound => _localizedValues[locale.languageCode]!['country_not_found']!;
  String get errorNetwork => _localizedValues[locale.languageCode]!['error_network']!;
  String get errorServer => _localizedValues[locale.languageCode]!['error_server']!;
  String get errorUnexpected => _localizedValues[locale.languageCode]!['error_unexpected']!;
  String get all => _localizedValues[locale.languageCode]!['all']!;
  String get alphabetical => _localizedValues[locale.languageCode]!['alphabetical']!;
  String get searchByCountryName => _localizedValues[locale.languageCode]!['search_by_country_name']!;
  String get vs => _localizedValues[locale.languageCode]!['vs']!;
}

class AppLocalizationsDelegate extends LocalizationsDelegate<AppLocalizations> {
  const AppLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) => ['en', 'az'].contains(locale.languageCode);

  @override
  Future<AppLocalizations> load(Locale locale) async {
    return AppLocalizations(locale);
  }

  @override
  bool shouldReload(AppLocalizationsDelegate old) => false;
}
