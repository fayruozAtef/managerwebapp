import 'dart:html';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../Background/backWithOpacity.dart';
import '../qr_create_page.dart';
import 'auth.dart';
final List<Map<String, dynamic>> _menuItem = [
  {
    "title": "Manager",
    "selected": false,
  },
  {
    "title": "Waiter",
    "selected": true,
  },

];
class signupmanager extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Stack(
      children:<Widget> [
        const BackWithOpacity(),
        const SizedBox(height: 200,),
        Container(
          child: Scaffold(
            appBar: AppBar(title: const Text("Add New Manager", style: TextStyle(fontSize: 30),),),
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
                  SizedBox(height: 50,),
                  AuthCard(),
                ],
              ),
            ),
          ),
      ],
    );


  }

}

class AuthCard extends StatefulWidget {
  const AuthCard({
    Key ? key,
  }) : super(key: key);

  @override
  _AuthCardState createState() => _AuthCardState();
}
class _AuthCardState extends State<AuthCard> {
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
      UserCredential userCredential ;
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
          'jobtype':_autData['type']=='M'? 'manager':'Waiter',
        }).then((value) {
          Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context)=>QRCreatePage()));
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
    final deviceSize= MediaQuery.of(context).size;
    return Align(
        alignment: Alignment.center,
        child:  SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(height: 130,),

              const SizedBox(height: 10.0,),
              SizedBox(
                height: 60,
                width:( MediaQuery. of(context). size. width )-300,
                child: Center(
                  child: Row(
                      children:[
                        Radio<String>(
                          value: 'M',
                          groupValue: _autData['type'],
                          onChanged: (value) {
                            setState((){
                              _autData['type']=value!;
                            });
                          },
                        ),
                        Text('Manager',style:TextStyle(color:Colors.white,fontSize: 22)),
                        const SizedBox(width: 50,),
                        Radio<String>(value: 'W',
                          groupValue: _autData['type'],
                          onChanged: (value) {
                            setState((){
                              _autData['type']=value!;
                            });
                          },
                        ),
                        Text('Waiter',style:TextStyle(color:Colors.white,fontSize: 22))
                      ]
                  ),

                ),
              ),
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
                                      decoration: const InputDecoration(labelText: 'F-name' ,labelStyle: TextStyle(color: Colors.white)),
                                      style:const TextStyle(color: Colors.white,fontSize: 23,),
                                      keyboardType: TextInputType.name,
                                      validator: (value){
                                        _autData['firstname']=value!;
                                      },
                                      onSaved: (value) {
                                        _autData['fname']=value!;
                                      },
                                    ),
                                    TextFormField(
                                      decoration:const InputDecoration(labelText: 'L-name' ,labelStyle: TextStyle(color: Colors.white)),
                                      style: TextStyle(color: Colors.white,fontSize: 23),
                                      keyboardType: TextInputType.name,
                                      validator: (value){
                                        _autData['lastname']=value!;
                                      },
                                      onSaved: (value) {
                                        _autData['lname']=value!;
                                      },
                                    ),
                                    TextFormField(
                                      decoration:const InputDecoration(labelText: 'phone' ,labelStyle: TextStyle(color: Colors.white)),
                                      keyboardType: TextInputType.phone,
                                      style: const TextStyle(color: Colors.white,fontSize: 23),
                                      validator: (value){
                                        _autData['phone']=value!;
                                      },
                                      onSaved: (value) {
                                        _autData['phone']=value!;
                                      },
                                    ),
                                    TextFormField(
                                      decoration:const InputDecoration (
                                        labelText: 'E-Mail' ,
                                        labelStyle: TextStyle(color: Colors.white),
                                      ),
                                      keyboardType: TextInputType.emailAddress,
                                      style: const TextStyle(color: Colors.white,fontSize: 23),
                                      validator: (value){
                                        if(value!.isEmpty || !value.contains('@')){
                                          return 'Invalid Email! ';
                                        }
                                      },
                                      // controller: email,
                                      onSaved: (value){
                                        _autData['email']=value!;
                                      },
                                    ),
                                    TextFormField(
                                      decoration:const InputDecoration(labelText: 'password' ,labelStyle: TextStyle(color: Colors.white)),
                                      obscureText: true,
                                      style: const TextStyle(color: Colors.white,fontSize: 23),
                                      controller: _passwordController,
                                      validator: (value){
                                        if(value!.isEmpty){
                                          return 'enter password';
                                        }
                                        else if(value.length <5){
                                          return 'password is too short!';
                                        }
                                        return null;
                                      },
                                      onSaved: (value) {
                                        _autData['password']=value!;
                                      },
                                    ),
                                    TextFormField(
                                        decoration:const InputDecoration(labelText: 'confirm password' ,
                                            labelStyle: TextStyle(color: Colors.white,fontSize: 23)),
                                        style:const TextStyle(color: Colors.white,fontSize: 23),
                                        obscureText: true,
                                        validator: (value) {
                                          if(value !=_passwordController.text){
                                            return 'passwords do not match!' ;
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
                                      child: RaisedButton(
                                        child:
                                        const Text('SIGN UP',
                                          style: TextStyle(fontSize: 25),
                                        ),
                                        onPressed:() {
                                          _signup();
                                        },
                                        padding: const EdgeInsets.symmetric(horizontal: 40.0,vertical: 8.0),
                                        color:const  Color.fromRGBO(65, 189, 180, 54),
                                        textColor: Colors.white,
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