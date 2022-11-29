class Category{
  String uuid;
  String name;
  String? description;

  Category({required this.uuid, required this.name, this.description});

  Category.fromJson(Map<String, dynamic> json) :
    uuid = json['uuid'],
    name = json['fields']['Name'],
    description = json['fields']['Description'];

}