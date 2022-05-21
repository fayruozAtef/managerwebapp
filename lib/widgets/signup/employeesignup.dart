import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:managerweb/widgets/Background/RegesterBack.dart';
import '../home.dart';
import 'auth.dart';

class EmployeSignUp extends StatelessWidget {
  String ManagerId;
  EmployeSignUp({Key? key,required this.ManagerId});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children:<Widget> [
        const RegesterBack(),
        const SizedBox(height: 200,),
        Container(
          child: Scaffold(
            appBar: AppBar(title: const Text("Add New Waiter", style: TextStyle(fontSize: 25),),),
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
                SignUpEmp(uid: this.ManagerId,),
              ],
            ),
          ),
        ),
      ],
    );


  }
}

class SignUpEmp extends StatefulWidget {
  String uid;
  SignUpEmp({Key? key,required this.uid});

  @override
  _SignUpEmpState createState() => _SignUpEmpState(uid: this.uid);
}

class _SignUpEmpState extends State<SignUpEmp> {
  String uid;
  _SignUpEmpState({Key? key,required this.uid});

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
          'jobtype':_autData['type']='Waiter',
        }).then((value) {
          showAlertDialog(context, " Successfully add a new waiter ${_autData['fname']}  ${_autData['lname']}");
          Timer(const Duration(seconds: 3), () {
            Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context)=>Home(ManagerId: uid,)));
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
    final deviceSize= MediaQuery.of(context).size;
    return Align(
      alignment: Alignment.center,
      child:  SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 100,),

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
                                    decoration: const InputDecoration(
                                        labelText: 'F-name' ,
                                        labelStyle: TextStyle(color: Colors.white),
                                        errorStyle: TextStyle(color: Colors.white,fontSize: 15)),
                                    style:const TextStyle(color: Colors.white,fontSize: 23,),
                                    keyboardType: TextInputType.name,
                                    validator: (value){
                                      _autData['firstname']=value!;
                                      if(value.isEmpty){
                                        return'please enter your first name';
                                      }
                                    },
                                    onSaved: (value) {
                                      _autData['fname']=value!;
                                    },
                                  ),
                                  TextFormField(
                                    decoration:const InputDecoration(
                                        labelText: 'L-name' ,
                                        labelStyle: TextStyle(color: Colors.white),
                                        errorStyle: TextStyle(color: Colors.white,fontSize: 15)),
                                    style: TextStyle(color: Colors.white,fontSize: 23),
                                    keyboardType: TextInputType.name,
                                    validator: (value){
                                      _autData['lastname']=value!;
                                      if(value.isEmpty){
                                        return'please enter your last name';
                                      }
                                    },
                                    onSaved: (value) {
                                      _autData['lname']=value!;
                                    },
                                  ),
                                  TextFormField(
                                    decoration:const InputDecoration(
                                        labelText: 'phone' ,
                                        labelStyle: TextStyle(color: Colors.white),
                                        errorStyle: TextStyle(color: Colors.white,fontSize: 15)),
                                    keyboardType: TextInputType.phone,
                                    style: const TextStyle(color: Colors.white,fontSize: 23),
                                    validator: (value){
                                      _autData['phone']=value!;
                                      if(value.length>11 || value.length<11)
                                      {
                                        return 'Please enter a valid phone number ';
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
                                        errorStyle: TextStyle(color: Colors.white,fontSize: 15)
                                    ),
                                    keyboardType: TextInputType.emailAddress,
                                    style: const TextStyle(color: Colors.white,fontSize: 23),
                                    validator: (value){
                                      if(value!.isEmpty || !value.contains('@') || !value.endsWith('.com')){
                                        return 'Invalid Email! ';
                                      }
                                    },
                                    // controller: email,
                                    onSaved: (value){
                                      _autData['email']=value!;
                                    },
                                  ),
                                  TextFormField(
                                    decoration:const InputDecoration(
                                        labelText: 'password' ,
                                        labelStyle: TextStyle(color: Colors.white),
                                        errorStyle: TextStyle(color: Colors.white,fontSize: 15)),
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
                                      decoration:const InputDecoration(
                                          labelText: 'confirm password' ,
                                          labelStyle: TextStyle(color: Colors.white,fontSize: 23),
                                          errorStyle: TextStyle(color: Colors.white,fontSize: 15)),
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
                                          const Text('SignUp',
                                            style: TextStyle(fontWeight: FontWeight.bold,
                                                fontSize: 30),
                                          ),

                                          onPressed:() {
                                            _signup();
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
      backgroundColor: Colors.white,
      title:const Text("Warning:", style: TextStyle(
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

