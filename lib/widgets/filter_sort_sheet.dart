import 'package:flutter/material.dart';
import '../l10n/app_localizations.dart';
import '../theme/app_theme.dart';

class FilterSortSheet extends StatefulWidget {
  final String initialRegion;
  final String initialSortType;
  final List<String> regions;
  final List<String> sortTypes;
  final Function(String region, String sortType) onApply;

  const FilterSortSheet({
    super.key,
    required this.initialRegion,
    required this.initialSortType,
    required this.regions,
    required this.sortTypes,
    required this.onApply,
  });

  @override
  State<FilterSortSheet> createState() => _FilterSortSheetState();
}

class _FilterSortSheetState extends State<FilterSortSheet> {
  late String _tempRegion;
  late String _tempSort;

  @override
  void initState() {
    super.initState();
    _tempRegion = widget.initialRegion;
    _tempSort = widget.initialSortType;
  }

  String _getRegionDisplay(String region, AppLocalizations l10n) {
    if (region == 'All') return l10n.all;
    return region;
  }

  String _getSortDisplay(String sort, AppLocalizations l10n) {
    if (sort == 'alphabetical') return l10n.alphabetical;
    if (sort == 'population') return l10n.population;
    if (sort == 'area') return l10n.area;
    return sort.toUpperCase();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return Padding(
      padding: EdgeInsets.only(
        top: 16.0,
        left: 16.0,
        right: 16.0,
        bottom: MediaQuery.of(context).viewInsets.bottom + 16.0,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            l10n.filterByRegion,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            runSpacing: 4,
            children: widget.regions.map((r) {
              final isSelected = _tempRegion.toLowerCase() == r.toLowerCase();
              return ChoiceChip(
                label: Text(_getRegionDisplay(r, l10n)),
                selected: isSelected,
                onSelected: (selected) {
                  if (selected) {
                    setState(() => _tempRegion = r);
                  }
                },
              );
            }).toList(),
          ),
          const SizedBox(height: 16),
          Text(
            l10n.sortBy,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            children: widget.sortTypes.map((s) {
              final isSelected = _tempSort == s;
              return ChoiceChip(
                label: Text(_getSortDisplay(s, l10n)),
                selected: isSelected,
                onSelected: (selected) {
                  if (selected) {
                    setState(() => _tempSort = s);
                  }
                },
              );
            }).toList(),
          ),
          const SizedBox(height: 24),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: AppTheme.borderRadius12,
                ),
              ),
              onPressed: () {
                widget.onApply(_tempRegion, _tempSort);
                Navigator.pop(context);
              },
              child: Text(
                l10n.apply,
                style: const TextStyle(fontSize: 16),
              ),
            ),
          )
        ],
      ),
    );
  }
}
