import 'dart:convert';
import 'dart:html';
import 'dart:math';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:screenshot/screenshot.dart';
class QRCreatePage extends StatefulWidget {
  const QRCreatePage({Key? key}) : super(key: key);



  @override
  State<QRCreatePage> createState() => _QRCreatePage();
}

class _QRCreatePage extends State<QRCreatePage> {
  final controller = TextEditingController();
  Uint8List? _imageFile;
  ScreenshotController screenshotController = ScreenshotController();
  List <String> numbers=[];
  bool f=false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Generate QR-code"),
      ),
      body: Align(
        alignment: Alignment.topCenter,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(30),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Text(
                    'Number of tables:',
                    style:  TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.black,),
                  ),
                  const SizedBox(width: 12),
                  SizedBox(
                      width: 300,
                      child: TextField(
                        controller: controller,
                        keyboardType: TextInputType.number,
                        style: const TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                        ),
                        decoration: InputDecoration(
                          hintText: 'Enter table numbers ',
                          hintStyle: const TextStyle(color: Colors.grey),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(16),
                            borderSide:const BorderSide(color: Colors.black),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(16),
                            borderSide: BorderSide(
                              color: Theme.of(context).primaryColor,
                            ),
                          ),
                        ),
                      )
                  ),
                  const SizedBox(width: 12),
                  FloatingActionButton(
                    backgroundColor: Theme.of(context).primaryColor,
                    child:const  Icon(Icons.done, size: 30),
                    onPressed: () => setState(() {
                      numbers=[];
                      f=false;
                      if(controller.text.isEmpty) {
                        showAlertDialog(context,"Enter number of tables");
                      }
                      else{
                        int num = int.parse(controller.text);
                        if(num>0){
                          f = true;
                          while (numbers.length<num) {
                            var r = Random();
                            String s = String.fromCharCodes(List.generate(5, (index) => r.nextInt(33) + 89));
                            numbers.add(s);
                          }
                        }
                      }
                    }),
                  )
                ],
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
                                              data: numbers[i],
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
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          print("ready to take the image");
          screenshotController.capture().then((Uint8List? image) {
            print("Photo has taken");
            //Capture Done
            setState(() {
              _imageFile = image;
              print("Photo saved in imagefile");
            });
            print("Start download");
            download(_imageFile!.toList());
            debugPrint('downloaded successfully');
          }).catchError((onError) {
            print("an error catched");
            debugPrint(onError);
          });
        },
        tooltip: 'Increment',
        child: const Text("Save ", style: TextStyle(fontSize: 18),),
      ),
    );
  }

  void download(List<int> bytes) {
    // Encode our file in base64
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
      title:const Text("Warning:", style: TextStyle(
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