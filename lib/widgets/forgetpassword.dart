import 'dart:async';
import 'dart:ui';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'Background/backWithOpacity.dart';
import 'login.dart';
enum AuthMode{ Signup , Login }

class Password extends StatelessWidget {
  static const routeName='/auth';
  //const AuthScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children:<Widget> [
        const BackWithOpacity(),
       // SizedBox(height: 200),
        Container(
          padding: const EdgeInsets.all(20.0),
          height: 150,
          width: 150,
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/images/logo.png'),
              opacity: 0.6,
              fit: BoxFit.cover,
            ),
          ),
        ),
        Container(
          child: Scaffold(
            appBar: AppBar(title: const Text("Add New Waiter", style: TextStyle(fontSize: 25),),),
            backgroundColor: Colors.transparent,
            body: Stack(
              children:const[
                SingleChildScrollView(
                  child: ForgetPAssword(),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}


class ForgetPAssword extends StatefulWidget {
  const ForgetPAssword({
    Key ? key,
  }) : super(key: key);

  @override
  _ForgetPAsswordState createState() => _ForgetPAsswordState();
}

class _ForgetPAsswordState extends State<ForgetPAssword> {
  final GlobalKey<FormState>_formKey=GlobalKey();
  final emailcontroller=TextEditingController();
  CollectionReference gettype = FirebaseFirestore.instance.collection("employee");
  String type="";
  Map<String, String> _autData={
    'email':'' ,
  };

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.center,
      child: Column(
        children: [
          const Padding(padding: EdgeInsets.only(top: 110),),
          Container(
            child: SingleChildScrollView(
              child:SizedBox(
                width:( MediaQuery. of(context). size. width )-300,
                child:  Form(
                  key: _formKey,
                  child:Column(
                    children: [
                      const SizedBox(
                        height: 80,
                        child: Center(
                          child: Text('Welcome', style: TextStyle(color: Colors.white,fontSize: 70,fontFamily:'Time New Roman'),textAlign:TextAlign.center),
                        ),
                      ),
                      TextFormField(
                        controller: emailcontroller,
                        decoration:const InputDecoration (
                            labelText: 'E-Mail' ,
                            labelStyle: TextStyle(color: Colors.white),
                            errorStyle: TextStyle(color: Colors.red,fontSize: 15)),
                        keyboardType: TextInputType.emailAddress,
                        style: const TextStyle(color: Colors.white,fontSize: 23),
                        validator: (value){
                          if(value!.isEmpty || !value.contains('@')){
                            return 'invalid email! ';
                          }
                        },
                        // controller: email,
                        onSaved: (value){
                          _autData['email']=value!;
                        },
                      ),
                    ],
                  ),

                ),
              ),

            ),
          ),
          Padding(padding: EdgeInsets.only(top: 40),),
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
                  const Text('Reset Password',
                    style: TextStyle(fontWeight: FontWeight.bold,
                        fontSize: 30),
                  ),
                  onPressed:() {
                    resetpassword();
                  },
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                  padding:const EdgeInsets.symmetric(horizontal: 40.0,vertical: 8.0),
                  color: Colors.blue,
                  //color: Color.fromRGBO(65, 189, 180, 54),
                  textColor: Colors.white,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
  Future resetpassword() async{
    if(_formKey.currentState!.validate()){
      _formKey.currentState!.save() ;
      try{
        await FirebaseAuth.instance.sendPasswordResetEmail(
            email: emailcontroller.text.trim()).then((value) =>{
          showAlertDialog(context, "Password Reset Email Sent"),
          Timer(const Duration(seconds: 3), () {
            Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context)=>Loginmanager()));
          }),
        });
      }on FirebaseException catch(e){
        if(e.code=="The email address is badly formatted")
        {
          showAlertDialog(context, "your mail is not valid please enter the right one");
        }

      }

    }
  }
  showAlertDialog(BuildContext context,String message) {

    // set up the AlertDialog
    AlertDialog alert =  AlertDialog(
      backgroundColor: Colors.white54,
      title:const Text("Message:", style: TextStyle(
        fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black,
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


