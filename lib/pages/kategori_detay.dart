import 'package:flutter/material.dart';
import 'package:flutter_not_sepeti_app/model/kategori.dart';
import 'package:flutter_not_sepeti_app/until/database_helper.dart';

class KategoriDetay extends StatefulWidget {
  const KategoriDetay({super.key});

  @override
  State<KategoriDetay> createState() => _KategoriDetayState();
}

class _KategoriDetayState extends State<KategoriDetay> {
  List<Kategori>? tumKategoriler;
  late DatabaseHelper databaseHelper;
  @override
  void initState() {
    super.initState();

    databaseHelper = DatabaseHelper();
  }

  @override
  Widget build(BuildContext context) {
    if (tumKategoriler == null) {
      tumKategoriler = <Kategori>[];
      kategoriListesiniGuncelle();
    }
    return Scaffold(
      appBar: AppBar(
        title: const Text('Kategoriler'),
      ),
      body:tumKategoriler!.length <= 0 ? const Center(child: Text('Lütfen kategori ekleyin!',style: TextStyle(fontSize: 20,color:Colors.purple,fontWeight:FontWeight.w600),)): ListView.builder(
        itemCount: tumKategoriler!.length,
        itemBuilder: (context, index) {
          return ListTile(
            onTap: () => _kategoriGuncelle(tumKategoriler![index], context),
            leading: const Icon(Icons.category),
            title: Text(tumKategoriler![index].kategoriBaslik!),
            trailing: InkWell(
                onTap: () => kategoriSil(tumKategoriler![index].kategoriID!),
                child: const Icon(Icons.delete)),
          );
        },
      ),
    );
  }

  kategoriSil(int kategoriID) {
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Kategori Sil'),
          content: Container(
            width: 250,
            height: 160,
            child: Column(children: [
              const Text(
                  'Kategoriyi silmek istediğiniz durumda  bu kategoriyi içeren notlarda silinecektir.Silmek istediğinize emin misiniz?'),
              const SizedBox(
                height: 10,
              ),
              ButtonBar(
                alignment: MainAxisAlignment.spaceEvenly,
                mainAxisSize: MainAxisSize.min,
                children: [
                  ElevatedButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: const Text('Vazgeç')),
                  ElevatedButton(
                      onPressed: () {
                        databaseHelper.kategroriSil(kategoriID).then(
                          (silinecekKategori) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: const Text('Not silindi'),
                                action: SnackBarAction(
                                  label: 'Tamam',
                                  onPressed: () {},
                                ),
                              ),
                            );
                            setState(() {
                              kategoriListesiniGuncelle();
                              Navigator.of(context).pop();
                            });
                          },
                        );
                      },
                      child: const Text('Sil')),
                ],
              )
            ]),
          ),
        );
      },
    );
  }

  void kategoriListesiniGuncelle() {
    databaseHelper.kategoriListesiniGetir().then((kategorileriIcerenList) {
      setState(() {
        tumKategoriler = kategorileriIcerenList;
      });
    });
  }

  _kategoriGuncelle(Kategori guncellenecekKategori,BuildContext context ) {
    kategoriGuncelleDialog(context, guncellenecekKategori);
  }

  kategoriGuncelleDialog(BuildContext context, Kategori guncellenecekKategori) {
    var formKey = GlobalKey<FormState>();

    String? guncellenecekKategoriAdi;
    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (context) {
          return SimpleDialog(
            title: const Text("Kategori Güncelle"),
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
                            initialValue: guncellenecekKategori.kategoriBaslik,
                            onSaved: (yeniDeger) {
                              guncellenecekKategoriAdi = yeniDeger!;
                            },
                            autofocus: true,
                            decoration: const InputDecoration(
                                hintText: "Güncellenecek kategori ",
                                border: InputBorder.none),
                            validator: (yeniDeger) {
                              if (yeniDeger!.length < 3) {
                                return "En az 3 karakter giriniz! ";
                              }
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
                              .kategoriGuncelle(Kategori.WithID(
                                  guncellenecekKategori.kategoriID,
                                  guncellenecekKategoriAdi))
                              .then((katID) {
                            if (katID != null) {
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
                              kategoriListesiniGuncelle();
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
}
/*   */