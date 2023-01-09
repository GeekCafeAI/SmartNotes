import 'dart:convert';

import 'package:http/http.dart' as http;

import '../models/task_model.dart';

Future<Task> createEntry(String text, String userId) async {
  final body = jsonEncode({"text": text, "user_id": userId});
  Map<String, String> headers = {'Content-Type': 'application/json'};

  var response = await http.post(
    Uri.parse('http://10.0.2.2:5000/notes'),
    headers: headers,
    body: body,
  );
  if (response.statusCode == 200) {
    final item = json.decode(response.body);
    var result = Task.fromJson(item);
    return result;
  } else {
    throw Exception("Something went wrong during Post request");
  }
}
