import 'package:flutter/material.dart';
import 'package:hijri/hijri_calendar.dart';

import 'package:productive_ramadan_app/controllers/hadith_service.dart';
import 'package:productive_ramadan_app/models/api_response.dart';
import 'package:productive_ramadan_app/models/hadith_model.dart';
import 'package:productive_ramadan_app/screens/one_hadith_view.dart';
import 'package:productive_ramadan_app/repositories/sharedpreferences.dart';
import 'package:productive_ramadan_app/utils/appbar.dart';
import 'package:productive_ramadan_app/utils/buttons/button.dart';
import 'package:productive_ramadan_app/utils/constants.dart';

import 'package:productive_ramadan_app/utils/side_drawer.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HadithADay extends StatefulWidget {
  static const String routeName = "/hadith";
  @override
  _HadithADayState createState() => _HadithADayState();
}

class _HadithADayState extends State<HadithADay> {
  int dayNumber = 1;

  Button button = Button();

  HadithService _service = HadithService();

  MyAppBar _appBar = MyAppBar();

  APIResponse<List<Hadith>> _apiResponse = APIResponse();

  bool _isLoading = false;
  var res;
  List<Hadith> hadiths = [];

  @override
  void initState() {
    super.initState();
    HijriCalendar _today = HijriCalendar.now();
    // dayNumber = SharedPrefs.getHadithDay();
    var hijiriDay = _today.hDay;
    dayNumber = hijiriDay;
    print("Hadith daynmber $dayNumber");
  }

  getOneHadith(int day) async {
    _apiResponse = await _service.getOneHadith(day);
    //print(_apiResponse.data[0].text);

    // dayNumber++;
    // SharedPrefs.setHadithDay(dayNumber);
    // setState(() {
    //   print("Day number " + dayNumber.toString());
    // });
  }

  getHadith() async {
    setState(() {
      _isLoading = true;
    });

    _apiResponse = await _service.getHadithsList();

    print(_apiResponse.data[0].text);

    print("Hadith length " + hadiths.length.toString());
    setState(() {
      _isLoading = false;
    });
    setState(() {
      dayNumber++;
    });
    print("Hadith Button: day # ${dayNumber}");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _appBar.buildAppBar(context),
      drawer: SideDrawer(),
      body: Container(
        decoration: BoxDecoration(
          gradient: kBackgroundGreenGradient,
        ),
        child: _apiResponse.data == null
            ? Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Column(
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
                                  dayNumber == 30
                                      ? button.buildButton(
                                          kDarkTeal,
                                          Colors.yellow,
                                          "Get All 30 Hadith",
                                          getHadith,
                                        )
                                      : Container(),
                                  button.buildButton(
                                    kDarkTeal,
                                    Colors.yellow,
                                    "Get Hadith ${dayNumber}",
                                    () {
                                      Navigator.of(context).pushNamed(
                                        OneHadithView.routeName,
                                        arguments: {
                                          dayNumber: dayNumber,
                                        },
                                      );
                                    },
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    Divider(
                      height: 40,
                    ),
                  ],
                ),
              )
            : _apiResponse.error
                ? Center(
                    child: Text(
                      "Check your internet connection",
                    ),
                  )
                : Builder(
                    // body:
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
                                Divider(
                                  height: 10.0,
                                ),
                                Text("${_apiResponse.data[index].day}"),
                                Divider(
                                  height: 10.0,
                                ),
                                Text("${_apiResponse.data[index].text}"),
                                Divider(
                                  height: 10.0,
                                ),
                                button.buildButton(
                                  kDarkTeal,
                                  Colors.yellow,
                                  "Get Hadith ${dayNumber}",
                                  getHadith,
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
      ),
    );
  }
}