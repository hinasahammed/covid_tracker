import 'dart:convert';

import 'package:covid_app/model/world_states_model.dart';
import 'package:covid_app/services/utilities/api_url.dart';
import 'package:http/http.dart' as http;

class StateServices {
  Future<WorldStatesModel> fetchWorldStatesRecord() async {
    final response = await http.get(Uri.parse(ApiUrl.worldStatesApi));

    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      return WorldStatesModel.fromJson(data);
    } else {
      throw Exception('Error');
    }
  }

  Future<List<dynamic>> fetchCountriesRecord() async {
    var data;
    final response = await http.get(Uri.parse(ApiUrl.countriesList));

    if (response.statusCode == 200) {
       data = jsonDecode(response.body);
      return data;
    } else {
      throw Exception('Error');
    }
  }
}
