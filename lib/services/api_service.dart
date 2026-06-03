import 'package:dio/dio.dart';
import '../models/country_model.dart';

class ApiService {
  final Dio _dio = Dio(
    BaseOptions(
      baseUrl: 'https://restcountries.com/v3.1',
      connectTimeout: const Duration(seconds: 10),
      receiveTimeout: const Duration(seconds: 10),
      // Serverdən gələn bəzi xətaları birbaşa crash etməməsi üçün
      validateStatus: (status) {
        return status != null && status < 500;
      },
    ),
  );

  Future<List<CountryModel>> getAllCountries() async {
    try {
      // REST Countries API-də 10-dan çox sahə (field) tələb etdikdə 400 xətası verir.
      // Bu problemi həll etmək üçün sorğuları iki hissəyə bölürük və paralel olaraq icra edirik:
      final responses = await Future.wait([
        _dio.get(
          '/all',
          queryParameters: {
            'fields': 'name,cca3,capital,flags,population,region,subregion,area,borders,timezones'
          },
          options: Options(
            headers: {
              'Accept': 'application/json',
              'User-Agent': 'Flutter_Country_App',
            },
          ),
        ),
        _dio.get(
          '/all',
          queryParameters: {
            'fields': 'cca3,languages,currencies,latlng'
          },
          options: Options(
            headers: {
              'Accept': 'application/json',
              'User-Agent': 'Flutter_Country_App',
            },
          ),
        ),
      ]);

      final response1 = responses[0];
      final response2 = responses[1];

      if (response1.statusCode == 200 && response2.statusCode == 200) {
        final List<dynamic> data1 = response1.data;
        final List<dynamic> data2 = response2.data;

        // İkinci sorğunun datalarını cca3-ə görə qruplaşdırırıq (sürətli axtarış üçün)
        final Map<String, dynamic> additionalData = {};
        for (var item in data2) {
          if (item is Map<String, dynamic>) {
            final cca3 = item['cca3'];
            if (cca3 != null) {
              additionalData[cca3] = item;
            }
          }
        }

        // Dataları birləşdiririk
        final List<Map<String, dynamic>> combinedList = [];
        for (var item in data1) {
          if (item is Map<String, dynamic>) {
            final Map<String, dynamic> combined = Map<String, dynamic>.from(item);
            final cca3 = item['cca3'];
            if (cca3 != null && additionalData.containsKey(cca3)) {
              final extra = additionalData[cca3];
              combined['languages'] = extra['languages'];
              combined['currencies'] = extra['currencies'];
              combined['latlng'] = extra['latlng'];
            }
            combinedList.add(combined);
          }
        }

        return combinedList.map((json) => CountryModel.fromJson(json)).toList();
      } else {
        throw Exception('Server error: ${response1.statusCode} / ${response2.statusCode}');
      }
    } catch (e) {
      throw Exception('Error fetching countries: $e');
    }
  }
}