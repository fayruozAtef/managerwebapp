import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:managerweb/widgets/home.dart';
import '../Background/RegesterBack.dart';
import '../Background/backWithOpacity.dart';
import 'auth.dart';
class signupmanager extends StatelessWidget {
  String uid;
  signupmanager({Key? key,required this.uid});
  @override
  Widget build(BuildContext context) {
    return Stack(
      children:<Widget> [
        RegesterBack(),
        const SizedBox(height: 200,),
        Container(
          child: Scaffold(
            appBar: AppBar(title: const Text("Add New Manager", style: TextStyle(color: Colors.white, fontSize: 30,)),),
            backgroundColor: Colors.transparent,
            body: Stack(
                children:[
                  Container(
                    padding: EdgeInsets.all(20.0),
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
                  AuthCard(uid: this.uid,),
                ],
              ),
            ),
          ),
      ],
    );


  }

}

class AuthCard extends StatefulWidget {
  String uid;
  AuthCard({Key? key,required this.uid});

  @override
  _AuthCardState createState() => _AuthCardState(uid: this.uid);
}
class _AuthCardState extends State<AuthCard> {
  String uid;
  _AuthCardState({Key? key,required this.uid});

  final GlobalKey<FormState>_formKey=GlobalKey();
  TextEditingController email = TextEditingController();
  Map<String, String> _autData={
    'email':'' ,
    'password':'' ,
    'fname':'',
    'lname':'',
    'phone':'',
    'type':'',
  };
  final _passwordController =TextEditingController();

  ///////sign up function/////////

  Future<void>_signup()async{

    if(_formKey.currentState!.validate()){

      _formKey.currentState!.save() ;
      //true signup
      //to make user authentication
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: _autData['email']!,
          password: _autData['password']!
      ).then((value){
        Auth auth  = Auth();
        auth.saveData({
          'first name': _autData['fname'], // John Doe
          'last name': _autData['lname'], // Stokes and Sons
          'phone': _autData['phone'] ,
          'email':_autData['email'],
          'jobtype':_autData['type']= 'manager',
        }).then((value) {
          showAlertDialog(context, " Successfully add a new manager ${_autData['fname']}  ${_autData['lname']}"); 
          Timer(const Duration(seconds: 3), () {
            Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context)=>Home()));
          });
        });

      }).catchError((e){
        if (e.code == 'weak-password') {
          print('The password provided is too weak.');
          showAlertDialog(context, 'The password provided is too weak.');
        } else if (e.code == 'email-already-in-use') {
          print('The account already exists for that email.');

          showAlertDialog(context, 'The account already exists for that email.');


        }
      });
    }

  }


  @override
  Widget build(BuildContext context) {
    return Align(
        alignment: Alignment.center,
        child:  SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(height: 70,),
              SizedBox(
                width:( MediaQuery. of(context). size. width )-300,
                child: Column(
                    children:[
                      Stack(
                          children: [
                            Container(
                              padding: EdgeInsets.all(10.0),
                              child: Form(
                                key: _formKey,
                                child: Column(
                                  children: <Widget>[

                                    const SizedBox(height: 10,),
                                    TextFormField(
                                      decoration: const InputDecoration(labelText: 'F-name' ,labelStyle: TextStyle(color: Colors.white),errorStyle: TextStyle(color: Colors.white,fontSize: 15)),
                                      style:const TextStyle(color: Colors.white,fontSize: 25,),
                                      keyboardType: TextInputType.name,
                                      validator: (value){
                                        if(value!.isEmpty){
                                          return '**Enter first name**';
                                        }
                                      },
                                      onSaved: (value) {
                                        _autData['fname']=value!;
                                      },
                                    ),
                                    TextFormField(
                                      decoration:const InputDecoration(labelText: 'L-name' ,labelStyle: TextStyle(color: Colors.white),errorStyle: TextStyle(color: Colors.white,fontSize: 15)),
                                      style: TextStyle(color: Colors.white,fontSize: 23),
                                      keyboardType: TextInputType.name,
                                      validator: (value){
                                        if(value!.isEmpty){
                                          return '**Enter last name**';
                                        }
                                      },
                                      onSaved: (value) {
                                        _autData['lname']=value!;
                                      },
                                    ),
                                    TextFormField(
                                      decoration:const InputDecoration(labelText: 'phone' ,labelStyle: TextStyle(color: Colors.white),errorStyle: TextStyle(color: Colors.white,fontSize: 15)),
                                      keyboardType: TextInputType.phone,
                                      style: const TextStyle(color: Colors.white,fontSize: 23),
                                      validator: (value){
                                        if(value!.isEmpty){
                                          return '**Enter phone number**';
                                        }
                                        else if(value.length!=11){
                                          return '**Enter correct phone number**';
                                        }
                                      },
                                      onSaved: (value) {
                                        _autData['phone']=value!;
                                      },
                                    ),
                                    TextFormField(
                                      decoration:const InputDecoration (
                                        labelText: 'E-Mail' ,
                                        labelStyle: TextStyle(color: Colors.white),
                                        errorStyle: TextStyle(color: Colors.white,fontSize: 15)),
                                      keyboardType: TextInputType.emailAddress,
                                      style: const TextStyle(color: Colors.white,fontSize: 23),
                                      validator: (value){
                                        if(value!.isEmpty || !value.contains('@') || !value.endsWith(".com")){
                                          return '**Invalid Email! ';
                                        }
                                      },
                                      // controller: email,
                                      onSaved: (value){
                                        _autData['email']=value!;
                                      },
                                    ),
                                    TextFormField(
                                      decoration:const InputDecoration(labelText: 'password' ,labelStyle: TextStyle(color: Colors.white),errorStyle: TextStyle(color: Colors.white,fontSize: 15)),
                                      obscureText: true,
                                      style: const TextStyle(color: Colors.white,fontSize: 23),
                                      controller: _passwordController,
                                      validator: (value){
                                        if(value!.isEmpty){
                                          return '**enter password**';
                                        }
                                        else if(value.length <5){
                                          return '**password is too short!**';
                                        }
                                        return null;
                                      },
                                      onSaved: (value) {
                                        _autData['password']=value!;
                                      },
                                    ),
                                    TextFormField(
                                        decoration:const InputDecoration(labelText: 'confirm password' ,
                                            labelStyle: TextStyle(color: Colors.white,fontSize: 23),errorStyle: TextStyle(color: Colors.white,fontSize: 15)),
                                        style:const TextStyle(color: Colors.white,fontSize: 23),
                                        obscureText: true,
                                        validator: (value) {
                                          if(value !=_passwordController.text){
                                            return '**passwords do not match!**' ;
                                          }
                                          return null;
                                        }
                                    ),
                                    const SizedBox(height: 20,),
                                    Container(
                                      width: 250,
                                      height: 50,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(10),

                                      ),
                                      child:FloatingActionButton.extended(
                                        backgroundColor: Theme.of(context).primaryColor,
                                        label:const Text("SIGN UP", style: TextStyle(fontSize: 35,fontWeight: FontWeight.bold),),
                                        onPressed: () => setState(() {
                                          _signup();
                                        }),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ]
                      ),

                    ]
                ),
              ),
            ],
          ),
        ),
      );
  }

  showAlertDialog(BuildContext context,String message) {

    // set up the AlertDialog
    AlertDialog alert =  AlertDialog(
      backgroundColor: Colors.white54,
      title:const Text("Warning:", style: TextStyle(
        fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white,
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