import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_not_sepeti_app/model/kategori.dart';
import 'package:flutter_not_sepeti_app/model/notlar.dart';
import 'package:flutter_not_sepeti_app/pages/kategori_detay.dart';
import 'package:flutter_not_sepeti_app/pages/not_detay.dart';
import 'package:flutter_not_sepeti_app/until/database_helper.dart';
import 'package:flutter/services.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    statusBarColor: Colors.transparent, // Status bar'ı şeffaf hale getirir
  ));

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Flutter Not Sepeti",
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
          colorScheme: ColorScheme.fromSwatch(primarySwatch: Colors.purple)
              .copyWith(secondary: Colors.orange)),
      home: NotListesi(),
    );
  }
}

class NotListesi extends StatelessWidget {
  DatabaseHelper databaseHelper = DatabaseHelper();
  NotListesi({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: const Center(
            child: Text(
          'Not Sepeti',
          style: TextStyle(fontSize: 22),
        )),
        actions: <Widget>[
          PopupMenuButton(
            itemBuilder: (context) {
              return [
                PopupMenuItem(
                  child: ListTile(
                    leading: const Icon(
                      Icons.import_contacts,
                      color: Colors.orange,
                    ),
                    title: const Text(
                      "Kategoriler",
                      style: TextStyle(
                          color: Colors.blueGrey, fontWeight: FontWeight.w700),
                    ),
                    onTap: () {
                      Navigator.pop(context);
                      _kategorilerSayfasinaGit(context);
                    },
                  ),
                ),
              ];
            },
          )
        ],
      ),
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton(
            tooltip: "Kategori Ekle",
            heroTag: "Kategori Ekle",
            onPressed: () => kategoriEkleDialog(context),
            child: const Icon(Icons.add_circle),
            mini: true,
          ),
          FloatingActionButton(
              tooltip: "Not Ekle",
              heroTag: "Not Ekle",
              onPressed: () => motDetaySayfasinaGit(context),
              child: const Icon(Icons.add))
        ],
      ),
      body: const Notlar(),
    );
  }

  kategoriEkleDialog(BuildContext context) {
    var formKey = GlobalKey<FormState>();

    String? yeniKategoriAdi;
    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (context) {
          return SimpleDialog(
            title: const Text("Kategori Ekle"),
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Form(
                    key: formKey,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        decoration: BoxDecoration(
                            border: Border.all(color: Colors.purple, width: 1),
                            borderRadius: BorderRadius.circular(8)),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: TextFormField(
                            onSaved: (yeniDeger) {
                              yeniKategoriAdi = yeniDeger!;
                            },
                            autofocus: true,
                            decoration: const InputDecoration(
                                hintText: "Kategori Adı",
                                border: InputBorder.none),
                            validator: (yeniDeger) {
                              if (yeniDeger!.length < 3) {
                                return "En az 3 karakter giriniz! ";
                              }
                              return null;
                            },
                          ),
                        ),
                      ),
                    )),
              ),
              ButtonBar(
                alignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  ElevatedButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: const Text('Vazgeç')),
                  const SizedBox(
                    width: 3,
                  ),
                  ElevatedButton(
                      onPressed: () {
                        if (formKey.currentState!.validate()) {
                          formKey.currentState!.save();
                          databaseHelper
                              .kategoriEkle(Kategori(yeniKategoriAdi))
                              .then((kategoriID) {
                            if (kategoriID > 0) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: const Text('Kategori eklendi'),
                                  action: SnackBarAction(
                                    label: 'Tamam',
                                    onPressed: () {
                                      // Code to execute.
                                    },
                                  ),
                                ),
                              );
                              Navigator.of(context).pop();
                            }
                          });
                        }
                      },
                      child: const Text('Kaydet')),
                ],
              )
            ],
          );
        });
  }

  motDetaySayfasinaGit(BuildContext context) {
    Navigator.of(context).push(MaterialPageRoute(
      builder: (context) => NotDetay(
        baslik: "Yeni Not",
      ),
    ));
  }

  void _kategorilerSayfasinaGit(BuildContext context) {
    Navigator.of(context).push(MaterialPageRoute(
      builder: (context) => const KategoriDetay(),
    ));
  }
}

class Notlar extends StatefulWidget {
  const Notlar({super.key});

  @override
  State<Notlar> createState() => _NotlarState();
}

class _NotlarState extends State<Notlar> {
  late List<Not> tumNotlar;
  late DatabaseHelper databaseHelper;

  @override
  void initState() {
    super.initState();
    List<Not> tumNotlar = <Not>[];
    databaseHelper = DatabaseHelper();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: databaseHelper.notListesiniGetir(),
      builder: (context, AsyncSnapshot<List<Not>> snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          tumNotlar = snapshot.data!;
          sleep(const Duration(milliseconds: 500));
          return tumNotlar.length <= 0
              ? const Center(
                  child: Text(
                  'Lütfen not ekleyin !',
                  style: TextStyle(
                      fontSize: 25,
                      color: Colors.purple,
                      fontWeight: FontWeight.w600),
                ))
              : ListView.builder(
                  itemCount: tumNotlar.length,
                  itemBuilder: (context, index) {
                    return ExpansionTile(
                      leading: OncelikIconuAta(tumNotlar[index].notOncelik!),
                      title: Text(
                        tumNotlar[index].notBaslik!,
                        style: const TextStyle(fontSize: 22),
                      ),
                      children: <Widget>[
                        Container(
                          child: Column(
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  const Padding(
                                    padding: EdgeInsets.all(8.0),
                                    child: Text(
                                      'Kategori',
                                      style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text(
                                      tumNotlar[index].kategoriBaslik!,
                                      style: const TextStyle(fontSize: 20),
                                    ),
                                  )
                                ],
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  const Padding(
                                    padding: EdgeInsets.all(8.0),
                                    child: Text('Oluşturulma Tarihi',
                                        style: TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold)),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text(
                                      databaseHelper.dateFormat(DateTime.parse(
                                          tumNotlar[index].notTarih!)),
                                    ),
                                  )
                                ],
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  const Text('İçerik',
                                      style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold)),
                                  const SizedBox(
                                    height: 5,
                                  ),
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 4, horizontal: 5),
                                    alignment: Alignment.centerLeft,
                                    child: Padding(
                                      padding: const EdgeInsets.all(5.0),
                                      child: Text(tumNotlar[index].notIcerik!,
                                          style: const TextStyle(
                                              fontSize: 18,
                                              fontWeight: FontWeight.w400)),
                                    ),
                                  ),
                                ],
                              ),
                              ButtonBar(
                                alignment: MainAxisAlignment.spaceEvenly,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  ElevatedButton(
                                      onPressed: () =>
                                          _notSil(tumNotlar[index].notID!),
                                      child: const Text('Sil')),
                                  ElevatedButton(
                                      onPressed: () => motDetaySayfasinaGit(
                                          context, tumNotlar[index]),
                                      child: const Text('Güncelle')),
                                ],
                              )
                            ],
                          ),
                        )
                      ],
                    );
                  },
                );
        } else {
          return const Center(child: Text("Yükleiyor..."));
        }
      },
    );
  }

  _notSil(int notID) {
    databaseHelper.notSil(notID).then((silinenID) {
      if (silinenID != 0) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('Not silindi'),
            action: SnackBarAction(
              label: 'Tamam',
              onPressed: () {
                // Code to execute.
              },
            ),
          ),
        );
        setState(() {});
      }
    });
  }

  OncelikIconuAta(int notOncelik) {
    switch (notOncelik) {
      case 0:
        return CircleAvatar(
          backgroundColor: Colors.green.shade400,
          child: const Text(
            'AZ',
            style: TextStyle(color: Colors.white),
          ),
        );

      case 1:
        return CircleAvatar(
          backgroundColor: Colors.yellow.shade800,
          child: const Text(
            'Orta',
            style: TextStyle(color: Colors.white),
          ),
        );

      case 2:
        return CircleAvatar(
          backgroundColor: Colors.red.shade400,
          child: const Text(
            'Acil',
            style: TextStyle(color: Colors.white),
          ),
        );
    }
  }
}

motDetaySayfasinaGit(BuildContext context, Not not) {
  Navigator.of(context).push(MaterialPageRoute(
    builder: (context) => NotDetay(
      baslik: "Notu Düzenle",
      duzenlenecekNot: not,
    ),
  ));
}
/**/ 