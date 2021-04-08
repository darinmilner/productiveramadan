import 'package:admob_flutter/admob_flutter.dart';
import 'package:flutter/material.dart';
import 'package:hijri/hijri_calendar.dart';

import 'package:productive_ramadan_app/controllers/hadith_service.dart';

import 'package:productive_ramadan_app/models/api_response.dart';
import 'package:productive_ramadan_app/models/hadith_model.dart';
import 'package:productive_ramadan_app/utils/appbar.dart';
import 'package:productive_ramadan_app/utils/constants.dart';
import 'package:productive_ramadan_app/utils/hadith_ayah_card.dart';
import 'package:productive_ramadan_app/utils/side_drawer.dart';

import '../admob_service.dart';
import '../utils/buttons/button.dart';

class OneHadithView extends StatefulWidget {
  int dayNumber;
  static const String routeName = "/onehadith";

  OneHadithView({this.dayNumber = 1});
  @override
  _OneHadithViewState createState() => _OneHadithViewState();
}

class _OneHadithViewState extends State<OneHadithView> {
  Button button = Button();
  MyAppBar _appBar = MyAppBar();
  String text;
  bool isLoading = false;

  HadithService _service = HadithService();
  HijriCalendar _today = HijriCalendar.now();
  final ams = AdMobService();

  initState() {
    Admob.initialize();
    super.initState();
    var hijiriDay = _today.hDay;
    widget.dayNumber = hijiriDay;
    print("hadith daynmber ${widget.dayNumber}");
  }

  APIResponse<List<Hadith>> _apiResponse = APIResponse();

  getOneHadith(int day) async {
    isLoading = true;
    _apiResponse = await _service.getOneHadith(day);
    print("Api response " + _apiResponse.data[0].text);
    text = _apiResponse.data[0].text;
    isLoading = false;
    setState(() {
      print("Day number " + widget.dayNumber.toString());
    });
  }

  @override
  Widget build(BuildContext context) {
    isLoading = false;
    return Scaffold(
      appBar: _appBar.buildAppBar(context),
      drawer: SideDrawer(),
      bottomNavigationBar: Container(
        height: 50,
        child: AdmobBanner(
          adUnitId: ams.getBannerAdId(),
          adSize: AdmobBannerSize.FULL_BANNER,
        ),
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: kBackgroundGreenGradient,
        ),
        child: Center(
          child: Column(
            children: [
              Divider(
                height: 30.0,
              ),
              button.buildButton(
                kDarkTeal,
                Colors.yellow,
                "Get Hadith ${widget.dayNumber}",
                () {
                  setState(() {
                    getOneHadith(widget.dayNumber);
                  });
                },
              ),
              Divider(
                height: 30.0,
              ),
              _apiResponse.data == null
                  ? Text(
                      "CLICK FOR TODAY'S HADITH",
                      style: kLandingPageTextStyle,
                    )
                  : HadithAyahCard(
                      text: text,
                      dayNumber: widget.dayNumber,
                      ayahHadithText: "Hadith",
                    ),
              widget.dayNumber == 16 ||
                      widget.dayNumber == 17 ||
                      widget.dayNumber == 18
                  ? Padding(
                      padding: const EdgeInsets.all(15.0),
                      child: Text(
                        "Last Ten nights of Ramadan are approaching.  Time to step up our ibadah and finish strong inshallah for more rewards from Allah. \nStep up Ibadah to prepare for the last 10 nights",
                        style: TextStyle(
                          fontSize: 15.0,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    )
                  : Container(),
            ],
          ),
        ),
      ),
    );
  }
}
