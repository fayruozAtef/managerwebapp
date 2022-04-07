
import 'dart:io';
import 'dart:typed_data';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:uuid/uuid.dart';
class Uploadimage extends StatefulWidget {
  //final String userId;
  const Uploadimage({Key? key, }) : super(key: key);

  @override
  _imagepic createState() => _imagepic();
}

class _imagepic extends State<Uploadimage> {
  final ImagePicker _picker = ImagePicker();
  String _group="";
  List imagelist=[];
  final number =TextEditingController();
  final seats =TextEditingController();
  num tableno=0;
  num seatsno=0;
  num nochange=0;
  List input=[];
  CollectionReference gettable = FirebaseFirestore.instance.collection("tryimage");
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
          for(int i=0; i<uploadFile.length;i++){
          imagelist[i]=image.toString();
          }
        });
      });
    }
  }

  photo()async{
    await gettable.doc('$tableno').update({
      "image":imagelist
    });
  }

  changetable() async {

     /* if(seats.text==''){
        QuerySnapshot dbt = await gettable.where("num",isEqualTo: tableno).get();
        dbt.docs.forEach((element) {
          setState(() {
            nochange=element.get('no-of-sets');
          });
        });
        await gettable.doc('$tableno').update({
          "no-of-sets":nochange
        });
      }else{*/
        await gettable.doc('$tableno').update({
          "no-of-sets":seatsno
        });

      await gettable.doc('$tableno').update({
        "location":_group
      });

    }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          SizedBox(height: 30,),
          ////Table no
          Container(
              child: Row(
                children: [
                  buildText("Enter Table Number"),
                  Text("**",style: TextStyle(color:Colors.red,fontSize:22 ),)
                ],
              )
          ),
          Container(
            padding: EdgeInsets.fromLTRB(15.0, 10, 500, 0),
            child: buildtableno(),
          ),
          SizedBox(height: 30,),
          buildText("Enter Number of Seats"),
          Container(
            padding: EdgeInsets.fromLTRB(15.0, 10, 500, 0),
            child: buildnoseat(),
          ),
          SizedBox(height: 30,),

          ////Location
          Container(
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
                      child: Text('Upload Image',
                        style: TextStyle(fontWeight: FontWeight.bold,
                            fontSize: 30),
                      ),
                      onPressed:() {
                        _openPicker();
                      },


                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                      padding: EdgeInsets.symmetric(horizontal: 40.0,vertical: 8.0),
                      color: Color.fromRGBO(65, 189, 180, 54),
                    ),
                  ),
                ),
                const SizedBox(width: 50,),
                Container(
                  child: ButtonTheme(
                    minWidth: 100.0,
                    height: 50.0,
                    child: RaisedButton(
                      child: Text('Delete Images',
                        style: TextStyle(fontWeight: FontWeight.bold,
                            fontSize: 30),
                      ),
                      onPressed:() {
                        imagelist.clear();
                      },
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                      padding: EdgeInsets.symmetric(horizontal: 40.0,vertical: 8.0),
                      color: Color.fromRGBO(65, 189, 180, 54),
                    ),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 30,),
          Expanded(
            child: GridView.builder(
                itemCount: imagelist.length,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount:4),
                itemBuilder: (BuildContext context,int index){
                  return Image.network(File(imagelist[index]).path,
                  fit: BoxFit.cover,);
                }),
          ),

          /////Change Button
          Container(
            height: 120,
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
                        fontSize: 30),
                  ),
                  onPressed:() {
                    setState(() {
                      tableno=int.parse(number.text) ;
                      seatsno=int.parse(seats.text) ;
                      changetable();
                      photo();
                    });

                  },
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                  padding: EdgeInsets.symmetric(horizontal: 40.0,vertical: 8.0),
                  color: Color.fromRGBO(65, 189, 180, 54),
                ),
              ),
            ),
          ),
        ],
      ) ,
    );
  }
  /*Future<void> selectimage() async {
    final List<XFile>? select = await _picker.pickMultiImage();
    if(select!.isNotEmpty){
      imagelist.addAll(select);
    }
    print("list l:"+imagelist.length.toString());
    setState(() {
    });
  }*/
  Widget buildText(String text)=>Container(
    padding: EdgeInsets.fromLTRB(10.0,10.0,0,5),
    child: Text(
      text,
      style: TextStyle(fontWeight: FontWeight.bold,fontSize: 20),
    ),
  );
  Widget buildnoseat() =>Material(
    child:   TextField(

      controller: seats,
      keyboardType: TextInputType.number,
      decoration:  InputDecoration(
        hintText: 'Number of seats',
        border: OutlineInputBorder(
          borderRadius:  BorderRadius.circular(12.0),
        ),

      ),
    ),
  );

  Widget buildtableno() =>Material(
    child:   TextField(
      controller: number,
      keyboardType: TextInputType.number,
      decoration:  InputDecoration(
        hintText: 'Enter Table no',
        border: OutlineInputBorder(
          borderRadius:  BorderRadius.circular(12.0),
        ),

      ),
    ),
  );
  Widget buildlocation() =>Material(
    child:   Row(
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
          Text('In Door',style:TextStyle(fontSize: 22)),
          const SizedBox(width: 50,),
          Radio<String>(value: 'Out Door',
            groupValue: _group ,
            onChanged: (value) {
              setState((){
                _group=value!;
              });
            },
          ),
          Text('Out Door',style:TextStyle(fontSize: 22))
        ]
    ),
  );

}