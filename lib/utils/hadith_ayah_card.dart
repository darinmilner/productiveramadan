import 'package:flutter/material.dart';

class HadithAyahCard extends StatelessWidget {
  final String text;
  final String ayahHadithText;
  final int dayNumber;

  HadithAyahCard(
      {@required this.text, this.ayahHadithText, @required this.dayNumber});

  @override
  Widget build(BuildContext context) {
    print(text);
    return Expanded(
      child: ListView(
        children: [
          Card(
            shadowColor: Colors.green[600],
            elevation: 8.0,
            clipBehavior: Clip.antiAlias,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20.0),
            ),
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Colors.red[200],
                    Colors.teal[200],
                    Colors.teal[300],
                    Colors.teal[100],
                    Colors.teal[300],
                    Colors.teal[200],
                    Colors.red[200],
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              padding: EdgeInsets.all(10),
              width: MediaQuery.of(context).size.width * 0.9,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Text(
                      "$ayahHadithText number ${dayNumber}",
                      style: TextStyle(
                        fontSize: 28.0,
                        fontWeight: FontWeight.w900,
                        color: Colors.black87,
                        fontFamily: "Syne",
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  Divider(
                    height: 30,
                    color: Colors.teal[600],
                    thickness: 3.0,
                  ),
                  Text(
                    text,
                    style: TextStyle(
                      fontSize: 20.0,
                      fontWeight: FontWeight.w600,
                      color: Colors.black87,
                    ),
                  ),
                  Divider(
                    height: 30,
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
