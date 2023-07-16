class FilterOptions {
  Map<String, bool> _categoryFilterStates = <String, bool>{};
  String _searchText = "";

  Map<String, bool> get categoryFilterStates => _categoryFilterStates;
  String get searchText => _searchText;

  FilterOptions(Set<String> categories) {
    for (var cat in categories) {
      _categoryFilterStates[cat] = true;
    }

    _searchText = "";
  }

  FilterOptions.fromSettings(
      Map<String, bool> categoryFilterStates, String searchText) {
    _categoryFilterStates = categoryFilterStates;
    _searchText = searchText;
  }

  bool isAnyFilterActive() {
    return searchText.isNotEmpty ||
        categoryFilterStates.entries.any((entry) => !entry.value);
  }

  FilterOptions reset() {
    _categoryFilterStates.forEach((key, value) {
      _categoryFilterStates[key] = true;
    });

    _searchText = "";

    return FilterOptions.fromSettings(categoryFilterStates, searchText);
  }
}
