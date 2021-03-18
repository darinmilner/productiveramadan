import 'package:flutter/material.dart';
import 'package:productive_ramadan_app/controllers/ayah_service.dart';
import 'package:productive_ramadan_app/models/api_response.dart';
import 'package:productive_ramadan_app/repositories/sharedpreferences.dart';
import 'package:productive_ramadan_app/utils/appbar.dart';

import 'package:productive_ramadan_app/utils/constants.dart';
import 'package:productive_ramadan_app/utils/hadith_ayah_card.dart';
import 'package:productive_ramadan_app/utils/side_drawer.dart';

import 'models/ayah_model.dart';
import 'utils/buttons/button.dart';

class OneAyahView extends StatefulWidget {
  int dayNumber;

  static const String routeName = "/oneayah";

  OneAyahView({this.dayNumber = 1});
  @override
  _OneAyahViewState createState() => _OneAyahViewState();
}

class _OneAyahViewState extends State<OneAyahView> {
  Button button = Button();
  String text;
  String ayahText = "Ayah";
  AyahService _service = AyahService();
  MyAppBar _appBar = MyAppBar();

  initState() {
    super.initState();
    widget.dayNumber = SharedPrefs.getAyahDay();
  }

  APIResponse<List<Ayah>> _apiResponse = APIResponse();

  getOneAyah(int day) async {
    _apiResponse = await _service.getOneAyah(day);
    print("Api response " + _apiResponse.data[0].text);
    text = _apiResponse.data[0].text;

    widget.dayNumber++;
    print("Ayah view dayNumber ${widget.dayNumber}");
    SharedPrefs.setAyahDay(widget.dayNumber);
    setState(() {
      print("Day number " + widget.dayNumber.toString());
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _appBar.buildAppBar(context),
      drawer: SideDrawer(),
      body: Center(
        child: Column(
          children: [
            button.buildButton(
              kDarkTeal,
              Colors.yellow,
              "Get Ayah ${widget.dayNumber}",
              () {
                setState(() {
                  getOneAyah(widget.dayNumber);
                });
              },
            ),
            _apiResponse.data == null
                ? Text(
                    "CLICK FOR TODAY'S AYAH",
                    style: kLandingPageTextStyle,
                  )
                : HadithAyahCard(
                    text: text,
                    dayNumber: widget.dayNumber - 1,
                    ayahHadithText: ayahText,
                  ),
          ],
        ),
      ),
    );
  }
}
