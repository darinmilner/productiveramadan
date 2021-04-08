import 'package:admob_flutter/admob_flutter.dart';
import 'package:flutter/material.dart';
import 'package:hijri/hijri_calendar.dart';

import 'package:productive_ramadan_app/controllers/hadith_service.dart';
import 'package:productive_ramadan_app/models/api_response.dart';
import 'package:productive_ramadan_app/models/hadith_model.dart';
import 'package:productive_ramadan_app/screens/one_hadith_view.dart';
import 'package:productive_ramadan_app/utils/appbar.dart';
import 'package:productive_ramadan_app/utils/buttons/button.dart';
import 'package:productive_ramadan_app/utils/constants.dart';

import 'package:productive_ramadan_app/utils/side_drawer.dart';

import '../admob_service.dart';

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
  final ams = AdMobService();
  @override
  void initState() {
    super.initState();
    HijriCalendar _today = HijriCalendar.now();
    Admob.initialize();
    var hijiriDay = _today.hDay;
    dayNumber = hijiriDay;
    print("Hadith daynmber $dayNumber");
  }

  getOneHadith(int day) async {
    _apiResponse = await _service.getOneHadith(day);
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
      backgroundColor: Colors.teal[300],
      appBar: _appBar.buildAppBar(context),
      drawer: SideDrawer(),
      bottomSheet: AdmobBanner(
          adUnitId: ams.getBannerAdId(), adSize: AdmobBannerSize.FULL_BANNER),
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
                                  dayNumber == 29 || dayNumber == 30
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
                            child: Padding(
                              padding: const EdgeInsets.all(15.0),
                              child: Column(
                                children: [
                                  Divider(
                                    height: 10.0,
                                  ),
                                  Text(
                                    "${_apiResponse.data[index].day}",
                                    style: kHadithAyahTextStyle,
                                  ),
                                  Divider(
                                    height: 10.0,
                                  ),
                                  Text(
                                    "${_apiResponse.data[index].text}",
                                    style: kHadithAyahTextStyle,
                                  ),
                                  Divider(
                                    height: 10.0,
                                  ),
                                ],
                              ),
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
