import 'package:flutter/cupertino.dart';

class WidgetVisibility with ChangeNotifier {
  bool _showSearch = false;
  bool _showSuggestedTags = false;
  bool _expandFavouriteTags = false;

  bool get showSearch => _showSearch;
  bool get showSuggestedTags => _showSuggestedTags;
  bool get expandFavouriteTags => _expandFavouriteTags;

  void toggleSearch() {
    _showSearch = !_showSearch;
    notifyListeners();
  }

  void enableSuggestedTags() {
    _showSuggestedTags = true;
    notifyListeners();
  }

  void disableSuggestedTags() {
    _showSuggestedTags = false;
    notifyListeners();
  }

  void toggleFavouriteTags() {
    _expandFavouriteTags = !_expandFavouriteTags;
    notifyListeners();
  }
}
