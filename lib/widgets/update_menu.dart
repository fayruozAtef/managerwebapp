import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:file_picker/file_picker.dart';
import 'package:managerweb/widgets/totalPayment.dart';
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

  Future<FirebaseApp> secondaryApp = Firebase.initializeApp();
  firebase_storage.FirebaseStorage storage =
  firebase_storage.FirebaseStorage.instanceFor(
      bucket: 'storageBucket: "testfirebaseflutter-aa934.appspot.com",');

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
        title: Text(title2, style: TextStyle(color: Colors.white, fontSize: 40,)),
        backgroundColor: Colors.black,
      ),
      body:SingleChildScrollView(
        child:Form(
          key:formkey,
          child: Column(
            children: [
              SizedBox(height: 10),
              for(int i = 0; i < currentname.length; i++)
                Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(13.0),
                    side: BorderSide(color: Colors.black, width: 2),
                  ),
                  child: SingleChildScrollView(
                    physics: BouncingScrollPhysics(),
                    child: Column(
                      children: [
                        Container(
                          height: 375,
                          width: 2000,
                          child: (imageUrl[i]!='')? Image.network(imageUrl[i]) : SizedBox(),
                        ),
                        FloatingActionButton(
                          child: Icon(Icons.camera_alt, color: Colors.white, size: 20),
                          backgroundColor: Colors.teal,
                          mini: true,
                          onPressed:(){
                            _openPicker(i);
                          },
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
                              labelStyle: TextStyle(color:Colors.teal,fontSize: 20,fontWeight: FontWeight.bold),
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
                              labelStyle: TextStyle(color:Colors.teal,fontSize: 20),
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
                              labelStyle: TextStyle(color:Colors.teal,fontSize: 20),
                              focusedBorder: UnderlineInputBorder(
                                borderSide: BorderSide(color:Colors.black38),
                              ),
                            ),
                          ) ,
                        ),
                      ],
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
      persistentFooterButtons: [
        Column(
          children: [
           buildNavigateButton(),
            SizedBox(height: 10,),
            buildNavigateButton2(),
          ],
        ),
      ],
    );
  }
  Widget buildNavigateButton2()=>ElevatedButton(
    style:ButtonStyle(backgroundColor:MaterialStateProperty.all<Color>(Colors.teal),
        fixedSize:MaterialStateProperty.all(Size(120,50)),
        shape:MaterialStateProperty.all<RoundedRectangleBorder>(RoundedRectangleBorder(
            borderRadius:BorderRadius.circular(20)
        ))
    ),
    onPressed: () {
      final isValid = formkey.currentState!.validate();
       if(isValid==true ){
      for(int i=0;i<currentname.length;i++) {
                        if(i>=listid.length){
                          if(currentprice[i]!=0) {
                            bff.add({"name": currentname[i], "component": currentcomponent[i], "price": currentprice[i], "imagepath": imageUrl[i]
                            });
                          }
                        }
                        else {
                          updateData(i, currentname, currentcomponent, currentprice, imageUrl);
                        }
                      }
      Navigator.of(context).push(
          MaterialPageRoute(
              builder: (context) =>payment()));
       }
    },
    child: Text('save',style:TextStyle(fontSize: 35)),
  );
  Widget buildNavigateButton()=>FloatingActionButton(
    child: Icon(Icons.add, color: Colors.white, size: 20),
    onPressed: () async{
      setState(() {
        currentname.add('');
        currentcomponent.add('');
        currentprice.add(0);
        imageUrl.add('');
      });
    },
    backgroundColor: Colors.teal,
    mini: false,
  );
}