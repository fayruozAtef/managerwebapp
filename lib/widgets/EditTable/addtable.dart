// ignore_for_file: unnecessary_null_comparison

import 'dart:io';
import 'dart:typed_data';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

import '../home.dart';
class Addtable extends StatefulWidget {
  final num tn;
  const Addtable({Key? key,required this.tn,}) : super(key: key);
  @override
  _add createState() => _add(tablenumber: this.tn);
}

class _add extends State<Addtable> {
  num tablenumber;

_add({Key? key,required this.tablenumber});
  String _group="";
  List imagelist=[];
  final seats =TextEditingController();
  num seatsno=0;
  num nochange=0;
  List input=[];
  CollectionReference gettable = FirebaseFirestore.instance.collection("tables");
  FirebaseStorage _storage= FirebaseStorage.instanceFor(
      bucket:'storageBucket: "testfirebaseflutter-aa934.appspot.com"' );
  //String filename = result.files.single.name;


  _openPicker() async{
    FilePickerResult? result;
    result=await FilePicker.platform.pickFiles(
        type: FileType.image
    );

    if(result != null) {
      Uint8List? uploadFile = result.files.single.bytes;
      Reference reference =_storage.refFromURL('gs://testfirebaseflutter-aa934.appspot.com').child(Uuid().v1());
      UploadTask uploadTask = reference.putData(uploadFile!);

      uploadTask.whenComplete(() async {
        String image = await uploadTask.snapshot.ref.getDownloadURL();
        setState(() {

          imagelist.add(image);
          print("Url :: $imagelist");
        });
      });
      return imagelist;
    }
  }

@override
   initState() {
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title:const Text('Add Table',style: TextStyle(color: Colors.white, fontSize: 30,)),),
      backgroundColor: Colors.black,
      body:SingleChildScrollView(

        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [

            const SizedBox(height: 30,),
            buildText(" Table Number: $tablenumber"),
            const SizedBox(height: 30,),

            buildText("Enter Number of Seats"),
            Container(
              color: Colors.black,
              padding:const EdgeInsets.fromLTRB(50, 10, 400, 0),
              child:  TextField(
                controller: seats,
                keyboardType: TextInputType.number,
                style:const TextStyle(color: Colors.white),
                decoration:  InputDecoration(
                  hintText: 'Number of seats',
                  hintStyle: const TextStyle(color: Colors.grey,),
                  errorText: "Please Enter Number of Seats",
                  errorStyle:const TextStyle(color: Colors.white,),
                  errorBorder: OutlineInputBorder(
                    borderSide:const BorderSide(color: Colors.white),
                    borderRadius:  BorderRadius.circular(15.0),
                  ),
                  border: OutlineInputBorder(
                    borderRadius:  BorderRadius.circular(12.0),
                    borderSide: BorderSide(color: Colors.white),
                  ),

                ),
              ),
            ),
           const SizedBox(height: 30,),

            ////Location
            Container(
              color: Colors.black,
              child: Row(
                children: [
                  buildText(" Location Of table"),
                  const SizedBox(width: 50,),
                  buildlocation(),
                ],
              ),
            ),
            const SizedBox(height: 30,),

            ////UploadPhoto
            Container(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    child: ButtonTheme(
                      minWidth: 100.0,
                      height: 50.0,
                      child: RaisedButton(
                        child: Row(
                          children:const [
                            Icon(Icons.cloud_upload_outlined,
                                size: 50,color: Colors.white),
                             SizedBox(width: 10,),
                            Text('Upload Image',
                              style: TextStyle(fontWeight: FontWeight.bold,
                                  fontSize: 30,color: Colors.white),
                            ),
                          ],
                        ),
                        onPressed:() {
                          _openPicker();
                        },
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                        padding: EdgeInsets.symmetric(horizontal: 40.0,vertical: 8.0),
                        color: Colors.blue,
                      ),
                    ),
                  ),
                  const SizedBox(width: 80,),
                  Container(
                    child: ButtonTheme(
                      minWidth: 100.0,
                      height: 50.0,
                      child: RaisedButton(
                        child: Row(
                          children: const [
                            Icon(Icons.delete_forever,
                                size: 50,color: Colors.white),
                            SizedBox(width: 10,),
                            Text('Delete Images',
                              style: TextStyle(fontWeight: FontWeight.bold,
                                  fontSize: 30,color: Colors.white),
                            ),
                          ],
                        ),
                        onPressed:() {
                          imagelist=[];
                        },
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                        padding: EdgeInsets.symmetric(horizontal: 40.0,vertical: 8.0),
                        color: Colors.blue,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 30,),
            imagelist.toString() == "[]" ?
            const Center(child: Text(" No images Uploaded",
              style: TextStyle(fontSize: 26, fontWeight:FontWeight.bold,color: Colors.white),)): Container(
              height: 300,
              child: GridView.builder(
                  itemCount: imagelist.length,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount:4),
                  itemBuilder: (BuildContext context,int index){
                    return Image.network(File(imagelist[index]).path,);
                  }),
            ),
            const SizedBox(height: 30,),
            /////Change Button
            Container(
              padding: const EdgeInsets.all(10),
              decoration: const BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(5)),
              ),

              child: Center(
                child: ButtonTheme(
                  minWidth: 200.0,
                  height: 80.0,
                  child: RaisedButton(
                    child:
                    const Text('Add Table',
                      style: TextStyle(fontWeight: FontWeight.bold,
                          fontSize: 30, color: Colors.white),
                    ),
                    onPressed:()  async {
                      if(seats.text.isEmpty){
                        print("You click on the button");
                        showAlertDialog2(context,"Enter number of seats first");
                      }
                      else{
                        seatsno=int.parse(seats.text);
                        if(imagelist.length==0){
                          showAlertDialog2(context, "Insert images first");
                        }
                        else{
                          if (_group.isNotEmpty) {
                            await gettable.doc("$tablenumber").set(
                                {
                                  "num": tablenumber,
                                  "no-of-sets": seatsno,
                                  "location": _group,
                                  "images": imagelist
                                },
                                showAlertDialog3(context),
                            );
                            Navigator.of(context).pop();
                            Navigator.of(context).push(MaterialPageRoute(builder: (context) => Home()));
                          }
                          else{
                            showAlertDialog2(context, "Choose the table place");
                          }
                        }

                      }

                    },
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                    padding: EdgeInsets.symmetric(horizontal: 40.0,vertical: 8.0),
                    color: Colors.blue,
                  ),
                ),
              ),
            ),
          ],
        ),
      ) ,
    );
  }
  Widget buildText(String text)=>Container(
    padding: EdgeInsets.fromLTRB(10.0,10.0,0,5),
    child: Text(
      text,
      style: TextStyle(fontWeight: FontWeight.bold,fontSize: 20,color: Colors.white),
    ),
  );
  /*Widget buildnoseat() =>Material(
    color: Colors.black,
    child:   TextField(
      controller: seats,
      keyboardType: TextInputType.number,
      style:const TextStyle(color: Colors.white),
      decoration:  InputDecoration(
        hintText: 'Number of seats',
        hintStyle: const TextStyle(color: Colors.grey,),
        errorText: "Please Enter Number of Seats",
        errorStyle:const TextStyle(color: Colors.white,),
        errorBorder: OutlineInputBorder(
          borderSide:const BorderSide(color: Colors.white),
          borderRadius:  BorderRadius.circular(15.0),
        ),
        border: OutlineInputBorder(
          borderRadius:  BorderRadius.circular(12.0),
          borderSide: BorderSide(color: Colors.white),
        ),

      ),
    ),
  );*/

  /*Widget buildtableno() =>Material(
    color:  Colors.black,
    child:   TextField(
      controller: number,
      keyboardType: TextInputType.number,
      style: const TextStyle(color: Colors.white),
      decoration:  InputDecoration(
        hintText: 'Enter Table no',
        hintStyle: const TextStyle(color: Colors.grey,),
        errorText: "Please Enter Table Number",
        errorStyle: const TextStyle(color: Colors.white),
        errorBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: Colors.white),
          borderRadius:  BorderRadius.circular(15.0),
        ),
        border: OutlineInputBorder(
          borderRadius:  BorderRadius.circular(12.0),
          borderSide: const BorderSide(color: Colors.white),
        ),

      ),
    ),
  );*/

  Widget buildlocation() =>Material(
    color: Colors.black,
    child:   Theme(
      data: ThemeData.dark(),
      child: Row(
          children:[
            Radio<String>(
              value: 'In Door',
              groupValue: _group,
              onChanged: (value) {
                setState((){
                  _group=value!;
                });
              },
            ),
            const Text('In Door',style:TextStyle(fontSize: 22, color: Colors.white)),
            const SizedBox(width: 50,),
            Radio<String>(value: 'Out Door',
              groupValue: _group ,
              onChanged: (value) {
                setState((){
                  _group=value!;
                });
              },
            ),
            const Text('Out Door',style:TextStyle(fontSize: 22, color: Colors.white))
          ]
      ),
    ),
  );
  showAlertDialog(BuildContext context, num noseats) {

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      backgroundColor: Colors.white54,
      title:const Text("Warning:", style: TextStyle(
        fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white,
      ),),
      content: Text("There is table with number $noseats in the Resturant.", style:const  TextStyle(
        fontSize: 18, color: Colors.black,
      ),),
      actions: const [],
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }
  showAlertDialog2(BuildContext context,String message) {

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      backgroundColor: Colors.white,
      title: const Text("Warning:", style: TextStyle(
        fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black,
      ),),
      content: Text(message, style:const TextStyle(
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
  showAlertDialog3(BuildContext context) {

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      backgroundColor: Colors.white54,
      title:const Text("Message:", style: TextStyle(
        fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white,
      ),),
      content: Text("You Added Table Successfully.", style:const  TextStyle(
        fontSize: 18, color: Colors.black,
      ),),
      actions: const [],
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