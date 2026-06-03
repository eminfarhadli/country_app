import 'package:country_app/services/api_service.dart';

void main() async {
  final apiService = ApiService();
  try {
    print('Fetching countries...');
    final countries = await apiService.getAllCountries();
    print('Successfully fetched ${countries.length} countries!');
    if (countries.isNotEmpty) {
      final first = countries.first;
      print('First country: ${first.name}');
      print('Capital: ${first.capital}');
      print('Flag: ${first.flagUrl}');
      print('Borders: ${first.borders}');
      print('Languages: ${first.languages}');
      print('Currencies: ${first.currencies}');
      print('Lat/Lng: ${first.latlng}');
    }
  } catch (e, stack) {
    print('Error: $e');
    print('Stacktrace: $stack');
  }
}
