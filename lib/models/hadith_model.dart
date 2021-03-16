class Hadith {
  String id;
  String text;
  int day;
  List<Hadith> hadiths;

  Hadith({this.id, this.text, this.day});

  factory Hadith.fromJson(Map<String, dynamic> json) {
    return Hadith(
      text: json['Text'],
      day: json["Day"],
    );
  }
}
