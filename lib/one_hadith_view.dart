import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:productive_ramadan_app/controllers/hadith_service.dart';
import 'package:productive_ramadan_app/landing.dart';
import 'package:productive_ramadan_app/models/api_response.dart';
import 'package:productive_ramadan_app/models/hadith_model.dart';
import 'package:productive_ramadan_app/repositories/sharedpreferences.dart';
import 'package:productive_ramadan_app/utils/appbar.dart';
import 'package:productive_ramadan_app/utils/constants.dart';
import 'package:productive_ramadan_app/utils/hadith_ayah_card.dart';
import 'package:productive_ramadan_app/utils/side_drawer.dart';

import 'utils/buttons/button.dart';

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

  HadithService _service = HadithService();

  initState() {
    super.initState();
    widget.dayNumber = SharedPrefs.getHadithDay();
  }

  APIResponse<List<Hadith>> _apiResponse = APIResponse();

  getOneHadith(int day) async {
    _apiResponse = await _service.getOneHadith(day);
    print("Api response " + _apiResponse.data[0].text);
    text = _apiResponse.data[0].text;

    widget.dayNumber++;
    print("Hadih A day number ${widget.dayNumber}");
    SharedPrefs.setHadithDay(widget.dayNumber);
    setState(() {
      print("Day number " + widget.dayNumber.toString());
    });
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
                      ayahHadithText: "Hadith",
                      dayNumber: widget.dayNumber - 1,
                    ),
            ],
          ),
        ),
      ),
    );
  }
}
