import 'dart:async';

import 'package:flutter/material.dart';

import 'trail_sort_options.dart';

class TrailFiltersBar extends StatefulWidget {
  const TrailFiltersBar({
    super.key,
    required this.initialSearch,
    required this.initialCity,
    required this.selectedDifficulty,
    required this.selectedSortBy,
    required this.sortDescending,
    required this.onSearchChanged,
    required this.onCityChanged,
    required this.onDifficultyChanged,
    required this.onSortChanged,
    required this.onAddPressed,
    required this.isLoading,
  });

  final String initialSearch;
  final String initialCity;
  final int? selectedDifficulty;
  final String? selectedSortBy;
  final bool sortDescending;
  final ValueChanged<String> onSearchChanged;
  final ValueChanged<String> onCityChanged;
  final ValueChanged<int?> onDifficultyChanged;
  final void Function(String? sortBy, bool descending) onSortChanged;
  final VoidCallback onAddPressed;
  final bool isLoading;

  @override
  State<TrailFiltersBar> createState() => _TrailFiltersBarState();
}

class _TrailFiltersBarState extends State<TrailFiltersBar> {
  static const Duration _debounceDuration = Duration(milliseconds: 400);

  late final TextEditingController _searchController;
  late final TextEditingController _cityController;
  Timer? _searchDebounce;
  Timer? _cityDebounce;

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController(text: widget.initialSearch);
    _cityController = TextEditingController(text: widget.initialCity);
  }

  @override
  void didUpdateWidget(covariant TrailFiltersBar oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (widget.initialSearch != _searchController.text) {
      _searchController.text = widget.initialSearch;
    }

    if (widget.initialCity != _cityController.text) {
      _cityController.text = widget.initialCity;
    }
  }

  @override
  void dispose() {
    _searchDebounce?.cancel();
    _cityDebounce?.cancel();
    _searchController.dispose();
    _cityController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final selectedSortKey = _resolveSortKey();

    return Wrap(
      alignment: WrapAlignment.spaceBetween,
      crossAxisAlignment: WrapCrossAlignment.center,
      spacing: 12,
      runSpacing: 12,
      children: [
        ConstrainedBox(
          constraints: const BoxConstraints(minWidth: 220, maxWidth: 280),
          child: TextField(
            controller: _searchController,
            onChanged: _onSearchChanged,
            decoration: InputDecoration(
              labelText: 'Pretraga',
              hintText: 'Naziv, opis...',
              prefixIcon: const Icon(Icons.search),
              suffixIcon: _searchController.text.isNotEmpty
                  ? IconButton(
                      tooltip: 'Ocisti pretragu',
                      icon: const Icon(Icons.clear),
                      onPressed: () {
                        _searchController.clear();
                        widget.onSearchChanged('');
                        setState(() {});
                      },
                    )
                  : null,
            ),
          ),
        ),
        ConstrainedBox(
          constraints: const BoxConstraints(minWidth: 220, maxWidth: 280),
          child: TextField(
            controller: _cityController,
            onChanged: _onCityChanged,
            decoration: InputDecoration(
              labelText: 'Grad',
              hintText: 'Npr. Sarajevo',
              prefixIcon: const Icon(Icons.location_city_outlined),
              suffixIcon: _cityController.text.isNotEmpty
                  ? IconButton(
                      tooltip: 'Ocisti grad',
                      icon: const Icon(Icons.clear),
                      onPressed: () {
                        _cityController.clear();
                        widget.onCityChanged('');
                        setState(() {});
                      },
                    )
                  : null,
            ),
          ),
        ),
        ConstrainedBox(
          constraints: const BoxConstraints(minWidth: 170, maxWidth: 190),
          child: DropdownButtonFormField<int?>(
            initialValue: widget.selectedDifficulty,
            items: const [
              DropdownMenuItem<int?>(value: null, child: Text('Sve tezine')),
              DropdownMenuItem<int?>(value: 1, child: Text('Easy')),
              DropdownMenuItem<int?>(value: 2, child: Text('Medium')),
              DropdownMenuItem<int?>(value: 3, child: Text('Hard')),
            ],
            onChanged: widget.isLoading ? null : widget.onDifficultyChanged,
            decoration: const InputDecoration(labelText: 'Tezina'),
          ),
        ),
        ConstrainedBox(
          constraints: const BoxConstraints(minWidth: 220, maxWidth: 240),
          child: DropdownButtonFormField<String>(
            initialValue: selectedSortKey,
            items: trailSortOptions
                .map(
                  (option) => DropdownMenuItem<String>(
                    value: option.key,
                    child: Text(option.label, overflow: TextOverflow.ellipsis),
                  ),
                )
                .toList(),
            onChanged: widget.isLoading
                ? null
                : (value) {
                    if (value == null) {
                      return;
                    }
                    final selectedOption = trailSortOptions.firstWhere(
                      (option) => option.key == value,
                    );
                    widget.onSortChanged(
                      selectedOption.sortBy,
                      selectedOption.descending,
                    );
                  },
            decoration: const InputDecoration(labelText: 'Sortiranje'),
          ),
        ),
        FilledButton.icon(
          onPressed: widget.isLoading ? null : widget.onAddPressed,
          icon: const Icon(Icons.add),
          label: const Text('Nova staza'),
        ),
      ],
    );
  }

  void _onSearchChanged(String value) {
    _searchDebounce?.cancel();
    _searchDebounce = Timer(_debounceDuration, () {
      widget.onSearchChanged(value);
    });

    setState(() {});
  }

  void _onCityChanged(String value) {
    _cityDebounce?.cancel();
    _cityDebounce = Timer(_debounceDuration, () {
      widget.onCityChanged(value);
    });

    setState(() {});
  }

  String _resolveSortKey() {
    for (final option in trailSortOptions) {
      if (option.sortBy == widget.selectedSortBy &&
          option.descending == widget.sortDescending) {
        return option.key;
      }
    }

    return 'created_desc';
  }
}
