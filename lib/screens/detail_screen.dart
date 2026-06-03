import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import '../models/country_model.dart';
import '../cubit/country_cubit.dart';
import '../cubit/country_state.dart';

class DetailScreen extends StatelessWidget {
  final CountryModel country;

  const DetailScreen({super.key, required this.country});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(country.name),
        actions: [
          BlocBuilder<CountryCubit, CountryState>(
            builder: (context, state) {
              if (state is CountryLoaded) {
                final isFavorite = state.favoriteCca3s.contains(country.cca3);
                return IconButton(
                  icon: Icon(
                    isFavorite ? Icons.favorite : Icons.favorite_border,
                    color: isFavorite ? Colors.red : Colors.white,
                  ),
                  onPressed: () {
                    context.read<CountryCubit>().toggleFavorite(country.cca3);
                  },
                );
              }
              return const SizedBox();
            },
          )
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            CachedNetworkImage(
              imageUrl: country.flagUrl,
              height: 200,
              fit: BoxFit.cover,
              placeholder: (context, url) => const Center(child: CircularProgressIndicator()),
              errorWidget: (context, url, error) => const Icon(Icons.error),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildInfoRow('Capital', country.capital),
                  _buildInfoRow('Population', country.population.toString()),
                  _buildInfoRow('Area', '${country.area} km²'),
                  _buildInfoRow('Region', country.region),
                  _buildInfoRow('Subregion', country.subregion),
                  _buildInfoRow('Timezones', country.timezones.join(', ')),
                  _buildInfoRow('Languages', country.languages.join(', ')),
                  _buildInfoRow('Currencies', country.currencies.join(', ')),
                  const SizedBox(height: 16),
                  if (country.borders.isNotEmpty) ...[
                    const Text(
                      'Borders:',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: country.borders.map((borderCca3) {
                        return ActionChip(
                          label: Text(borderCca3),
                          onPressed: () {
                            final borderCountry = context.read<CountryCubit>().getCountryByCca3(borderCca3);
                            if (borderCountry != null) {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => DetailScreen(country: borderCountry),
                                ),
                              );
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text('Country data not found')),
                              );
                            }
                          },
                        );
                      }).toList(),
                    ),
                    const SizedBox(height: 16),
                  ],
                  if (country.latlng.length == 2) ...[
                    const Text(
                      'Map:',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8),
                    SizedBox(
                      height: 250,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: FlutterMap(
                          options: MapOptions(
                            initialCenter: LatLng(country.latlng[0], country.latlng[1]),
                            initialZoom: 5.0,
                          ),
                          children: [
                            TileLayer(
                              urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                              userAgentPackageName: 'com.example.country_app',
                            ),
                            MarkerLayer(
                              markers: [
                                Marker(
                                  point: LatLng(country.latlng[0], country.latlng[1]),
                                  width: 80,
                                  height: 80,
                                  child: const Icon(
                                    Icons.location_on,
                                    color: Colors.red,
                                    size: 40,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '$label: ',
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(fontSize: 16),
            ),
          ),
        ],
      ),
    );
  }
}
