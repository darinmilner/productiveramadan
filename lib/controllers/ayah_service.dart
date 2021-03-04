import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:productive_ramadan_app/models/api_response.dart';
import 'package:productive_ramadan_app/models/ayah_model.dart';

class AyahService {
  static const URL = "http://10.0.2.2:8000";
  static const headers = {"content-type": "application/json"};

  Future<APIResponse<List<Ayah>>> getAyahsList() async {
    return http
        .get(
      URL + "/ayahs",
      headers: headers,
    )
        .then((data) {
      if (data.statusCode == 200) {
        final jsonData = json.decode(data.body);
        print(jsonData);
        final ayahs = <Ayah>[];

        for (var item in jsonData) {
          print("Item in jsonData ${item}");
          final ayah = Ayah(
            text: item["Text"],
            day: item["Day"],
          );
          ayahs.add(ayah);
        }
        return APIResponse<List<Ayah>>(data: ayahs);
      }
      return APIResponse<List<Ayah>>(
          error: true, errorMessage: "Error occured ");
    }).catchError(
      (err) {
        print(err);
        return APIResponse<List<Ayah>>(
            error: true, errorMessage: "Error occured ");
      },
    );
  }
}
