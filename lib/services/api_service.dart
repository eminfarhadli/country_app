import 'dart:io';
import 'package:dio/dio.dart';
import '../models/country_model.dart';

class ApiService {
  final Dio _dio = Dio(
    BaseOptions(
      baseUrl: 'https://restcountries.com/v3.1',
      connectTimeout: const Duration(seconds: 10),
      receiveTimeout: const Duration(seconds: 10),
      // Set common headers here to avoid repeating them in get calls
      headers: {
        'Accept': 'application/json',
        'User-Agent': 'Flutter_Country_App',
      },
      // Keep statuses < 500 from crashing automatically
      validateStatus: (status) {
        return status != null && status < 500;
      },
    ),
  );

  Future<List<CountryModel>> getAllCountries() async {
    try {
      // REST Countries API returns 400 if too many fields are requested.
      // We divide the query into two requests and run them concurrently.
      final responses = await Future.wait([
        _dio.get(
          '/all',
          queryParameters: {
            'fields': 'name,cca3,capital,flags,population,region,subregion,area,borders,timezones'
          },
        ),
        _dio.get(
          '/all',
          queryParameters: {
            'fields': 'cca3,languages,currencies,latlng'
          },
        ),
      ]);

      final response1 = responses[0];
      final response2 = responses[1];

      if (response1.statusCode == 200 && response2.statusCode == 200) {
        final List<dynamic> data1 = response1.data;
        final List<dynamic> data2 = response2.data;

        // Index the second request's data by cca3 for fast lookups
        final Map<String, dynamic> additionalData = {};
        for (var item in data2) {
          if (item is Map<String, dynamic>) {
            final cca3 = item['cca3'];
            if (cca3 != null) {
              additionalData[cca3] = item;
            }
          }
        }

        // Combine the datasets
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
        throw DioException(
          requestOptions: response1.requestOptions,
          response: response1,
          type: DioExceptionType.badResponse,
        );
      }
    } on DioException catch (e, stackTrace) {
      String errorMessage = 'error_unexpected';
      if (e.type == DioExceptionType.connectionTimeout ||
          e.type == DioExceptionType.sendTimeout ||
          e.type == DioExceptionType.receiveTimeout ||
          e.error is SocketException) {
        errorMessage = 'error_network';
      } else if (e.response != null) {
        errorMessage = 'error_server';
      }
      Error.throwWithStackTrace(Exception(errorMessage), stackTrace);
    } catch (e, stackTrace) {
      Error.throwWithStackTrace(Exception('error_unexpected'), stackTrace);
    }
  }
}