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
        backgroundColor: Colors.black,
        automaticallyImplyLeading: false,
      ),
      body:SingleChildScrollView(
       child:Form(
       key:formkey,
        child: Column(
            children: [
             for(int i=0;i<name.length;i++)
                Card(
                  child:InkWell(onTap: (){
                    Navigator.of(context).pushReplacement(
                        MaterialPageRoute(builder: (context)=>details(title: name[i])));
                  },
                    child: Column(
                      children: [
                        Container(
                          child: (imgList[i]!='')?Image.network(imgList[i]) : SizedBox(height: 100,width: 100,),
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
                              labelStyle: TextStyle(color:Colors.teal,fontSize: 20,fontWeight: FontWeight.bold),
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
              Card(
                child:InkWell(onTap: ()async{
                  setState(() {
                  name.add('new category');
                  imgList.add('');
                  });
                },
                  child: Column(
                    children: [
                      Container(
                        width: 50,
                        height: 60,
                        child:Icon(Icons.add, color: Colors.white, size: 50),
                  color: Colors.teal,
                      ),
                      Container(
                        width: 100,
                        height: 100,

                        color: Colors.white,
                      ),
                      FloatingActionButton(
                        child: Icon(Icons.camera_alt, color: Colors.white, size: 20),
                        backgroundColor: Colors.teal,
                        mini: true,
                        onPressed:(){

                        },
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
                            labelStyle: TextStyle(color:Colors.teal,fontSize: 20,fontWeight: FontWeight.bold),
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
      //floatingActionButton: buildNavigateButton(),
      persistentFooterButtons: [
        Column(
         children: [
            //buildNavigateButton2(),
            SizedBox(height: 10,),
            buildNavigateButton(),
          ],
        ),
      ],
    );
  }
  /*Widget buildNavigateButton2()=>FloatingActionButton(
  child: Icon(Icons.add, color: Colors.white, size: 20),
  onPressed: () async{
  setState(() {
  name.add('new category');
  imgList.add('');
  });
},
backgroundColor: Colors.teal,
mini: false,
);*/
  Widget buildNavigateButton()=>FloatingActionButton.extended(
    backgroundColor: Colors.teal,
    onPressed: () {
      final isValid = formkey.currentState!.validate();
      if (isValid == true) {
        for (int i = 0; i < name.length; i++) {
          if (i >= listid.length) {
            if (imgList[i] != '' || name[i]!='new category') {
              bff.add({"type": name[i], "imagepath": imgList[i]});
            }
          }
          else {
            updateData(i, name, imgList);
          }
        }
      }
    },
    label: Text('Save',style:TextStyle(fontSize: 32)),
  );
}