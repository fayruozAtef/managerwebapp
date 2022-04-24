import 'dart:typed_data';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:managerweb/widgets/update_menu.dart';
import 'package:uuid/uuid.dart';

List listid=[];
List imgList=[];
List name=[];
List color=[];
List deleteElement=[];

class Categories extends StatefulWidget {
  Categories({Key? key}) : super(key: key);

  @override
  _CategoriesState createState() => _CategoriesState();
}

class _CategoriesState extends State<Categories> {

  Future<FirebaseApp> secondaryApp = Firebase.initializeApp();
  firebase_storage.FirebaseStorage storage =
  firebase_storage.FirebaseStorage.instanceFor(
      bucket: 'storageBucket: "testfirebaseflutter-aa934.appspot.com",');

  CollectionReference bff = FirebaseFirestore.instance.collection("categories");
  getData() async {
    QuerySnapshot dbf = await bff.get();
    dbf.docs.forEach((element) {
      setState(() {
        listid.add(element.id);
        name.add(element.get('type'));
        imgList.add(element.get('imagepath'));
        color.add(0);
      });
    });
  }

  _openPicker(int n) async{
    FilePickerResult? result;
    result=await FilePicker.platform.pickFiles();

    if(result != null) {
      Uint8List? uploadFile = result.files.single.bytes;
      firebase_storage.Reference reference =storage.refFromURL('gs://testfirebaseflutter-aa934.appspot.com').child(Uuid().v1());
      final firebase_storage.UploadTask uploadTask = reference.putData(uploadFile!);

      uploadTask.whenComplete(() async {
        String image = await uploadTask.snapshot.ref.getDownloadURL();
        setState(() {
          imgList[n] = image;
        });
      });
    }
  }

  updateData(int n,List name,List image) async{
    CollectionReference db = FirebaseFirestore.instance.collection("categories");
    return await db.doc(listid[n]).update(
      {"type": name[n], "imagepath":image[n]},
    );
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
        title: const Text('Menu' ,
            style: TextStyle(color: Colors.white, fontSize: 25,
              fontWeight: FontWeight.bold,
            )
        ),
        automaticallyImplyLeading: false,
      ),
      body:SingleChildScrollView(
       child:Form(
       key:formkey,
        child: Column(
            children: [
             for(int i=0;i<name.length;i++)
                Card(
                  color: color[i]==0?Colors.white:Colors.black26,
                  child:InkWell(onTap: (){
                    Navigator.of(context).pushReplacement(
                        MaterialPageRoute(builder: (context)=>details(title: name[i])));
                  },
                    child: Row(
                      children: [
                        Expanded(child: Column(children: [
                          Container(
                            width: 400,
                            height: 400,
                            child: (imgList[i]!='')?Image.network(imgList[i]) : SizedBox(height: 100,width: 100,),
                          ),
                          FloatingActionButton(
                            child: Icon(Icons.camera_alt, color: Colors.white, size: 20),
                            backgroundColor: Colors.blue,
                            mini: true,
                            onPressed:(){
                              _openPicker(i);
                            },
                          ),
                        ],)),
                        Expanded(child:
                            Column(children: [
                              Align(
                                alignment: Alignment.topRight,
                                child:FloatingActionButton(
                                  child:Icon(Icons.delete ,color:Colors.red,size:40,),
                                  onPressed: (){
                                    if(i<listid.length){
                                      setState(() {
                                        deleteElement.add(listid[i]);
                                        name[i]='';
                                        imgList[i]='';
                                        listid[i]='';
                                        color[i]=1;
                                      });
                                    }
                                    else{
                                      setState(() {
                                        name[i]='';
                                        imgList[i]='';
                                        color[i]=1;
                                      });
                                    }
                                    },
                                  backgroundColor:Colors.white,
                                  mini:false,
                                ),
                              ),
                              Container(
                                height: 100,
                                padding:EdgeInsets.all(13),
                                child:TextFormField(
                                  initialValue: name[i],
                                  validator: (val){
                                    if(val!.isEmpty) {
                                      return 'Please Enter Name Of Category';
                                    }
                                    return null;
                                  },
                                  onChanged: (val)=>setState((){name[i]=val;}),
                                  style:const TextStyle(color:Colors.black,fontSize: 25, fontWeight: FontWeight.bold),
                                  cursorColor: Colors.black,
                                  decoration: const InputDecoration(
                                    labelText: 'Name of Category',
                                    labelStyle: TextStyle(color:Colors.blue,fontSize: 20,fontWeight: FontWeight.bold),
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
              Card(
                child:InkWell(onTap: ()async{
                  setState(() {
                  name.add('New');
                  imgList.add('');
                  color.add(0);
                  });
                },
                  child: Column(
                    children: [
                      Container(
                        width: 50,
                        height: 60,
                        child:Icon(Icons.add, color: Colors.white, size: 50),
                  color: Colors.blue,
                      ),
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
                      Container(
                        height: 100,
                        padding:EdgeInsets.all(13),
                        child:TextFormField(
                          initialValue: 'new',
                          /*validator: (val){
                            if(val!.isEmpty) {
                              return 'Please Enter Name Of Category';
                            }
                            return null;
                          },*/
                          //onChanged: (val)=>setState((){=val;}),
                          style:const TextStyle(color:Colors.black,fontSize: 25, fontWeight: FontWeight.bold),
                          cursorColor: Colors.black,
                          decoration: const InputDecoration(
                            labelText: 'Name of Category',
                            labelStyle: TextStyle(color:Colors.blue,fontSize: 20,fontWeight: FontWeight.bold),
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
      floatingActionButton: buildNavigateButton(),
    );
  }

  Widget buildNavigateButton()=>FloatingActionButton.extended(
    backgroundColor: Colors.blue,
    onPressed: () {
      final isValid = formkey.currentState!.validate();
      if (isValid == true) {
        for (int i = 0; i < name.length; i++) {
          if (i >= listid.length) {
            if (imgList[i] != '' ) {
              bff.add({"type": name[i], "imagepath": imgList[i]});
            }
          }
          else {
            updateData(i, name, imgList);
          }
        }
        for(int k=0;k<deleteElement.length;k++){
          bff.doc(deleteElement[k]).delete();
        }
      }
    },
    label: Text('Save',style:TextStyle(fontSize: 32)),
  );
}