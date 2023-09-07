import 'package:flutter/material.dart';

class Tags {
  final String tagId;
  final String tagName;
  final DateTime timestamps;
  final Color? color;
  final double lat;
  final double long;

  Tags(
      {required this.tagId,
      required this.tagName,
      required this.timestamps,
      this.color = Colors.orange,
      required this.lat,
      required this.long});

  static Tags fromJson(Map<dynamic, dynamic> json, String key) => Tags(
      tagId: key,
      tagName: json['tag_name'],
      timestamps: DateTime.parse(json['timestamp']),
      lat: json['location']['lat'],
      long: json['location']['long']);
}
