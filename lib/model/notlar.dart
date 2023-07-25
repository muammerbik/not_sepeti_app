// ignore_for_file: public_member_api_docs, sort_constructors_first
class Not {
  int? notID;
  int? kategoriID;
  String? kategoriBaslik;
  String? notBaslik;
  String? notIcerik;
  String? notTarih;
  int? notOncelik;
  Not(
    this.kategoriID,
    this.notBaslik,
    this.notIcerik,
    this.notTarih,
    this.notOncelik,
  );
  Not.WithID(
    this.notID,
    this.kategoriID,
    this.notBaslik,
    this.notIcerik,
    this.notTarih,
    this.notOncelik,
  );

  Map<String, dynamic> toMap() {
    var map = Map<String, dynamic>();
    map["notID"] = notID;
    map["kategoriID"] = kategoriID;
    map["notBaslik"] = notBaslik;
    map["notIcerik"] = notIcerik;
    map["notTarih"] = notTarih;
    map["notOncelik"] = notOncelik;
    return map;
  }

  Not.fromMap(Map<String, dynamic> map) {
    notID = map["notID"];
    kategoriID = map["kategoriID"];
    kategoriBaslik = map["kategoriBaslik"];
    notBaslik = map["notBaslik"];
    notIcerik = map["notIcerik"];
    notTarih = map["notTarih"];
    notOncelik = map["notOncelik"];
  }

  @override
  String toString() {
    return 'Not(notID: $notID, kategoriID: $kategoriID, notBaslik: $notBaslik, notIcerik: $notIcerik, notTarih: $notTarih, notOncelik: $notOncelik)';
  }
}
