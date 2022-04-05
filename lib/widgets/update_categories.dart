import 'dart:typed_data';

import 'package:file_picker/file_picker.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:managerweb/widgets/update_menu.dart';

List<String> imgList=['','','','','','','','',''];
List name=['breakfast','Salads','Appetizers','Soups','Main Dishes','Pasta','Pizza','Drinks','Dessert'];
class Categories extends StatefulWidget {
  Categories({Key? key}) : super(key: key);

  @override
  _CategoriesState createState() => _CategoriesState();
}
class _CategoriesState extends State<Categories> {
  _CategoriesState({Key? key}) ;

  Future<FirebaseApp> secondaryApp = Firebase.initializeApp();
  firebase_storage.FirebaseStorage storage =
  firebase_storage.FirebaseStorage.instanceFor(
      bucket: 'storageBucket: "testfirebaseflutter-aa934.appspot.com",');

  dowurl() async{
    String durl1 = await storage.refFromURL('gs://testfirebaseflutter-aa934.appspot.com/assets/breakfast.jpeg').getDownloadURL();
    String durl2 = await storage.refFromURL('gs://testfirebaseflutter-aa934.appspot.com/assets/salads.jpg').getDownloadURL();
    String durl3 = await storage.refFromURL('gs://testfirebaseflutter-aa934.appspot.com/assets/Appetizers.jpeg').getDownloadURL();
    String durl4 = await storage.refFromURL('gs://testfirebaseflutter-aa934.appspot.com/assets/soup.jpg').getDownloadURL();
    String durl5 = await storage.refFromURL('gs://testfirebaseflutter-aa934.appspot.com/assets/maindish.jpg').getDownloadURL();
    String durl6 = await storage.refFromURL('gs://testfirebaseflutter-aa934.appspot.com/assets/pasta.jpg').getDownloadURL();
    String durl7 = await storage.refFromURL('gs://testfirebaseflutter-aa934.appspot.com/assets/pizza.jpg').getDownloadURL();
    String durl8 = await storage.refFromURL('gs://testfirebaseflutter-aa934.appspot.com/assets/drinks.jpg').getDownloadURL();
    String durl9 = await storage.refFromURL('gs://testfirebaseflutter-aa934.appspot.com/assets/dessert.jpg').getDownloadURL();

    setState((){
      imgList[0]=(durl1);
      imgList[1]=(durl2);
      imgList[2]=(durl3);
      imgList[3]=(durl4);
      imgList[4]=(durl5);
      imgList[5]=(durl6);
      imgList[6]=(durl7);
      imgList[7]=(durl8);
      imgList[8]=(durl9);
    });
  }


  _openPicker(int n) async{
    FilePickerResult? result;
    result=await FilePicker.platform.pickFiles();

    if(result != null) {
      Uint8List? uploadFile = result.files.single.bytes;
      firebase_storage.Reference reference =storage.refFromURL('gs://testfirebaseflutter-aa934.appspot.com/assets').child(name[n]+'.jpeg');
      final firebase_storage.UploadTask uploadTask = reference.putData(uploadFile!);

      uploadTask.whenComplete(() async {
        String image = await uploadTask.snapshot.ref.getDownloadURL();
        setState(() {
          imgList[n] = image;
        });
      });
    }
  }
  @override
  void initState() {
    dowurl();
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
                          child: (imgList[i]!='')?Image.network(imgList[i]) : SizedBox(),
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
                                return 'Please Enter Name Of Item';
                              }
                              return null;
                            },
                            onChanged: (val)=>setState((){name[i]=val;}),
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
                      ],
                    ),
                    ),
                  ),
              FloatingActionButton(
                child: Icon(Icons.add, color: Colors.white, size: 20),
                onPressed: () async{
                  setState(() {
                    name.add('new name');
                    imgList.add('');
                  });
                },
                backgroundColor: Colors.teal,
                mini: false,
              ),
            ],
        ),
      ),
      ),
      floatingActionButton: buildNavigateButton(),
    );
  }
  Widget buildNavigateButton()=>FloatingActionButton.extended(
    backgroundColor: Colors.teal,
    onPressed: (){

      },
    label: Text('Save',style:TextStyle(fontSize: 32)),
  );
}