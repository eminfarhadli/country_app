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
    // Safely extract languages
    List<String> langs = [];
    if (json['languages'] != null) {
      langs = (json['languages'] as Map<String, dynamic>).values.map((e) => e.toString()).toList();
    }

    // Safely extract currencies
    List<String> currs = [];
    if (json['currencies'] != null) {
      currs = (json['currencies'] as Map<String, dynamic>).values.map((e) {
        final name = e['name'] ?? '';
        final symbol = e['symbol'] ?? '';
        return '$name ($symbol)';
      }).toList();
    }

    // Coordinates
    List<double> coordinates = [];
    if (json['latlng'] != null && (json['latlng'] as List).length >= 2) {
      coordinates = [
        (json['latlng'][0] as num).toDouble(),
        (json['latlng'][1] as num).toDouble(),
      ];
    }

    return CountryModel(
      name: json['name']?['common'] ?? 'Unknown',
      cca3: json['cca3'] ?? '',
      capital: (json['capital'] != null && (json['capital'] as List).isNotEmpty) ? json['capital'][0] : 'No Capital',
      flagUrl: json['flags']?['png'] ?? '',
      population: json['population'] ?? 0,
      region: json['region'] ?? 'Unknown',
      subregion: json['subregion'] ?? 'Unknown',
      area: (json['area'] as num?)?.toDouble() ?? 0.0,
      borders: json['borders'] != null ? List<String>.from(json['borders']) : [],
      timezones: json['timezones'] != null ? List<String>.from(json['timezones']) : [],
      languages: langs,
      currencies: currs,
      latlng: coordinates,
    );
  }
}
