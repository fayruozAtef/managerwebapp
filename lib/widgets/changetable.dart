import 'dart:io';
import 'dart:typed_data';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:managerweb/widgets/EditTable/addtable.dart';
import 'package:uuid/uuid.dart';

import 'home.dart';
class Uploadimage extends StatefulWidget {

  const Uploadimage({Key? key,}) : super(key: key);

  @override
  _imagepic createState() => _imagepic();
}

class _imagepic extends State<Uploadimage> {
  String _group="";
  List imagelist=[];
  final number =TextEditingController();
  final seats =TextEditingController();
  num tableno=0;
  num seatsno=0;
  num nochange=0;
  List input=[];
  num tablenumber=-1;
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

  photo()async{

    await gettable.doc('$tableno').update({
      "image": imagelist
    });
    print("Url 222 :: $imagelist");
  }

  changenoseats() async {
    await gettable.doc('$tableno').update({
      "no-of-sets":seatsno
    });
  }
  changloca() async {
    await gettable.doc('$tableno').update({
      "location":_group
    });
  }
  getdata() async {
    QuerySnapshot dbt = await gettable.get();
    input=[];
    dbt.docs.forEach((element) {
      setState(() {
        input.add(element.get('num'));
      });
    });
    print("ta 1: $input");
  }
  @override
  void initState() {
    getdata();
    print("ta 2: $input");
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title:const Text('Arrange Table',style: TextStyle(color: Colors.white, fontSize: 30,)),),
      backgroundColor: Colors.black,
      body:SingleChildScrollView(

        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            //ADD Table
            SizedBox(height: 30,),
            Container(
              padding: EdgeInsets.fromLTRB(350, 0, 400, 0),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(5)),
              ),
              child: ButtonTheme(
                minWidth: 100.0,
                height: 50.0,
                child: RaisedButton(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.add,
                          size: 50,color: Colors.white),
                      const SizedBox(width: 10,),
                      Text('Add Table',
                        style: TextStyle(fontWeight: FontWeight.bold,
                            fontSize: 30,color: Colors.white),
                      ),
                    ],
                  ),
                  onPressed:() async {
                    QuerySnapshot dbt = await gettable.get();
                    tablenumber=dbt.size+1;
                    Navigator.of(context).push(MaterialPageRoute(builder: (context) => Addtable(tn: tablenumber,)));
                  },
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                  padding: EdgeInsets.symmetric(horizontal: 40.0,vertical: 8.0),
                  color: Colors.blue,
                ),
              ),
            ),
            SizedBox(height: 30,),
            ////Table no
            Container(
                child: Row(
                  children: [
                    buildText("Enter Table Number You Want to Change"),
                    Text("**",style: TextStyle(color:Colors.red,fontSize:22 ),)
                  ],
                )
            ),
            Container(
              color: Colors.black,
              padding: EdgeInsets.fromLTRB(50, 10, 400, 0),
              child: buildtableno(),
            ),
            SizedBox(height: 30,),
            buildText("Enter Number of Seats"),
            Container(
              color: Colors.black,
              padding: EdgeInsets.fromLTRB(50, 10, 400, 0),
              child: buildnoseat(),
            ),
            SizedBox(height: 30,),

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
            SizedBox(height: 30,),

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
                          children: [
                            Icon(Icons.cloud_upload_outlined,
                                size: 50,color: Colors.white),
                            const SizedBox(width: 10,),
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
                          children: [
                            Icon(Icons.delete_forever,
                                size: 50,color: Colors.white),
                            const SizedBox(width: 10,),
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
            SizedBox(height: 30,),
            imagelist.toString() == "[]" ? Center(child: Text(" No images Uploaded",
              style: TextStyle(fontSize: 26, fontWeight:FontWeight.bold,color: Colors.white),)): Container(
              height: 300,
              child: GridView.builder(
                  itemCount: imagelist.length,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount:4),
                  itemBuilder: (BuildContext context,int index){
                    return Image.network(File(imagelist[index]).path,);
                  }),
            ),
            SizedBox(height: 30,),
            /////Change Button
            Container(
              padding: EdgeInsets.all(10),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(5)),
              ),

              child: Center(
                child: ButtonTheme(
                  minWidth: 200.0,
                  height: 80.0,
                  child: RaisedButton(
                    child:
                    Text('Change',
                      style: TextStyle(fontWeight: FontWeight.bold,
                          fontSize: 30, color: Colors.white),
                    ),
                    onPressed:() async {
                      if(number.text.isEmpty){
                        showAlertDialog3(context,"Enter number of Table first");
                      }else{
                        if(seats.text.isEmpty){
                          tableno=int.parse(number.text) ;
                          if(input.contains(tableno)) {
                            if (imagelist.toString() != "[]") {
                              photo();
                              if (_group.isNotEmpty) {
                                changloca();
                                print("group 1");
                              }
                              showAlertDialog2(context, "You Changed Table $tableno Successefully");

                            }
                            else{
                              if (_group.isNotEmpty) {
                                showAlertDialog2(context, "You Changed Table $tableno Successefully");
                                changloca();
                                print("group 2");
                               
                              }
                              else{
                                showAlertDialog3(context, "There is no Change Happened to Table $tableno .");
                                print("no changes");
                              }}
                            }else{
                            print("wrong table");
                            showAlertDialog(context, tableno);
                          }
                          }
                        else{
                          showAlertDialog2(context, "You Changed Table $tableno Successefully");
                          tableno=int.parse(number.text) ;
                          seatsno=int.parse(seats.text) ;
                          if(input.contains(tableno)) {
                            changenoseats();

                            print("success");
                            if (imagelist.toString() != "[]") {
                              photo();
                              if (_group.isNotEmpty) {
                                changloca();
                              }
                            }else{
                              if (_group.isNotEmpty) {
                              changloca();
                            }}
                            //Navigator.of(context).push(MaterialPageRoute(builder: (context) => Home()));

                          }else {
                            showAlertDialog(context, tableno);
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
  Widget buildnoseat() =>Material(
    color: Colors.black,
    child:   TextField(
      controller: seats,
      keyboardType: TextInputType.number,
      style: TextStyle(color: Colors.white),
      decoration:  InputDecoration(
        hintText: 'Number of seats',
        hintStyle: TextStyle(color: Colors.grey,),
        errorText: "Please Enter Number of Seats",
        errorStyle: TextStyle(color: Colors.white,),
        errorBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.white),
          borderRadius:  BorderRadius.circular(15.0),
        ),
        border: OutlineInputBorder(
          borderRadius:  BorderRadius.circular(12.0),
          borderSide: BorderSide(color: Colors.white),
        ),

      ),
    ),
  );

  Widget buildtableno() =>Material(
    color:  Colors.black,
    child:   TextField(
      controller: number,
      keyboardType: TextInputType.number,
      style: TextStyle(color: Colors.white),
      decoration:  InputDecoration(
        hintText: 'Enter Table no',
        hintStyle: TextStyle(color: Colors.grey,),
        errorText: "Please Enter Table Number",
        errorStyle: TextStyle(color: Colors.white),
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
  );
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
            Text('In Door',style:TextStyle(fontSize: 22, color: Colors.white)),
            const SizedBox(width: 50,),
            Radio<String>(value: 'Out Door',
              groupValue: _group ,
              onChanged: (value) {
                setState((){
                  _group=value!;
                });
              },
            ),
            Text('Out Door',style:TextStyle(fontSize: 22, color: Colors.white))
          ]
      ),
    ),
  );
  showAlertDialog(BuildContext context, num noseats) {

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      backgroundColor: Colors.white,
      title:const Text("Warning:", style: TextStyle(
        fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black,
      ),),
      content: Text("There is no table with number $noseats in the resturant to change.", style:const  TextStyle(
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
  showAlertDialog3(BuildContext context,String message ) {

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      backgroundColor: Colors.white,
      title:const Text("Warning:", style: TextStyle(
        fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black,
      ),),
      content: Text(message, style:const  TextStyle(
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
      actions: [
        FlatButton(child: Text("ok",style: TextStyle(fontSize: 15),),
          onPressed: (){
            Navigator.of(context).pop();
            Navigator.of(context).push(MaterialPageRoute(builder: (context) => Home()));
          },
        )
      ],
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