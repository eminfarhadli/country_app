import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../models/country_model.dart';
import '../screens/detail_screen.dart';
import '../cubit/country_cubit.dart';
import '../widgets/country_flag.dart';
import '../l10n/app_localizations.dart';

class CountryCard extends StatelessWidget {
  final CountryModel country;
  final bool isFavorite;

  const CountryCard({
    super.key,
    required this.country,
    required this.isFavorite,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);

    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => DetailScreen(country: country),
          ),
        );
      },
      child: Card(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            children: [
              CountryFlag(
                imageUrl: country.flagUrl,
                width: 80,
                height: 50,
                borderRadius: 8,
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      country.name,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${l10n.capital}: ${country.capital}',
                      style: TextStyle(
                        // DƏYİŞİKLİK BURADA: withOpacity yerinə withValues istifadə edildi
                        color: theme.textTheme.bodyMedium?.color?.withValues(alpha: 0.7),
                        fontSize: 13,
                      ),
                    ),
                    Text(
                      '${l10n.region}: ${country.region}',
                      style: TextStyle(
                        // DƏYİŞİKLİK BURADA: withOpacity yerinə withValues istifadə edildi
                        color: theme.textTheme.bodyMedium?.color?.withValues(alpha: 0.7),
                        fontSize: 13,
                      ),
                    ),
                  ],
                ),
              ),
              IconButton(
                icon: Icon(
                  isFavorite ? Icons.favorite : Icons.favorite_border,
                  color: isFavorite ? Colors.red : Colors.grey,
                ),
                onPressed: () {
                  context.read<CountryCubit>().toggleFavorite(country.cca3);
                },
              )
            ],
          ),
        ),
      ),
    );
  }
}