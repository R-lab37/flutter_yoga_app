import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'category.dart';
import 'pose.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Yoga Poses',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: YogaCategoriesPage(),
    );
  }
}

class YogaCategoriesPage extends StatefulWidget {
  const YogaCategoriesPage({super.key});

  @override
  _YogaCategoriesPageState createState() => _YogaCategoriesPageState();
}

class _YogaCategoriesPageState extends State<YogaCategoriesPage> {
  late Future<List<Category>> futureCategories;

  @override
  void initState() {
    super.initState();
    futureCategories = fetchCategories();
  }

  Future<List<Category>> fetchCategories() async {
    final response = await http
        .get(Uri.parse('https://yoga-api-nzy4.onrender.com/v1/categories'));

    if (response.statusCode == 200) {
      List jsonResponse = json.decode(response.body);
      return jsonResponse
          .map((category) => Category.fromJson(category))
          .toList();
    } else {
      throw Exception('Failed to load categories');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Yoga Categories'),
      ),
      body: FutureBuilder<List<Category>>(
        future: futureCategories,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                return YogaCategoryCard(category: snapshot.data![index]);
              },
            );
          } else if (snapshot.hasError) {
            return Center(child: Text("${snapshot.error}"));
          }

          return Center(child: CircularProgressIndicator());
        },
      ),
    );
  }
}

class YogaCategoryCard extends StatelessWidget {
  final Category category;

  YogaCategoryCard({required this.category});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.all(10.0),
      child: Padding(
        padding: EdgeInsets.all(10.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              category.categoryName,
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            Text(category.categoryDescription),
            SizedBox(height: 10),
            ListView.builder(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemCount: category.poses.length,
              itemBuilder: (context, index) {
                return YogaPoseCard(pose: category.poses[index]);
              },
            ),
          ],
        ),
      ),
    );
  }
}

class YogaPoseCard extends StatelessWidget {
  final Pose pose;

  YogaPoseCard({required this.pose});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(vertical: 5.0),
      child: Padding(
        padding: EdgeInsets.all(10.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
                color: Colors.amber[50], child: Image.network(pose.urlPng)),
            const SizedBox(height: 10),
            Text(
              pose.englishName,
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            Text(pose.sanskritName,
                style: TextStyle(fontSize: 18, fontStyle: FontStyle.italic)),
            const SizedBox(height: 10),
            Text(pose.translationName),
            const SizedBox(height: 10),
            Text(
              "Description: ${pose.poseDescription}",
            ),
            const SizedBox(height: 10),
            Text("Benefits: ${pose.poseBenefits}"),
          ],
        ),
      ),
    );
  }
}
