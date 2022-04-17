import 'dart:math';
import 'dart:typed_data';
import 'dart:ui';
import 'dart:io';
import 'package:barcode_widget/barcode_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:share_plus/share_plus.dart';


class QRCreatePage extends StatefulWidget {
  @override
  _QRCreatePageState createState() => _QRCreatePageState();
}

class _QRCreatePageState extends State<QRCreatePage> {
  final controller = TextEditingController();
  bool f=false;
  List <String> numbers=[];
  final key = GlobalKey();
  File? file;
  /*Future<void> renderImage() async {
    //Get the render object from context.
    final RenderObject? boundary = globalKey.currentContext?.findRenderObject();
    //Convert to the image
    final Image image = await boundary!.toImage();
  }*/
  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          title: const Text("Generate QR codes"),
        ),
        backgroundColor: Colors.black ,
        body: Align(
          alignment: Alignment.topCenter,
          child: SingleChildScrollView(
            child: Column(
              children:[ SingleChildScrollView(
                padding: const EdgeInsets.all(30),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const Text(
                          'Number of tables:',
                          style:  TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.white,),
                        ),
                        const SizedBox(width: 12),
                        SizedBox(
                            width: 300,
                            child: TextField(
                              controller: controller,
                              keyboardType: TextInputType.number,
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 20,
                              ),
                              decoration: InputDecoration(
                                hintText: 'Enter table numbers ',
                                hintStyle: const TextStyle(color: Colors.grey),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(16),
                                  borderSide:const BorderSide(color: Colors.white),
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
                    const SizedBox(height: 40),
                    if(f==true)
                      for(int i=0;i<numbers.length;i+=3)
                        Container(
                          padding: const EdgeInsets.fromLTRB(10, 20, 10, 10),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              for(int k=0;k<3;k++)
                                if(i+k<numbers.length)
                                  Container(
                                    padding: const EdgeInsets.fromLTRB(0, 0, 30, 10),
                                    child: Column(
                                      children: [
                                        BarcodeWidget(
                                          barcode: Barcode.qrCode(),
                                          color: Colors.white,
                                          data: numbers[i+k],
                                          width: 300,
                                          height: 300,
                                        ),
                                        const SizedBox(height: 10,),
                                         Text(
                                           '${(i+k)+1}',
                                          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white,),
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
              ]
            ),
          ),
        ),
      floatingActionButton: buildNavigateButton(),
      );

  Widget buildNavigateButton()=>FloatingActionButton.extended(
    backgroundColor: Colors.blue,
    onPressed: ()async {
      try {
        RenderRepaintBoundary boundary = key.currentContext!
            .findRenderObject() as RenderRepaintBoundary;
//captures qr image
        var image = await boundary.toImage();

        ByteData? byteData =
        await image.toByteData(format: ImageByteFormat.png);

        Uint8List pngBytes = byteData!.buffer.asUint8List();
//app directory for storing images.
        final appDir = await getTemporaryDirectory();
//current time
        var datetime = DateTime.now();
//qr image file creation
        file = await File('${appDir.path}/$datetime.png').create();
//appending data
        await file?.writeAsBytes(pngBytes);
//Shares QR image
        await Share.shareFiles(
          [file!.path],
          mimeTypes: ["image/png"],
          text: "Share the QR Code",
        );
      } catch (e) {
        print(e.toString());
      }
    },
    label: const Text('Save Codes', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.white,),),
  );

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

