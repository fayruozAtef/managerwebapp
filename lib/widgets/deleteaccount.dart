import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'back.dart';
class deletePage extends StatelessWidget {
  static const routeName='/auth';
  //const AuthScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final deviceSize= MediaQuery.of(context).size;
    return Container(
      //padding: EdgeInsets.all(20.0),
      child:  Stack(
        children:<Widget> [
          Scaffold(
            //resizeToAvoidBottomInset: false,
            backgroundColor: Colors.black26,
            body: Stack(
              children: const <Widget>[
                DeleteUSer(),
              ],
            ),
          ),
        ],
      ),
    );


  }
}

class DeleteUSer extends StatefulWidget {
  const DeleteUSer({Key? key}) : super(key: key);

  @override
  _DeleteUSerState createState() => _DeleteUSerState();
}

class _DeleteUSerState extends State<DeleteUSer> {
  final GlobalKey<FormState>_formKey=GlobalKey();
  final _emailController =TextEditingController();
  Future<void> onsearch() async {
    try {

      FirebaseFirestore _db = FirebaseFirestore.instance;
      await _db.collection('employee').where("email",isEqualTo: 'Randa@gmail.com');

    } catch (e) {
      print(e.toString());
      return null;
    }
  }
  void search()async{
    FirebaseFirestore _firestore=FirebaseFirestore.instance;
    QuerySnapshot t=await _firestore.collection('employee').where("email",isEqualTo: 'Randa@gmail.com').get();
    t.docs.forEach((element) {
      print(element.get('first name'));
    });
  }
  @override
  Widget build(BuildContext context) {
    final deviceSize= MediaQuery.of(context).size;
    return Stack(
        children:[
          Container(
            padding: EdgeInsets.all(20.0),
            child: Form(
              key: _formKey,
              child: SingleChildScrollView(
                child: Column(
                  children: <Widget>[
                    const SizedBox(height: 50.0,),
                    const Text('Delete Email', style: TextStyle(color: Colors.cyan,fontSize: 40,fontFamily:'Time New Roman'),textAlign:TextAlign.center),
                    const SizedBox(height: 50,),

                    ////////////////////////////////////////////
                    TextFormField(
                      decoration:const InputDecoration (
                        labelText: 'Deleted E-Mail' ,
                        labelStyle: TextStyle(color: Colors.black, fontSize: 20.0),
                      ),
                      keyboardType: TextInputType.emailAddress,
                      style: TextStyle(color: Colors.black),
                      validator: (value){
                        if(value!.isEmpty || !value.contains('@')){
                          return 'Invalid Email! ';
                        }
                      },
                      // controller: email,
                      controller: _emailController,
                    ),
                Container(
                  width: 250,
                  height: 50,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),

                  ),
                  child: RaisedButton(
                    child:
                    const Text('SIGN UP',
                      style: TextStyle(fontSize: 25),
                    ),
                    onPressed:() {
                      search();
                    },
                    padding: const EdgeInsets.symmetric(horizontal: 40.0,vertical: 8.0),
                    color:const  Color.fromRGBO(65, 189, 180, 54),
                    textColor: Colors.white,
                  ),)
                  ],
                ),
              ),
            ),
          ),
        ]

    );
  }
}
