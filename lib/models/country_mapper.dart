import 'country_model.dart';

class CountryMapper {
  static CountryModel fromJson(Map<String, dynamic> json) {
    // 1. Name parsing (Safely reading json['name']['common'])
    String name = 'Unknown';
    final nameData = json['name'];
    if (nameData is Map<String, dynamic>) {
      name = nameData['common']?.toString() ?? 'Unknown';
    } else if (nameData is Map) {
      name = nameData['common']?.toString() ?? 'Unknown';
    }

    // 2. Cca3 parsing
    final cca3 = json['cca3']?.toString() ?? '';

    // 3. Capital parsing (Safely reading json['capital'][0])
    String capital = 'No Capital';
    final capitalData = json['capital'];
    if (capitalData is List && capitalData.isNotEmpty) {
      capital = capitalData[0]?.toString() ?? 'No Capital';
    }

    // 4. FlagUrl parsing (Safely reading json['flags']['png'])
    String flagUrl = '';
    final flagsData = json['flags'];
    if (flagsData is Map<String, dynamic>) {
      flagUrl = flagsData['png']?.toString() ?? '';
    } else if (flagsData is Map) {
      flagUrl = flagsData['png']?.toString() ?? '';
    }

    // 5. Population parsing
    int population = 0;
    final populationData = json['population'];
    if (populationData is num) {
      population = populationData.toInt();
    }

    // 6. Region & Subregion parsing
    final region = json['region']?.toString() ?? 'Unknown';
    final subregion = json['subregion']?.toString() ?? 'Unknown';

    // 7. Area parsing
    double area = 0.0;
    final areaData = json['area'];
    if (areaData is num) {
      area = areaData.toDouble();
    }

    // 8. Borders parsing
    List<String> borders = [];
    final bordersData = json['borders'];
    if (bordersData is List) {
      borders = bordersData.map((e) => e?.toString() ?? '').where((s) => s.isNotEmpty).toList();
    }

    // 9. Timezones parsing
    List<String> timezones = [];
    final timezonesData = json['timezones'];
    if (timezonesData is List) {
      timezones = timezonesData.map((e) => e?.toString() ?? '').where((s) => s.isNotEmpty).toList();
    }

    // 10. Languages parsing (Safely mapping values)
    List<String> languages = [];
    final languagesData = json['languages'];
    if (languagesData is Map) {
      languages = languagesData.values
          .map((e) => e?.toString() ?? '')
          .where((s) => s.isNotEmpty)
          .toList();
    }

    // 11. Currencies parsing (Safely extract name and symbol)
    List<String> currencies = [];
    final currenciesData = json['currencies'];
    if (currenciesData is Map) {
      for (final value in currenciesData.values) {
        if (value is Map) {
          final cName = value['name']?.toString() ?? '';
          final cSymbol = value['symbol']?.toString() ?? '';
          if (cName.isNotEmpty && cSymbol.isNotEmpty) {
            currencies.add('$cName ($cSymbol)');
          } else if (cName.isNotEmpty) {
            currencies.add(cName);
          } else if (cSymbol.isNotEmpty) {
            currencies.add(cSymbol);
          }
        }
      }
    }

    // 12. LatLng coordinates parsing (Safely reading coordinates)
    List<double> latlng = [];
    final latlngData = json['latlng'];
    if (latlngData is List && latlngData.length >= 2) {
      final lat = latlngData[0];
      final lng = latlngData[1];
      if (lat is num && lng is num) {
        latlng = [lat.toDouble(), lng.toDouble()];
      }
    }

    return CountryModel(
      name: name,
      cca3: cca3,
      capital: capital,
      flagUrl: flagUrl,
      population: population,
      region: region,
      subregion: subregion,
      area: area,
      borders: borders,
      timezones: timezones,
      languages: languages,
      currencies: currencies,
      latlng: latlng,
    );
  }
}
