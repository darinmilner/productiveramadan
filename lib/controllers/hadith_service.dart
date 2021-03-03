import 'dart:convert';

import 'package:productive_ramadan_app/models/api_response.dart';
import 'package:productive_ramadan_app/models/hadith_model.dart';
import 'package:http/http.dart' as http;

class HadithService {
  static const URL = "http://10.0.2.2:8000";
  static const headers = {"content-type": "application/json"};
  Future<APIResponse<List<Hadith>>> getHadithsList() async {
    return http
        .get(
      URL + "/hadiths",
      headers: headers,
    )
        .then((data) {
      if (data.statusCode == 200) {
        final jsonData = json.decode(data.body);
        print(jsonData);
        final hadiths = <Hadith>[];

        for (var item in jsonData) {
          print("Item in jsonData ${item}");
          final hadith = Hadith(
            text: item["Text"],
            day: item["Day"],
          );
          hadiths.add(hadith);
        }
        return APIResponse<List<Hadith>>(data: hadiths);
      }
      return APIResponse<List<Hadith>>(
          error: true, errorMessage: "Error occured ");
    }).catchError(
      (err) {
        print(err);
        return APIResponse<List<Hadith>>(
            error: true, errorMessage: "Error occured ");
      },
    );
  }
}
