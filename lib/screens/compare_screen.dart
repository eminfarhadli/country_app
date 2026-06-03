import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../models/country_model.dart';
import '../cubit/country_cubit.dart';
import '../cubit/country_state.dart';

class CompareScreen extends StatefulWidget {
  const CompareScreen({super.key});

  @override
  State<CompareScreen> createState() => _CompareScreenState();
}

class _CompareScreenState extends State<CompareScreen> {
  CountryModel? country1;
  CountryModel? country2;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Compare Countries'),
      ),
      body: BlocBuilder<CountryCubit, CountryState>(
        builder: (context, state) {
          if (state is! CountryLoaded) {
            return const Center(child: CircularProgressIndicator());
          }

          final allCountries = state.allCountries;

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                Row(
                  children: [
                    Expanded(
                      child: DropdownButtonFormField<CountryModel>(
                        isExpanded: true,
                        decoration: const InputDecoration(
                          labelText: 'Country 1',
                          border: OutlineInputBorder(),
                        ),
                        initialValue: country1,
                        items: allCountries.map((c) {
                          return DropdownMenuItem(
                            value: c,
                            child: Text(c.name, overflow: TextOverflow.ellipsis),
                          );
                        }).toList(),
                        onChanged: (val) {
                          setState(() {
                            country1 = val;
                          });
                        },
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: DropdownButtonFormField<CountryModel>(
                        isExpanded: true,
                        decoration: const InputDecoration(
                          labelText: 'Country 2',
                          border: OutlineInputBorder(),
                        ),
                        initialValue: country2,
                        items: allCountries.map((c) {
                          return DropdownMenuItem(
                            value: c,
                            child: Text(c.name, overflow: TextOverflow.ellipsis),
                          );
                        }).toList(),
                        onChanged: (val) {
                          setState(() {
                            country2 = val;
                          });
                        },
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                if (country1 != null && country2 != null)
                  _buildComparisonTable(country1!, country2!),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildComparisonTable(CountryModel c1, CountryModel c2) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: Column(
                    children: [
                      CachedNetworkImage(
                        imageUrl: c1.flagUrl,
                        height: 60,
                        placeholder: (context, url) => const CircularProgressIndicator(),
                        errorWidget: (context, url, error) => const Icon(Icons.error),
                      ),
                      const SizedBox(height: 8),
                      Text(c1.name, style: const TextStyle(fontWeight: FontWeight.bold), textAlign: TextAlign.center),
                    ],
                  ),
                ),
                const SizedBox(width: 16),
                const Text('VS', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.indigo)),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    children: [
                      CachedNetworkImage(
                        imageUrl: c2.flagUrl,
                        height: 60,
                        placeholder: (context, url) => const CircularProgressIndicator(),
                        errorWidget: (context, url, error) => const Icon(Icons.error),
                      ),
                      const SizedBox(height: 8),
                      Text(c2.name, style: const TextStyle(fontWeight: FontWeight.bold), textAlign: TextAlign.center),
                    ],
                  ),
                ),
              ],
            ),
            const Divider(height: 32),
            _buildStatRow('Capital', c1.capital, c2.capital),
            _buildStatRow('Region', c1.region, c2.region),
            _buildStatRow('Population', c1.population.toString(), c2.population.toString()),
            _buildStatRow('Area (km²)', c1.area.toString(), c2.area.toString()),
            _buildStatRow('Timezones', c1.timezones.join(', '), c2.timezones.join(', ')),
          ],
        ),
      ),
    );
  }

  Widget _buildStatRow(String label, String val1, String val2) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Column(
        children: [
          Text(label, style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.grey)),
          const SizedBox(height: 4),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Text(val1, textAlign: TextAlign.center),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Text(val2, textAlign: TextAlign.center),
              ),
            ],
          ),
          const Divider(),
        ],
      ),
    );
  }
}
