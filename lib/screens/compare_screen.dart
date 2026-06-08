import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../models/country_model.dart';
import '../cubit/country_cubit.dart';
import '../cubit/country_state.dart';
import '../widgets/country_flag.dart';
import '../utils/number_formatter.dart';
import '../l10n/app_localizations.dart';
import '../theme/app_theme.dart';

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
    final l10n = AppLocalizations.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.compareCountries),
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
                        decoration: InputDecoration(
                          labelText: l10n.country1Label,
                          border: const OutlineInputBorder(),
                        ),
                        // DƏYİŞİKLİK BURADA: value yerinə initialValue yazıldı
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
                        decoration: InputDecoration(
                          labelText: l10n.country2Label,
                          border: const OutlineInputBorder(),
                        ),
                        // DƏYİŞİKLİK BURADA: value yerinə initialValue yazıldı
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
                  _buildComparisonTable(country1!, country2!, l10n),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildComparisonTable(CountryModel c1, CountryModel c2, AppLocalizations l10n) {
    final theme = Theme.of(context);

    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: AppTheme.borderRadius12),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: Column(
                    children: [
                      CountryFlag(
                        imageUrl: c1.flagUrl,
                        height: 60,
                        borderRadius: 6,
                      ),
                      const SizedBox(height: 8),
                      Text(c1.name, style: const TextStyle(fontWeight: FontWeight.bold), textAlign: TextAlign.center),
                    ],
                  ),
                ),
                const SizedBox(width: 16),
                Text(
                  l10n.vs,
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: theme.colorScheme.primary,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    children: [
                      CountryFlag(
                        imageUrl: c2.flagUrl,
                        height: 60,
                        borderRadius: 6,
                      ),
                      const SizedBox(height: 8),
                      Text(c2.name, style: const TextStyle(fontWeight: FontWeight.bold), textAlign: TextAlign.center),
                    ],
                  ),
                ),
              ],
            ),
            const Divider(height: 32),
            _buildStatRow(l10n.capital, c1.capital, c2.capital),
            _buildStatRow(l10n.region, c1.region, c2.region),
            _buildStatRow(l10n.population, NumberFormatter.format(c1.population), NumberFormatter.format(c2.population)),
            _buildStatRow('${l10n.area} (km²)', NumberFormatter.format(c1.area), NumberFormatter.format(c2.area)),
            _buildStatRow(l10n.timezones, c1.timezones.join(', '), c2.timezones.join(', ')),
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