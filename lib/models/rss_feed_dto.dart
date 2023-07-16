class RssFeedItem {
  List<String>? categories;
  String title;
  String? description;
  Uri? link;
  DateTime? date;
  bool _selected = true;
  bool get selected => _selected;

  RssFeedItem(
      this.title, this.description, this.link, this.categories, this.date);

  void toggleSelected() {
    _selected = !_selected;
  }
}
