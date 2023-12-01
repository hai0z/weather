import 'dart:convert';

import 'package:http/http.dart' as http;

class SearchRespone {
  int? id;
  String? name;
  String? region;
  String? country;
  double? lat;
  double? lon;
  String? url;

  SearchRespone(
      {this.id,
      this.name,
      this.region,
      this.country,
      this.lat,
      this.lon,
      this.url});

  SearchRespone.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    region = json['region'];
    country = json['country'];
    lat = json['lat'];
    lon = json['lon'];
    url = json['url'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['region'] = region;
    data['country'] = country;
    data['lat'] = lat;
    data['lon'] = lon;
    data['url'] = url;
    return data;
  }
}

Future<List<SearchRespone>> fetchSearch(String searchInput) async {
  String apiKey = 'df2632b36ad64126ac685509230509';
  String apiUrl =
      'http://api.weatherapi.com/v1/search.json?key=$apiKey&q=$searchInput';
  final response = await http.get(Uri.parse(apiUrl));

  if (response.statusCode == 200) {
    final List<dynamic> responseData = json.decode(response.body);
    return responseData.map((data) => SearchRespone.fromJson(data)).toList();
  } else {
    throw Exception('Failed to search');
  }
}
