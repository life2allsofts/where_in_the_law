import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:where_in_the_law/models/law_model.dart';


class LawData {
  static Future<List<Law>> loadLaws() async {
    final String jsonString =
        await rootBundle.loadString('assets/law_data.json');
    final List<dynamic> jsonList = json.decode(jsonString);
    return jsonList.map((json) => Law.fromJson(json)).toList();
  }
}