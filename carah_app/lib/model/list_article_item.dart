class ListArticlesItem {
  String articleId;
  String title;
  bool saved;
  bool downloaded;

  ListArticlesItem({required this.articleId, required this.title, this.saved = false, this.downloaded = false});

  ListArticlesItem.fromJson(Map<String, dynamic> json)
      : articleId = json['uuid'],
        title = json['fields']['Display_Name'],
        saved = false,
        downloaded = false;
}
