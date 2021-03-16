import 'package:flutter/material.dart';
import 'package:productive_ramadan_app/controllers/ayah_service.dart';

import 'package:productive_ramadan_app/models/api_response.dart';
import 'package:productive_ramadan_app/models/hadith_model.dart';
import 'package:productive_ramadan_app/one_ayah_view.dart';
import 'package:productive_ramadan_app/repositories/sharedpreferences.dart';
import 'package:productive_ramadan_app/utils/buttons/button.dart';
import 'package:productive_ramadan_app/utils/constants.dart';

import 'package:productive_ramadan_app/utils/side_drawer.dart';

import 'models/ayah_model.dart';

class AyahADay extends StatefulWidget {
  static const String routeName = "/ayahs";
  @override
  _AyahADayState createState() => _AyahADayState();
}

class _AyahADayState extends State<AyahADay> {
  int dayNumber = 1;

  Button button = Button();

  AyahService _service = AyahService();

  APIResponse<List<Ayah>> _apiResponse = APIResponse();

  bool _isLoading = false;
  var res;
  List<Ayah> ayahs = [];

  initState() {
    super.initState();
    dayNumber = SharedPrefs.getAyahDay();
  }

  getOneAyah(int day) async {
    _apiResponse = await _service.getAyahsList();
    print("Ayah a day " + _apiResponse.data[day - 1].text);

    dayNumber++;
    print("Day number " + dayNumber.toString());
    SharedPrefs.setHadithDay(dayNumber);
    if (dayNumber >= _apiResponse.data.length) {
      dayNumber = _apiResponse.data.length;
    }
  }

  getAyahs() async {
    setState(() {
      _isLoading = true;
    });

    _apiResponse = await _service.getAyahsList();

    print(_apiResponse.data[0].text);

    for (int i = 0; i < _apiResponse.data.length; i++) {
      print(_apiResponse.data[i].text);
    }

    print("Day Number " + _apiResponse.data[dayNumber].text);

    print("Ayah length " + ayahs.length.toString());
    setState(() {
      _isLoading = false;
    });
    print("Ayah Button: day # ${dayNumber}");

    //return await hadiths;

    dayNumber++;
    if (dayNumber >= _apiResponse.data.length) {
      dayNumber = _apiResponse.data.length;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(
          child: Text(
            "Productive Ramadan",
            style: kLandingPageTextStyle,
          ),
        ),
      ),
      drawer: SideDrawer(),
      body: _apiResponse.data == null
          ? Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Center(
                    child: Column(
                      children: [
                        Divider(
                          height: 30,
                        ),
                        Text(
                          "الله",
                          style: TextStyle(
                            fontSize: 50.0,
                            color: Colors.white70,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                        Text(
                          "محمد",
                          style: TextStyle(
                            fontSize: 50.0,
                            color: Colors.white70,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                        Divider(
                          height: MediaQuery.of(context).size.height * 0.12,
                        ),
                        Expanded(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                children: [
                                  button.buildButton(
                                    kDarkTeal,
                                    Colors.yellow,
                                    "Get All 30 Ayahs",
                                    getAyahs,
                                  ),
                                  button.buildButton(
                                    kDarkTeal,
                                    Colors.yellow,
                                    "Get Ayah ${dayNumber}",
                                    () {
                                      setState(() {
                                        Navigator.of(context).pushNamed(
                                            OneAyahView.routeName,
                                            arguments: {
                                              dayNumber: dayNumber,
                                            });
                                      });
                                    },
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  Divider(
                    height: 40,
                  ),
                ],
              ),
            )
          : Builder(
              builder: (_) {
                if (_isLoading) {
                  return CircularProgressIndicator();
                }

                if (_apiResponse.error) {
                  return Center(
                    child: Text(
                      _apiResponse.errorMessage,
                    ),
                  );
                }
                return ListView.separated(
                  separatorBuilder: (_, _1) =>
                      Divider(height: 1, color: kGreenishTeal),
                  itemBuilder: (_, index) {
                    return Center(
                      child: Column(
                        children: [
                          // button.buildButton(
                          //   kDarkTeal,
                          //   Colors.yellow,
                          //   "Get Ayah ${dayNumber}",
                          //   getAyahs,
                          // ),
                          Divider(
                            height: 10.0,
                          ),
                          // _isLoading
                          //     ? CircularProgressIndicator()
                          //     :

                          Text("${_apiResponse.data[index].day}"),
                          // Text(
                          //   "Hadith ${hadiths[dayNumber]}",
                          //   style: kLandingPageTextStyle,
                          // ),
                          Divider(
                            height: 10.0,
                          ),

                          Text("${_apiResponse.data[index].text}"),
                          // Text(
                          //   "${hadiths[dayNumber]}",
                          //   style: kLandingPageTextStyle,
                          // ),
                          Divider(
                            height: 10.0,
                          ),
                        ],
                      ),
                    );
                  },
                  itemCount: _apiResponse.data.length == null
                      ? 0
                      : _apiResponse.data.length,
                );
              },
            ),
    );
  }
}
// Text(
//   "Back To Home",
//   style: kLandingPageTextStyle,
// ),
// button.buildButton(
//   kDarkTeal,
//   Colors.yellow,
//   "Go Back",
//   () {
//     Navigator.pop(context);
//   },
// ),
