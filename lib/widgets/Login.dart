import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:managerweb/widgets/home.dart';
import 'Background/backWithOpacity.dart';
import 'forgetpassword.dart';
import 'signup/auth.dart';

class Loginmanager extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Stack(
      children:<Widget> [
        const BackWithOpacity(),
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
            backgroundColor: Colors.transparent,
            body: Stack(
              children:const[
                SingleChildScrollView(
                  child: LogIn(),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
class LogIn extends StatefulWidget {
  const LogIn({
    Key ? key,
  }) : super(key: key);

  @override
  _LogInState createState() => _LogInState();
}
class _LogInState extends State<LogIn> {
  final GlobalKey<FormState>_formKey=GlobalKey();
  CollectionReference gettype = FirebaseFirestore.instance.collection("employee");
  String type="";
  Map<String, String> _autData={
    'email':'' ,
    'password':'' ,
  };

  /////////log in function//////////////////
  Future<void>_logIn()async{

    if(_formKey.currentState!.validate()){

      _formKey.currentState!.save() ;
      QuerySnapshot dbt = await gettype.where("email",isEqualTo: _autData['email']).get();
      dbt.docs.forEach((element) {
        setState(() {
          type = element.get('jobtype');
        });
      });
      //true login
      if(type=="manager") {
        await FirebaseAuth.instance.signInWithEmailAndPassword(
            email: _autData['email']!,
            password: _autData['password']!
        ).then((value) {
          print("Successfull");
          String id = Auth().getId();
          Navigator.of(context).pushReplacement(
              MaterialPageRoute(builder: (context) => Home()));
        }).catchError((e) {
          if (e.code == 'user-not-found') {
            showAlertDialog(context, 'No user found for that email.');
          } else if (e.code == 'wrong-password') {
            showAlertDialog(context, 'Wrong password');
          }
        });
      }else{
        showAlertDialog(context, "Wrong Email address");
      }
    }
  }

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
                        decoration:const InputDecoration (
                          labelText: 'E-Mail' ,
                          labelStyle: TextStyle(color: Colors.white),
                          errorStyle:TextStyle(color: Colors.white,fontSize: 15)
                        ),
                        keyboardType: TextInputType.emailAddress,
                        style:const TextStyle(color: Colors.white,fontSize: 25,),
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
                      const Padding(padding: EdgeInsets.only(top: 40),),
                      TextFormField(
                        decoration:const InputDecoration(
                            labelText: 'password' ,
                            labelStyle: TextStyle(color: Colors.white),
                            errorStyle:TextStyle(color: Colors.white,fontSize: 15)
                        ),
                        obscureText: true,
                        style:const TextStyle(color: Colors.white,fontSize: 25,),
                        validator: (value){
                          if(value!.isEmpty){
                            return 'Enter password';
                          }
                        },
                        onSaved: (value) {
                          _autData['password']=value!;
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
                 const Text('LOGIN',
                    style: TextStyle(fontWeight: FontWeight.bold,
                        fontSize: 30),
                  ),

                  onPressed:() {
                    _logIn();
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
          //SizedBox(height: 15,),
          FlatButton(
            child: Text(
              'Forget Password ',
              style: TextStyle(fontSize: 30),
            ),
            onPressed: (){
              Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => Password()));
            } ,
            //padding: const EdgeInsets.symmetric(horizontal: 30.0,vertical: 4),
            materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
            textColor: Colors.white,
          ),

        ],
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