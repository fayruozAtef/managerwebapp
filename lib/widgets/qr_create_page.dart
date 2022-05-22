import 'dart:async';
import 'dart:convert';
import 'dart:html';
import 'dart:math';
import 'dart:typed_data';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:screenshot/screenshot.dart';
import 'home.dart';
class QRCreatePage extends StatefulWidget {
   QRCreatePage({Key? key,}) : super(key: key);
  @override
  State<QRCreatePage> createState() => _QRCreatePage();
}

class _QRCreatePage extends State<QRCreatePage> {
  String Managerid= FirebaseAuth.instance.currentUser!.uid;
  _QRCreatePage({Key? key,});
  Uint8List? _imageFile;
  ScreenshotController screenshotController = ScreenshotController();
  List <String> numbers=[];
  bool f=false;
  int tablesNumber=0;
  CollectionReference tables = FirebaseFirestore.instance.collection("tables");

  @override
  void initState() {
    // TODO: implement initState
    gettableNumber();
  }
  Future<void> gettableNumber() async {
    tables.get().then((querySnapshot) {
      tablesNumber=querySnapshot.size;
    });
  }
  void generateQRcodes(){
    numbers=[];
    f=false;
    if(tablesNumber>0){
      f = true;
      while (numbers.length<tablesNumber) {
        var r = Random();
        String s = String.fromCharCodes(List.generate(5, (index) => r.nextInt(33) + 89));
        numbers.add(s);
      }
    }
    else {
      showAlertDialog(context,
          "There is no tables stored in the database. \n Please add tables first.");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Generate QR-code", style: TextStyle(color: Colors.white, fontSize: 30,)),
      ),
      body: Align(
        alignment: Alignment.topCenter,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(30),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              FloatingActionButton.extended(
                  backgroundColor: Theme.of(context).primaryColor,
                  label:const Text("Generate Codes", style: TextStyle(fontSize: 30),),
                  onPressed: () => setState(() {
                    generateQRcodes();
                  }),
              ),
              const SizedBox(height: 50,),
              if(f==true)
                Screenshot(
                  controller: screenshotController,
                  child:  Container(
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          for(int i=0;i<numbers.length;i+=4)
                            Container(
                              padding: const EdgeInsets.fromLTRB(10, 20, 10, 10),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  for(int k=0;k<4;k++)
                                    if(i+k<numbers.length)
                                      Container(
                                        padding: const EdgeInsets.fromLTRB(0, 0, 30, 10),
                                        child: Column(
                                          children: [
                                            QrImage(
                                              data: numbers[i+k],
                                              version: QrVersions.auto,
                                              size: 250.0,
                                            ),
                                            const SizedBox(height: 10,),
                                            Text(
                                              "( ${(i+k)+1} )",
                                              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black,),
                                            ),
                                          ],
                                        ),
                                      ),
                                ],
                              ),
                            ),
                        ],
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
      floatingActionButton:f==true? FloatingActionButton.extended(
        onPressed: () {
          screenshotController.capture().then((Uint8List? image) {
            //Capture Done
            print("photo is taken");
            setState(() {
              _imageFile = image;
            });
            download(_imageFile!.toList());
            f=false;
            numbers=[];
            Timer(const Duration(seconds: 3), () {
              //Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context)=>Home(ManagerId: Managerid,)));
            });
            showAlertDialog(context, "QR-codes Created and downloaded sucessfully");
          }).catchError((onError) {
            debugPrint(onError.toString());
          });
        },
        tooltip: 'Increment',
        label: const Text(" SAVE ", style: TextStyle(fontSize: 23),),
      ):const SizedBox(),
    );
  }

  updatecodes(int docID,String code) async {
    await tables.doc('$docID').update({'qrcode': code})
        .then((value) => print("table Code Updated"))
        .catchError((error) => print("Failed to update table: $error"));
    print("all are updated");
  }

  void download(List<int> bytes) {
    // Encode our file in base64
    for(int i=0;i<numbers.length;i++) {
      updatecodes((i + 1), numbers[i]);
    }
    final _base64 = base64Encode(bytes);
    // Create the link with the file
    final anchor =
    AnchorElement(href: 'data:application/octet-stream;base64,$_base64')
      ..target = 'blank';
    // add the name
    anchor.download = 'qrcode.png';
    // trigger download
    document.body!.append(anchor);
    anchor.click();
    anchor.remove();
    return;
  }

  showAlertDialog(BuildContext context,String message) {
    // set up the AlertDialog
    AlertDialog alert =  AlertDialog(
      backgroundColor: Colors.white54,
      title:const Text("Message:", style: TextStyle(
        fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white,
      ),),
      content: Text('$message', style: const TextStyle(
        fontSize: 18, color: Colors.black,
      ),),
      actions: [],
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }
}