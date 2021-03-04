import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:productive_ramadan_app/controllers/hadith_service.dart';
import 'package:productive_ramadan_app/models/api_response.dart';
import 'package:productive_ramadan_app/models/hadith_model.dart';
import 'package:productive_ramadan_app/utils/buttons/button.dart';
import 'package:productive_ramadan_app/utils/constants.dart';
import 'package:productive_ramadan_app/utils/side_drawer.dart';

class HadithADay extends StatefulWidget {
  static const String routeName = "/hadith";
  @override
  _HadithADayState createState() => _HadithADayState();
}

class _HadithADayState extends State<HadithADay> {
  int dayNumber = 1;

  Button button = Button();

  Hadith _hadith = Hadith();

  HadithService _service = HadithService();

  APIResponse<List<Hadith>> _apiResponse = APIResponse();

  bool _isLoading = false;
  var res;
  List<Hadith> hadiths = [];

  @override
  void initState() {
    // getHadith();
    super.initState();
  }

  // List<Hadith> hadiths = [
  //   Hadith(
  //     id: "1",
  //     day: 1,
  //     text: "Hadith1 الحديث",
  //   ),
  //   Hadith(
  //     id: "2",
  //     day: 2,
  //     text: "Hadith2 الحديث",
  //   ),
  // ];
  getOneHadith(int day) async {
    _apiResponse = await _service.getHadithsList();
    print("Hadith a day " + _apiResponse.data[day - 1].text);
    dayNumber++;
    print("Day number " + dayNumber.toString());
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
    print("Hadith Button: day # ${dayNumber}");

    //return await hadiths;

    //dayNumber++;
    // if (dayNumber >= _apiResponse.data.length) {
    //   dayNumber = _apiResponse.data.length;
    // }
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
                  button.buildButton(
                    kDarkTeal,
                    Colors.yellow,
                    "Get All 30 Hadith",
                    getHadith,
                  ),
                  button.buildButton(
                    kDarkTeal,
                    Colors.yellow,
                    "Get Hadith ${dayNumber}",
                    () {
                      setState(() {
                        getOneHadith(dayNumber);
                      });
                    },
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
                          // Text(
                          //   "Hadith A day Page",
                          //   style: kLandingPageTextStyle,
                          // ),
                          button.buildButton(
                            kDarkTeal,
                            Colors.yellow,
                            "Get Hadith ${dayNumber}",
                            getHadith,
                          ),
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
