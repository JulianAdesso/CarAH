class Article{
  String  uuid;
  String title;
  String content;
  String category;
  bool downloaded = false;
  bool saved = false;

  Article({required this.uuid, required this.title, required this.content, required this.category});

  Article.fromJson(Map<String, dynamic> json)
      : uuid = json['uuid'],
        title = json['fields']['Display_Name'],
        content = json['fields']['Html_Text'],
        category = json['parentNode']['displayName'];
}