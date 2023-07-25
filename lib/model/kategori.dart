class Kategori {
  int? kategoriID;
  String? kategoriBaslik;

  Kategori(
   this. kategoriBaslik, //kategori eklemek için kullanılır,kategoriID degeri otomatik verilir.
  );

  Kategori.WithID(
     //kategori okumak için kullanılır.
   this. kategoriID,
  this. kategoriBaslik,
  );

  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{};
    map["kategoriID"] = kategoriID;
    map["kategoriBaslik"] = kategoriBaslik;
    return map;
  }

  Kategori.fromMap(Map<String, dynamic> map) {
    this.kategoriID = map["kategoriID"];
    this.kategoriBaslik = map["kategoriBaslik"];
  }

  @override
  String toString() =>
      'Kategori(kategoriID: $kategoriID, kategoriBaslik: $kategoriBaslik)';
}
