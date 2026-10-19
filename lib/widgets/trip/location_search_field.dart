import 'dart:async';

import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../models/geocode_model.dart';
import '../../services/geocode_service.dart';

/// Text field with debounced, Nominatim-backed location suggestions
/// rendered inline below it. Calls [onSelected] with real lat/lon only
/// when the user taps a suggestion — never on raw typed text — so the
/// caller can tell "a real place was picked" from "user typed something
/// but never selected anything" (the difference between real coordinates
/// and the old hardcoded 0.0001 placeholders).
class LocationSearchField extends StatefulWidget {
  final TextEditingController controller;
  final String hint;
  final IconData icon;
  final void Function(GeocodeResult result) onSelected;

  const LocationSearchField({
    super.key,
    required this.controller,
    required this.hint,
    required this.icon,
    required this.onSelected,
  });

  @override
  State<LocationSearchField> createState() => _LocationSearchFieldState();
}

class _LocationSearchFieldState extends State<LocationSearchField> {
  final GeocodeService _geocodeService = GeocodeService();
  Timer? _debounce;
  List<GeocodeResult> _suggestions = [];
  bool _isLoading = false;
  bool _showSuggestions = false;

  void _onChanged(String value) {
    // Any manual edit after a selection invalidates that selection —
    // the caller's stored lat/lon would now refer to stale text.
    widget.onSelected(GeocodeResult(lat: 0, lon: 0, displayName: ''));

    _debounce?.cancel();
    if (value.trim().length < 2) {
      setState(() {
        _suggestions = [];
        _showSuggestions = false;
      });
      return;
    }

    setState(() {
      _isLoading = true;
      _showSuggestions = true;
    });

    _debounce = Timer(const Duration(milliseconds: 450), () async {
      final results = await _geocodeService.search(value);
      if (!mounted) return;
      setState(() {
        _suggestions = results;
        _isLoading = false;
      });
    });
  }

  void _select(GeocodeResult result) {
    widget.controller.text = result.displayName;
    setState(() {
      _suggestions = [];
      _showSuggestions = false;
    });
    FocusScope.of(context).unfocus();
    widget.onSelected(result);
  }

  @override
  void dispose() {
    _debounce?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextField(
          controller: widget.controller,
          onChanged: _onChanged,
          decoration: InputDecoration(
            hintText: widget.hint,
            hintStyle: AppTextStyles.hint,
            prefixIcon: Icon(widget.icon, size: 18, color: AppColors.hintText),
            suffixIcon: _isLoading
                ? const Padding(
                    padding: EdgeInsets.all(12),
                    child: SizedBox(
                      width: 14,
                      height: 14,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    ),
                  )
                : null,
            filled: true,
            fillColor: AppColors.lightInputBg,
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide.none,
            ),
          ),
        ),
        if (_showSuggestions && _suggestions.isNotEmpty)
          Container(
            margin: const EdgeInsets.only(top: 4),
            decoration: BoxDecoration(
              color: AppColors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppColors.border),
            ),
            constraints: const BoxConstraints(maxHeight: 200),
            child: ListView.separated(
              shrinkWrap: true,
              padding: const EdgeInsets.symmetric(vertical: 4),
              itemCount: _suggestions.length,
              separatorBuilder: (_, _) =>
                  const Divider(height: 1, color: AppColors.border),
              itemBuilder: (context, i) {
                final result = _suggestions[i];
                return ListTile(
                  dense: true,
                  leading: const Icon(
                    Icons.location_on_outlined,
                    size: 18,
                    color: AppColors.primaryNavy,
                  ),
                  title: Text(
                    result.displayName,
                    style: const TextStyle(fontSize: 12.5),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  onTap: () => _select(result),
                );
              },
            ),
          ),
        if (_showSuggestions &&
            !_isLoading &&
            _suggestions.isEmpty &&
            widget.controller.text.trim().length >= 2)
          Padding(
            padding: const EdgeInsets.only(top: 6, left: 4),
            child: Text(
              'No matches found — try a different spelling.',
              style: AppTextStyles.bodySmall,
            ),
          ),
      ],
    );
  }
}