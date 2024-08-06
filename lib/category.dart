import 'pose.dart';

class Category {
  final int id;
  final String categoryName;
  final String categoryDescription;
  final List<Pose> poses;

  Category({
    required this.id,
    required this.categoryName,
    required this.categoryDescription,
    required this.poses,
  });

  factory Category.fromJson(Map<String, dynamic> json) {
    var posesJson = json['poses'] as List;
    List<Pose> posesList = posesJson.map((i) => Pose.fromJson(i)).toList();

    return Category(
      id: json['id'],
      categoryName: json['category_name'],
      categoryDescription: json['category_description'],
      poses: posesList,
    );
  }
}
