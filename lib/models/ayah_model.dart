class Ayah {
  String id;
  String text;
  int day;
  List<Ayah> ayahs;

  Ayah({this.id, this.text, this.day});

  factory Ayah.fromJson(Map<String, dynamic> json) {
    return Ayah(
      text: json['Text'],
      day: json["Day"],
    );
  }
}
