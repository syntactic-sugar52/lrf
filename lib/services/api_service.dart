// auto complete query for map search bar
import 'dart:convert';

import 'package:lrf/constants/constants.dart';
import 'package:http/http.dart' as http;

Future autoCompleteSuggestions(String query) async {
  final response = await getFromUrl(Uri.parse('https://photon.komoot.io/api/?q=$query'));
  if (kLogSearchResultApi) {
    print('------LOGS------');
    print('Search bar results:');
    print(response.body.toString());
  }

  Map<String, dynamic>? autoCompleteJson = Map<String, dynamic>.from(jsonDecode(response.body));
  return autoCompleteJson;
}

Future getFromUrl(Uri url) async {
  final response = await http.get(url);

  if (response.statusCode == 200) {
    return response;
  } else {
    print('getUrl Error');
  }
}
