import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:file_picker/file_picker.dart';
import 'package:managerweb/widgets/update_categories.dart';
import 'dart:typed_data';
import 'package:uuid/uuid.dart';


class details extends StatefulWidget {
  String title;
  details({Key? key,required this.title}) : super(key: key);

  @override
  createState(){
    return MyAppState(title2: title);
  }
}

class MyAppState extends State<details> {
  String title2;
MyAppState({Key? key, required this.title2}) : super();

  List <String> currentname=[];
  List <String> currentcomponent=[];
  List <num> currentprice=[];
  List<String> imageUrl=[];
  List listid=[];
  List deleteElement=[];
  List color=[];

  Future<FirebaseApp> secondaryApp = Firebase.initializeApp();
  firebase_storage.FirebaseStorage storage =
  firebase_storage.FirebaseStorage.instanceFor(
      bucket: 'storageBucket: "testfirebaseflutter-aa934.appspot.com",');

  CollectionReference bff = FirebaseFirestore.instance.collection("menu");

  getData() async {
    QuerySnapshot dbf = await bff.where('type',isEqualTo:title2).get();
    dbf.docs.forEach((element) {
      setState(() {
        listid.add(element.id);
        currentname.add(element.get('name'));
        currentcomponent.add(element.get('component'));
        currentprice.add(element.get('price'));
        imageUrl.add(element.get('imagepath'));
        color.add(0);
      });
    });
  }

  updateData(int n,List <String> name,List <String> component,List <num> price,List <String> image) async{
    CollectionReference db = FirebaseFirestore.instance.collection("menu");
    return await db.doc(listid[n]).set(
      {"name": name[n], "component": component[n], "price": price[n],"imagepath":image[n]},
      SetOptions(merge: true),
    );
  }


  _openPicker(int n) async{
    FilePickerResult? result;
    result=await FilePicker.platform.pickFiles();

    if(result != null) {
      Uint8List? uploadFile = result.files.single.bytes;
      firebase_storage.Reference reference =storage.refFromURL('gs://testfirebaseflutter-aa934.appspot.com/').child(Uuid().v1());
      final firebase_storage.UploadTask uploadTask = reference.putData(uploadFile!);

      uploadTask.whenComplete(() async {
        String image = await uploadTask.snapshot.ref.getDownloadURL();
        setState(() {
          imageUrl[n] = image;
        });
      });
    }
  }

  @override
  void initState() {
    getData();
    super.initState();
  }

  final formkey=GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title2, style: TextStyle(color: Colors.white, fontSize: 30,)),
      ),
      body:SingleChildScrollView(
        child:Form(
          key:formkey,
          child: Column(
            children: [
              SizedBox(height: 10),
              for(int i = 0; i < currentname.length; i++)
                Card(
                  color: color[i]==0?Colors.white:Colors.black26,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(13.0),
                    side: BorderSide(color: Colors.black, width: 2),
                  ),
                  child: Row(
                      children: [
                   Expanded(child:
                   Column(
                      children: [
                        Container(
                          width: 400,
                          height: 400,
                          child: (imageUrl[i]!='')? Image.network(imageUrl[i]) : SizedBox(),
                        ),
                        FloatingActionButton(
                          child: Icon(Icons.camera_alt, color: Colors.white, size: 20),
                          backgroundColor: Colors.blue,
                          mini: true,
                          onPressed:(){
                            _openPicker(i);
                          },
                        ),
                      ],
                    ),),
                    Expanded(child:  Column(
                          children: [
                            Align(
                              alignment: Alignment.topRight,
                              child: FloatingActionButton(
                                child:Icon(Icons.delete ,color:Colors.red,size:40,),
                                onPressed: (){
                                  if(i<listid.length){
                                    setState(() {
                                      deleteElement.add(listid[i]);
                                      currentname[i]='';
                                      currentcomponent[i]='';
                                      currentprice[i]=0;
                                      imageUrl[i]='';
                                      listid[i]='';
                                      color[i]=1;
                                    });
                                  }
                                  else{
                                    setState(() {
                                      currentname[i]='';
                                      currentcomponent[i]='';
                                      currentprice[i]=0;
                                      imageUrl[i]='';
                                      color[i]=1;
                                    });
                                  }
                                  },
                                backgroundColor:Colors.white,
                                mini:false,
                              ),
                            ),
                            Container(
                              padding:EdgeInsets.all(13),
                              child:TextFormField(
                                initialValue: currentname[i],
                                validator: (val){
                                  if(val!.isEmpty) {
                                    return 'Please Enter Name Of Item';
                                  }
                                  return null;
                                },
                                onChanged: (val)=>setState((){currentname[i]=val;
                                print('current name=$currentname');}),
                                style:const TextStyle(color:Colors.black,fontSize: 25, fontWeight: FontWeight.bold),
                                cursorColor: Colors.black,
                                decoration: const InputDecoration(
                                  labelText: 'Name of Item',
                                  labelStyle: TextStyle(color:Colors.blue,fontSize: 20,fontWeight: FontWeight.bold),
                                  focusedBorder: UnderlineInputBorder(
                                    borderSide: BorderSide(color:Colors.black38),
                                  ),
                                ),
                              ) ,
                            ),
                            Container(
                              padding:const EdgeInsets.all(13),
                              child:TextFormField(
                                initialValue: currentcomponent[i],
                                validator: (val){
                                  /* if(val!.isEmpty) {
                                return 'Please Enter Component Of Item';
                              }*/
                                  return null;
                                },
                                onChanged: (val)=>setState(()=>currentcomponent[i]=val),
                                style:const TextStyle(color:Colors.black,fontSize: 25, fontWeight: FontWeight.bold),
                                cursorColor: Colors.black,
                                decoration: const InputDecoration(
                                  labelText: 'Component of Item',
                                  labelStyle: TextStyle(color:Colors.blue,fontSize: 20),
                                  focusedBorder: UnderlineInputBorder(
                                    borderSide: BorderSide(color:Colors.black38),
                                  ),
                                ),
                              ) ,
                            ),
                            Container(
                              padding:EdgeInsets.all(13),
                              child:TextFormField(
                                initialValue: '${currentprice[i]}',
                                validator: (val){
                                  if(val!.isEmpty) {
                                    return 'Please Enter The Price Of Item';
                                  }
                                  return null;
                                },
                                onChanged: (val)=>setState((){
                                  currentprice[i]=num.parse(val);
                                  print('price $currentprice');
                                }),
                                style:const TextStyle(color:Colors.black,fontSize: 25, fontWeight: FontWeight.bold),
                                cursorColor: Colors.black,
                                decoration: const InputDecoration(
                                  labelText: 'Price of Item',
                                  labelStyle: TextStyle(color:Colors.blue,fontSize: 20),
                                  focusedBorder: UnderlineInputBorder(
                                    borderSide: BorderSide(color:Colors.black38),
                                  ),
                                ),
                              ) ,
                            ),
                         ],
                      ),
                    ),
                  ],
                ),
               ),
              Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(13.0),
                  side: BorderSide(color: Colors.black, width: 2),
                ),
                child:InkWell(onTap: ()async{
                  setState(() {
                    currentname.add('New');
                    currentcomponent.add('');
                    currentprice.add(0);
                    imageUrl.add('');
                    color.add(0);
                  });
                },
                  child: Row(
                    children: [
                      Expanded(child: Column(
                        children: [
                          Container(
                            width: 100,
                            height: 100,
                            color: Colors.white,
                          ),
                          FloatingActionButton(
                            child: Icon(Icons.camera_alt, color: Colors.white, size: 20),
                            backgroundColor: Colors.blue,
                            mini: true,
                            onPressed:(){},
                          ),
                        ],
                      )),
                      Container(
                        width: 50,
                        height: 60,
                        child:Icon(Icons.add, color: Colors.white, size: 50),
                        color: Colors.blue,
                      ),
                      Expanded(child: Column(
                        children: [
                          Container(
                            height: 100,
                            padding:EdgeInsets.all(13),
                            child:TextFormField(
                              initialValue: 'new',
                              style:const TextStyle(color:Colors.black,fontSize: 25, fontWeight: FontWeight.bold),
                              cursorColor: Colors.black,
                              decoration: const InputDecoration(
                                labelText: 'Name of Item',
                                labelStyle: TextStyle(color:Colors.blue,fontSize: 20,fontWeight: FontWeight.bold),
                                focusedBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(color:Colors.black38),
                                ),
                              ),
                            ) ,
                          ),
                          Container(
                            padding:const EdgeInsets.all(13),
                            child:TextFormField(
                              initialValue: 'new',
                              style:const TextStyle(color:Colors.black,fontSize: 25, fontWeight: FontWeight.bold),
                              cursorColor: Colors.black,
                              decoration: const InputDecoration(
                                labelText: 'Component of Item',
                                labelStyle: TextStyle(color:Colors.blue,fontSize: 20),
                                focusedBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(color:Colors.black38),
                                ),
                              ),
                            ) ,
                          ),
                          Container(
                            padding:EdgeInsets.all(13),
                            child:TextFormField(
                              initialValue: 'new',
                              style:const TextStyle(color:Colors.black,fontSize: 25, fontWeight: FontWeight.bold),
                              cursorColor: Colors.black,
                              decoration: const InputDecoration(
                                labelText: 'Price of Item',
                                labelStyle: TextStyle(color:Colors.blue,fontSize: 20),
                                focusedBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(color:Colors.black38),
                                ),
                              ),
                            ) ,
                          ),
                        ],
                       ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: buildNavigateButton2(),
    );
  }
  Widget buildNavigateButton2()=>ElevatedButton(
    style:ButtonStyle(backgroundColor:MaterialStateProperty.all<Color>(Colors.blue),
        fixedSize:MaterialStateProperty.all(Size(120,50)),
        shape:MaterialStateProperty.all<RoundedRectangleBorder>(RoundedRectangleBorder(
            borderRadius:BorderRadius.circular(20)
        ))
    ),
    onPressed: () async{
      final isValid = formkey.currentState!.validate();
       if(isValid==true ){
      for(int i=0;i<currentname.length;i++) {
                        if(i>=listid.length){
                          if(currentprice[i]!=0 && imageUrl[i]!='') {
                            bff.add({"name": currentname[i], "component": currentcomponent[i], "price": currentprice[i], "imagepath": imageUrl[i],"type":title2
                            });
                          }
                        }
                        else {
                          updateData(i, currentname, currentcomponent, currentprice, imageUrl);
                        }
                      }
      for(int k=0;k<deleteElement.length;k++){
        bff.doc(deleteElement[k]).delete();
      }

      showAlertDialog(context,"Your update in menu is Done");
      Timer(const Duration(seconds: 3), () {
        Navigator.of(context).pushReplacement(
            MaterialPageRoute(
                builder: (context) =>Categories()));
      });
     }
    },
    child: Text('save',style:TextStyle(fontSize: 35)),
  );

  showAlertDialog(BuildContext context,String message) {
    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(30),
      ),
      backgroundColor: Colors.white,
      title:const Text("Message:", style: TextStyle(
        fontSize: 24, fontWeight: FontWeight.bold, color: Colors.black,
      ),),
      content: Text(message, style: const TextStyle(
        fontSize: 20, color: Colors.black,
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