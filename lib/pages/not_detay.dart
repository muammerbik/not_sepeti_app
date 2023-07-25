import 'package:flutter/material.dart';
import 'package:flutter_not_sepeti_app/model/kategori.dart';
import 'package:flutter_not_sepeti_app/model/notlar.dart';
import 'package:flutter_not_sepeti_app/until/database_helper.dart';

class NotDetay extends StatefulWidget {
  String? baslik;
  Not? duzenlenecekNot;
  NotDetay({this.baslik, this.duzenlenecekNot});

  @override
  State<NotDetay> createState() => _NotDetayState();
}

class _NotDetayState extends State<NotDetay> {
  var formKey = GlobalKey<FormState>();
  late DatabaseHelper databaseHelper;
  late List<Kategori> tumKategoriler;
  int? kategoriID;
  int? secilenOncelik;
  late String notBaslik, notIcerik;
  static var _oncelik = ["Düşük", "Orta", "Yüksek"];
  @override
  void initState() {
    super.initState();
    tumKategoriler = <Kategori>[];
    databaseHelper = DatabaseHelper();

    databaseHelper.kategorileriGetir().then((kategoriIcereMapList) {
      for (var map in kategoriIcereMapList) {
        tumKategoriler.add(Kategori.fromMap(map));
      }

      if (widget.duzenlenecekNot != null) {
        kategoriID = widget.duzenlenecekNot!.kategoriID;
        secilenOncelik = widget.duzenlenecekNot!.notOncelik;
      } else {
        int kategoriID = 1;
        int secilenOncelik = 0;
      }
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: Text(widget.baslik!),
        actions: <Widget>[],
      ),
      body: tumKategoriler.length <= 0
          ? const Center(child: CircularProgressIndicator())
          : Container(
              child: Form(
                key: formKey,
                child: Column(
                  children: [
                    Row(
                      children: [
                        const Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Text(
                            'Kategori :',
                            style: TextStyle(
                                fontSize: 20, fontWeight: FontWeight.w500),
                          ),
                        ),
                        Container(
                          child: DropdownButton<int>(
                            items: ItemleriIcerenMapListesi(),
                            value: kategoriID,
                            onChanged: (yeniDeger) {
                              setState(() {
                                kategoriID = yeniDeger;
                              });
                            },
                          ),
                          padding:
                              const EdgeInsets.symmetric(vertical: 3, horizontal: 10),
                          margin:
                              const EdgeInsets.symmetric(vertical: 10, horizontal: 5),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(
                              color: Colors.purple,
                              width: 1,
                            ),
                          ),
                        ),
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(color: Colors.purple, width: 1)),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: 5, horizontal: 10),
                          child: TextFormField(
                            initialValue: widget.duzenlenecekNot != null
                                ? widget.duzenlenecekNot!.notBaslik
                                : "",
                            onSaved: (yeniDeger) {
                              notBaslik = yeniDeger!;
                            },
                            decoration: const InputDecoration(
                                labelText: "Başlık",
                                hintText: "Başlık ekle",
                                border: InputBorder.none),
                            validator: (yeniDeger) {
                              if (yeniDeger!.length < 3) {
                                return "En az 3 karakter giriniz!";
                              }
                            },
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(color: Colors.purple, width: 1)),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: 5, horizontal: 10),
                          child: TextFormField(
                              initialValue: widget.duzenlenecekNot != null
                                  ? widget.duzenlenecekNot!.notIcerik
                                  : "",
                              onSaved: (yeniDeger) {
                                notIcerik = yeniDeger!;
                              },
                              maxLines: 4,
                              decoration: const InputDecoration(
                                  labelText: "İcerik",
                                  hintText: "İçerik ekle",
                                  border: InputBorder.none)),
                        ),
                      ),
                    ),
                    Row(
                      children: [
                        const Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Text(
                            'Öncelik :',
                            style: TextStyle(
                                fontSize: 20, fontWeight: FontWeight.w500),
                          ),
                        ),
                        Container(
                          child: DropdownButton<int>(
                            items: _oncelik
                                .map((oncelik) => DropdownMenuItem<int>(
                                      child: Text(oncelik),
                                      value: _oncelik.indexOf(oncelik),
                                    ))
                                .toList(),
                            value: secilenOncelik,
                            onChanged: (yeniDeger) {
                              setState(() {
                                secilenOncelik = yeniDeger;
                              });
                            },
                          ),
                          padding:
                              const EdgeInsets.symmetric(vertical: 3, horizontal: 15),
                          margin:
                              const EdgeInsets.symmetric(vertical: 10, horizontal: 5),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(
                              color: Colors.purple,
                              width: 1,
                            ),
                          ),
                        ),
                      ],
                    ),
                    ButtonBar(
                      alignment: MainAxisAlignment.center,
                      children: [
                        ElevatedButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                            child: const Text('Vazgeç')),
                        const SizedBox(
                          width: 5,
                        ),
                        ElevatedButton(
                          onPressed: () {
                            if (formKey.currentState!.validate()) {
                              formKey.currentState!.save();
                              var suan = DateTime.now();
                              if (widget.duzenlenecekNot == null) {
                                databaseHelper
                                    .notEkle(Not(
                                        kategoriID,
                                        notBaslik,
                                        notIcerik,
                                        suan.toString(),
                                        secilenOncelik))
                                    .then((kaydedilenNotID) {
                                  if (kaydedilenNotID != 0) {
                                    
                                    Navigator.of(context).pop();
                                      setState(() {
                                      
                                    });
                                 
                                  }
                                });
                              }else{databaseHelper
                                    .notGuncelle(Not.WithID(
                                        widget.duzenlenecekNot!.notID, 
                                        kategoriID,
                                        notBaslik,
                                        notIcerik,
                                        suan.toString(),
                                        secilenOncelik))
                                    .then((guncellenenID) {
                                  if (guncellenenID != 0) {
                                
                                    Navigator.of(context).pop();
                                     setState(() {
                                      
                                    });
                                   
                                  }
                                });}
                            }
                          },
                          child: const Text('Kaydet'),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
    );
  }

  List<DropdownMenuItem<int>> ItemleriIcerenMapListesi() {
    return tumKategoriler
        .map((gelenKategori) => DropdownMenuItem<int>(
              child: Text(
                gelenKategori.kategoriBaslik!,
                style: const TextStyle(fontSize: 21),
              ),
              value: gelenKategori.kategoriID,
            ))
        .toList();
  }
}
