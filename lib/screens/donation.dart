import 'package:admob_flutter/admob_flutter.dart';
import 'package:flutter/material.dart';
import 'package:productive_ramadan_app/utils/appbar.dart';
import 'package:productive_ramadan_app/utils/buttons/glowing_button.dart';
import 'package:productive_ramadan_app/utils/buttons/textbutton.dart';
import 'package:productive_ramadan_app/utils/constants.dart';
import 'package:productive_ramadan_app/utils/side_drawer.dart';
import 'package:url_launcher/url_launcher.dart';

import '../admob_service.dart';

class Donation extends StatefulWidget {
  static const route = "/donation";

  @override
  _DonationState createState() => _DonationState();
}

class _DonationState extends State<Donation> {
  String url = "https://www.buymeacoffee.com/darinmilner";

  MyAppBar _appBar = MyAppBar();

  GlowingButton glowingButton = GlowingButton();
  final ams = AdMobService();
  @override
  void initState() {
    Admob.initialize();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _appBar.buildAppBar(context),
      drawer: SideDrawer(),
      bottomSheet: AdmobBanner(
        adUnitId: ams.getBannerAdId(),
        adSize: AdmobBannerSize.FULL_BANNER,
      ),
      body: Container(
        color: kDarkTeal,
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Card(
            color: Colors.teal[200],
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Center(
                    child: Text(
                      "Please make a donation",
                      style: kHadithAyahTextStyle,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Center(
                    child: Text(
                      "Narrated Ibn 'Abbas: Allah's Apostle was the most generous of all the people, and he used to reach the peak in generosity in the month of Ramadan when Gabriel met him. Gabriel used to meet him every night of Ramadan to teach him the Qur'an. Allah's Apostle was the most generous person, even more generous than the strong uncontrollable wind (in readiness and haste to do charitable deeds). (Bukhari, Book #1, Hadith #5)",
                      style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w900,
                          letterSpacing: 1.5),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Center(
                    child: Text(
                      "Donations will go towards app upkeep and making more halal content inshallah.JazakAllahu Khairun",
                      style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w900,
                          letterSpacing: 1.5),
                    ),
                  ),
                ),
                // Center(
                //   child: Text("$url"),
                // ),
                Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: buildTextButton(
                    Colors.amber,
                    Colors.green[800],
                    "Donate Now",
                    true,
                    () async {
                      print("Donation Link");
                      await canLaunch(url)
                          ? await launch(url)
                          : throw 'Could not launch $url';
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
