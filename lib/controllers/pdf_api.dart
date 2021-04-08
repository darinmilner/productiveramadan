import 'dart:io';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart';

import 'package:productive_ramadan_app/models/daily_tasks_model.dart';

class PdfApi {
  static Future<File> generateCenteredText(String text) async {
    final pdf = Document();

    pdf.addPage(
      Page(
        build: (context) => Center(
          child: Text(
            text,
            style: TextStyle(fontSize: 40.0),
          ),
        ),
      ),
    );

    return saveDocument(name: "dailytasks.pdf", pdf: pdf);
  }

  static Future<File> generatePdf(List<DailyTaskModel> tasks) async {
    final pdf = Document();
    pdf.addPage(
      MultiPage(
        build: (context) => <Widget>[
          Header(
            child: Text(
              "Productive Ramadan -- Ramadan 2021 -- AH 1442",
              style: TextStyle(
                fontSize: 21,
                color: PdfColors.teal600,
              ),

             
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              SizedBox(width: 4.0 * PdfPageFormat.cm),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 10.0),
              ),
              Text(
                "What did you accomplish today?\n",
                style: TextStyle(
                  fontSize: 24,
                  color: PdfColors.black,
                ),
              ),
              ...buildBulletPoints(),
              SizedBox(width: 10.0 * PdfPageFormat.cm),
              Text(
                "Daily Goals\n",
                style: TextStyle(
                  fontSize: 24,
                  color: PdfColors.black,
                ),
              ),
              for (int i = 0; i < tasks.length; i++)
                Bullet(
                  text: tasks[i].correctTaskAnswer,
                  textAlign: TextAlign.left,
                  style: TextStyle(
                    fontSize: 20,
                    color: PdfColors.black,
                  ),
                ),
              SizedBox(width: 10.0 * PdfPageFormat.cm),
              Text(
                "Daily Goal Performance\n",
                style: TextStyle(
                  fontSize: 24,
                  color: PdfColors.black,
                ),
              ),
              SizedBox(width: 10.0 * PdfPageFormat.cm),
              Bullet(
                text:
                    "Number of rakaats of sunnah and tarawih performed today?\n",
                textAlign: TextAlign.left,
                style: TextStyle(
                  fontSize: 20,
                  color: PdfColors.black,
                ),
              ),
              SizedBox(width: 10.0 * PdfPageFormat.cm),
              Bullet(
                text: "How many minutes did you read Quran today?\n",
                textAlign: TextAlign.left,
                style: TextStyle(
                  fontSize: 20,
                  color: PdfColors.black,
                ),
              ),
              SizedBox(width: 10.0 * PdfPageFormat.cm),
              Bullet(
                text:
                    "Did you fast today?  \nOr have an excuse?  \nAny missed days to make up?\n",
                textAlign: TextAlign.left,
                style: TextStyle(
                  fontSize: 20,
                  color: PdfColors.black,
                ),
              ),
              SizedBox(width: 10.0 * PdfPageFormat.cm),
              Bullet(
                text: "Extra good deeds done today?\n",
                textAlign: TextAlign.left,
                style: TextStyle(
                  fontSize: 20,
                  color: PdfColors.black,
                ),
              ),
            ],
          ),
        ],
      ),
    );

    return saveDocument(name: "dailytasks.pdf", pdf: pdf);
  }

  static List<Widget> buildBulletPoints() {
    return [
      Center(
        child: Bullet(
          text: "Daily Salat and Tarawih\n",
          style: TextStyle(
            fontSize: 20,
            color: PdfColors.black,
          ),
        ),
      ),
      Center(
        child: Bullet(
          text: "Quran Reading\n",
          style: TextStyle(
            fontSize: 20,
            color: PdfColors.black,
          ),
        ),
      ),
      Center(
        child: Bullet(
          text: "Daily Fast\n",
          style: TextStyle(
            fontSize: 20,
            color: PdfColors.black,
          ),
        ),
      ),
      Center(
        child: Bullet(
          text: "Extra Ramadan Ibadah\n",
          style: TextStyle(
            fontSize: 20,
            color: PdfColors.black,
          ),
        ),
      ),
    ];
  }

  static Future<File> saveDocument({String name, Document pdf}) async {
    final bytes = await pdf.save();

    final dir = await getApplicationDocumentsDirectory();
    final file = File("${dir.path}/$name");

    await file.writeAsBytes(bytes);
    return file;
  }

  static Future openFile(File file) async {
    final url = file.path;
    await OpenFile.open(url);
  }
}
