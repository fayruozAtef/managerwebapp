import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';

class payment2 extends StatefulWidget {

  payment2({Key? key}) : super(key: key);

  @override
  createState(){
    return _payment();
  }
}
class _payment extends State<payment2> {

  @override
  DateTime? _dateTime;
  DateTime intial=DateTime.now();
DateTimeRange _dateTimeRange=DateTimeRange(
    start: DateTime.now(),
    end:DateTime.now().add(Duration(days: 2))
);

  List orders=[];
  int total=0;

  String formattedDate(timeStamp){
    var dateFormTimeStamp=DateTime.fromMillisecondsSinceEpoch(timeStamp.seconds*1000);
    return DateFormat('d-M-yyy').format(dateFormTimeStamp);
  }

  String getSum(int n) {
    double sum = 0;
    for (var i in orders[n].values) {
      sum += double.parse(i[2]);
    }
    return (sum+50).toString();
  }

  @override
  Widget build(BuildContext context) {
    var start=_dateTimeRange.start;
    var end=_dateTimeRange.end;

    for(int i=0;i<orders.length;i++){
      total+=int.parse(getSum(i));
    }
    return Scaffold(
      appBar: AppBar(
        title: Text('Total Payment',
            style: TextStyle(color: Colors.white, fontSize: 40,)),
        backgroundColor: Colors.black,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(padding: EdgeInsets.fromLTRB(0, 8, 0, 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children:[
                ElevatedButton(onPressed: ()async{
                  orders.clear();
                  total=0;
                  CollectionReference bff = FirebaseFirestore.instance.collection("delivery");
                  QuerySnapshot db = await bff.get();
                  showDatePicker(context: context,
                      initialDate: intial,
                      firstDate: DateTime(2022),
                      lastDate: DateTime(2025),
                      selectableDayPredicate: (DateTime val) => val.isAfter(intial) ?false:true,
                      builder: (context,child)=>Theme(data: ThemeData().copyWith(
                        colorScheme: ColorScheme.dark(
                          primary: Colors.teal,
                          onPrimary:Colors.black,
                          onSurface: Colors.black ,
                          surface: Colors.black,
                          brightness: Brightness.light,
                        ),
                      ), child: child!)).then(
                          (date) {
                        db.docs.forEach((element) {
                          setState(() {
                            _dateTime=date!;
                            if(formattedDate(element.get('date'))==('${_dateTime?.day}-${_dateTime?.month}-2022')){
                              orders.add(element.get('order'));
                            }
                          });
                        });
                      });
                },
                  child:Text('Select Day',style:TextStyle(fontSize: 30)),
                  style: ButtonStyle(backgroundColor:MaterialStateProperty.all<Color>(Colors.teal),
                      fixedSize:MaterialStateProperty.all(Size(200,60)),
                      shape:MaterialStateProperty.all<RoundedRectangleBorder>(RoundedRectangleBorder(
                          borderRadius:BorderRadius.circular(25)
                      ))
                  ),
                ),
                ElevatedButton(onPressed: ()async{
                  orders.clear();
                  total=0;
                  CollectionReference bff = FirebaseFirestore.instance.collection("delivery");
                  QuerySnapshot db = await bff.get();
                  await showDateRangePicker(
                      context: context,
                      initialDateRange: _dateTimeRange,
                      firstDate: DateTime(2022),
                      lastDate: DateTime.now().add(Duration(days: 2)),
                      builder: (context,child)=>Theme(data: ThemeData().copyWith(
                        colorScheme: ColorScheme.dark(
                          primary: Colors.teal,
                          onPrimary:Colors.black,
                          onSurface: Colors.black ,
                          surface: Colors.black,
                          brightness: Brightness.light,
                        ),
                      ), child: child!)).then((date) {
                    db.docs.forEach((element) {
                      setState(() {
                        _dateTimeRange=date!;
                        start=date.start;
                        end=date.end;
                        if(start.isBefore(DateTime.fromMillisecondsSinceEpoch(element.get('date').seconds*1000))==true && end.isAfter(DateTime.fromMillisecondsSinceEpoch(element.get('date').seconds*1000))){
                                orders.add(element.get('order'));
                                print('orders $orders');
                          }
                      });
                    });
                  });
                },
                  child:Text('Select Days',style:TextStyle(fontSize: 30)),
                  style: ButtonStyle(backgroundColor:MaterialStateProperty.all<Color>(Colors.teal),
                      fixedSize:MaterialStateProperty.all(Size(200,60)),
                      shape:MaterialStateProperty.all<RoundedRectangleBorder>(RoundedRectangleBorder(
                          borderRadius:BorderRadius.circular(25)
                      ))
                  ),
                ),
              ],
            ),
            ),
            Card(
              child:Container(
                width: 500,
                height: 500,
                child:  Column(
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: EdgeInsets.fromLTRB(20,0,0,5),
                          width: 250,
                          child:Text('Order#',style: TextStyle(fontWeight: FontWeight.bold, color: Colors.teal, fontSize: 30,)),
                        ),
                        Container(
                          width: 210,
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
                            padding: EdgeInsets.fromLTRB(20,0,0,5),
                            width: 250,
                            child:Text("order${i}",style: TextStyle( color: Colors.black, fontSize: 25,)),
                          ),
                          Container(
                            width: 210,
                            child:Text(getSum(i),style: TextStyle( color: Colors.black, fontSize: 25,)),
                          ),
                        ],
                      ),
                    Text('-------------------------------',style: TextStyle(fontWeight: FontWeight.bold, color: Colors.teal, fontSize: 30,)),
                    Row(
                      children:[
                        Container(
                          width: 250,
                          padding: EdgeInsets.fromLTRB(20,0,0,5),
                          child: Text('Total',style:TextStyle(fontWeight: FontWeight.bold, color: Colors.teal, fontSize: 30,)),
                        ),
                        Container(
                          width: 210,
                          child: Text(total.toString(),style: TextStyle( color: Colors.black, fontSize: 28,)),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}