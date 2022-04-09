import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';


class payment extends StatefulWidget {

  payment({Key? key}) : super(key: key);

  @override
  createState(){
    return _payment();
  }
}


class _payment extends State<payment> {

  _payment({Key? key}) : super();

  List<String> days=['1','2','3','4','5','6','7','8','9','10','11','12','13','14','15','16','17','18','19','20','21','22','23','24','25',
    '26','27','28','29','30','31'];
  List<String> months=['1','2','3','4','5','6','7','8','9','10','11','12'];
  String? selectedItem;
  String? selectedItem2;


  String formattedDate(timeStamp){
    var dateFormTimeStamp=DateTime.fromMillisecondsSinceEpoch(timeStamp.seconds*1000);
    return DateFormat('d-M-yyy').format(dateFormTimeStamp);
  }

  List orders=[];
  int total=0;

  String getSum(int n) {
    double sum = 0;
    for (var i in orders[n].values) {
        sum += double.parse(i[2]);
      }
    return (sum+50).toString();
  }

  @override
  void initState() {

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    for(int i=0;i<orders.length;i++){
      total+=int.parse(getSum(i));
    }

    return Scaffold(
      appBar: AppBar(
        title:const Text('Total Payment', style: TextStyle(color: Colors.white, fontSize: 30,)),
        //backgroundColor: Colors.black,
      ),
      body:SingleChildScrollView(
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children:[
                Container(
                  padding:EdgeInsets.fromLTRB(0, 15, 0, 20),
                  width: 500,
                  child:DropdownButton<String>(
                    value: selectedItem,
                    items: days.map((e) => DropdownMenuItem<String>(
                      value: e,
                      child: Text(e,style:TextStyle(fontSize: 25)),
                    )).toList(),
                    onChanged: (e)=>setState(() {
                      selectedItem=e;
                    }),
                    hint:Text('Select The Day',style:TextStyle(fontSize: 18,fontWeight: FontWeight.bold)),
                    icon:Icon(Icons.arrow_drop_down_circle),
                    iconEnabledColor:Colors.teal,
                    isExpanded: true,
                  ),
                ),
                Container(
                  width: 500,
                  padding:EdgeInsets.fromLTRB(0, 15, 0, 20),
                  child:DropdownButton<String>(
                    value: selectedItem2,
                    items: months.map((e) => DropdownMenuItem<String>(
                      value: e,
                      child: Text(e,style:TextStyle(fontSize: 25)),
                    )).toList(),
                    onChanged: (e)=>setState(() {
                      selectedItem2=e;
                    }),
                    hint:Text('Select The Month',style:TextStyle(fontSize: 18,fontWeight: FontWeight.bold),),
                    icon:Icon(Icons.arrow_drop_down_circle),
                    iconEnabledColor:Colors.teal,
                    isExpanded: true,
                  ),
                ),
              ],
            ),
            Padding(padding: const EdgeInsets.fromLTRB(0, 13, 0, 13),
              child:ElevatedButton(
                style:ButtonStyle(backgroundColor:MaterialStateProperty.all<Color>(Colors.teal),
                    fixedSize:MaterialStateProperty.all(Size(320,50)),
                    shape:MaterialStateProperty.all<RoundedRectangleBorder>(RoundedRectangleBorder(
                        borderRadius:BorderRadius.circular(18)
                    ))
                ),
                onPressed: () async{
                  CollectionReference bff = FirebaseFirestore.instance.collection("delivery");
                  QuerySnapshot db = await bff.get();
                    db.docs.forEach((element) {
                      setState(() {
                        if(formattedDate(element.get('date'))==(selectedItem!+'-'+selectedItem2!+'-'+'2022')){
                          orders.add(element.get('order'));
                        }
                      });
                      print(formattedDate(element.get('date')));
                    });


                 /* Navigator.of(context).push(
                      MaterialPageRoute(
                          builder: (context) =>));*/
                  //  }
                },
                child: Text('Show Result',style:TextStyle(fontSize: 32)),
              ),
            ),
            Card(
              child:Column(
                children: [
                  Row(
                    children: [
                      Container(
                        padding: EdgeInsets.fromLTRB(8,0,0,5),
                        width: 150,
                        child:Text('Order#',style: TextStyle(fontWeight: FontWeight.bold, color: Colors.teal, fontSize: 30,)),
                      ),
                      Container(
                        width: 110,
                        child:
                        Text('Price',style: TextStyle(fontWeight: FontWeight.bold, color: Colors.teal, fontSize: 30,)),
                      ),
                    ],
                  ),
                  Text('-------------------------------',style: TextStyle(fontWeight: FontWeight.bold, color: Colors.teal, fontSize: 30,)),
                  for(int i=0;i<orders.length;i++)
                      Row(
                        children: [
                          Container(
                            padding: EdgeInsets.fromLTRB(8,0,0,5),
                            width: 150,
                            child:Text("order${i}",style: TextStyle( color: Colors.black, fontSize: 25,)),
                          ),
                          Container(
                            width: 110,
                            child:Text(getSum(i),style: TextStyle( color: Colors.black, fontSize: 25,)),
                          ),
                        ],
                      ),
                  Text('-------------------------------',style: TextStyle(fontWeight: FontWeight.bold, color: Colors.teal, fontSize: 30,)),
                  Row(
                    children:[
                      Container(
                        width: 150,
                        padding: EdgeInsets.fromLTRB(8,0,0,5),
                        child: Text('Total',style:TextStyle(fontWeight: FontWeight.bold, color: Colors.teal, fontSize: 30,)),
                      ),
                      Container(
                        width: 110,
                        child: Text(total.toString(),style: TextStyle( color: Colors.black, fontSize: 28,)),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}