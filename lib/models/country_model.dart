import 'country_mapper.dart';

class CountryModel {
  final String name;
  final String cca3;
  final String capital;
  final String flagUrl;
  final int population;
  final String region;
  final String subregion;
  final double area;
  final List<String> borders;
  final List<String> timezones;
  final List<String> languages;
  final List<String> currencies;
  final List<double> latlng;

  CountryModel({
    required this.name,
    required this.cca3,
    required this.capital,
    required this.flagUrl,
    required this.population,
    required this.region,
    required this.subregion,
    required this.area,
    required this.borders,
    required this.timezones,
    required this.languages,
    required this.currencies,
    required this.latlng,
  });

  factory CountryModel.fromJson(Map<String, dynamic> json) {
    return CountryMapper.fromJson(json);
  }
}
