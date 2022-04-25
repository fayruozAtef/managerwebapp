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
    end:DateTime.now(),
);

  List orders=[];
  List<String> consts=[];
  double total=0;

  String formattedDate(timeStamp){
    var dateFormTimeStamp=DateTime.fromMillisecondsSinceEpoch(timeStamp.seconds*1000);
    return DateFormat('d-M-yyy').format(dateFormTimeStamp);
  }

  String getSum(int n) {
    double sum = 0;
    if(n>=consts.length) {
      for (var i in orders[n].values) {
        sum += double.parse(i[2]);
      }
    }
    return (sum+((sum*14)/100)).toString();
  }

  String getSumD(int n) {
    double sum = 0;
    if(n<consts.length) {
      for (var i in orders[n].values) {
        sum += double.parse(i[2]);
      }
    }
    return (sum+int.parse(consts[n])).toString();
  }

  String getService(int n){
    double sum = 0;
    if(n>=consts.length){
      for (var i in orders[n].values) {
        sum += double.parse(i[2]);
      }
    }
    return((sum*14)/100).toString();
  }
  @override
  Widget build(BuildContext context) {
    var start=_dateTimeRange.start;
    var end=_dateTimeRange.end;

    for(int i=0;i<orders.length;i++){
      if(i>=consts.length) {
        total += double.parse(getSum(i));
      }
      if(i<consts.length){
        total += double.parse(getSumD(i));
      }
    }


    return Scaffold(
      appBar: AppBar(
        title: Text('Total Payment',
            style: TextStyle(color: Colors.white, fontSize: 40,)),
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
                  consts.clear();
                  CollectionReference bff = FirebaseFirestore.instance.collection("delivery");
                  CollectionReference bff2 = FirebaseFirestore.instance.collection("In-Hall");
                  QuerySnapshot db = await bff.get();
                  QuerySnapshot db2 = await bff2.get();
                  showDatePicker(context: context,
                      initialDate: intial,
                      firstDate: DateTime(2022),
                      lastDate: DateTime(2025),
                      selectableDayPredicate: (DateTime val) => val.isAfter(intial) ?false:true,
                      builder: (context,child)=>Theme(data: ThemeData().copyWith(
                        colorScheme: ColorScheme.dark(
                          primary: Colors.blue,
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
                              consts.add(element.get('const'));
                            }
                          });
                        });
                        db2.docs.forEach((element) {
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
                  style: ButtonStyle(backgroundColor:MaterialStateProperty.all<Color>(Colors.blue),
                      fixedSize:MaterialStateProperty.all(Size(200,60)),
                      shape:MaterialStateProperty.all<RoundedRectangleBorder>(RoundedRectangleBorder(
                          borderRadius:BorderRadius.circular(25)
                      ))
                  ),
                ),
                ElevatedButton(onPressed: ()async{
                  orders.clear();
                  total=0;
                  consts.clear();
                  CollectionReference de = FirebaseFirestore.instance.collection("delivery");
                  CollectionReference ha = FirebaseFirestore.instance.collection("In-Hall");
                  QuerySnapshot dd = await de.get();
                  QuerySnapshot hh = await ha.get();
                  await showDateRangePicker(
                      context: context,
                      initialDateRange: _dateTimeRange,
                      firstDate: DateTime(2022),
                      lastDate: DateTime.now(),
                      builder: (context,child)=>Theme(data: ThemeData().copyWith(
                        colorScheme: ColorScheme.dark(
                          primary: Colors.blue,
                          onPrimary:Colors.black,
                          onSurface: Colors.black ,
                          surface: Colors.black,
                          brightness: Brightness.light,
                        ),
                      ), child: child!)).then((date) {
                    dd.docs.forEach((element) {
                      setState(() {
                        _dateTimeRange=date!;
                        start=date.start;
                        end=date.end;
                        if(start.isBefore(DateTime.fromMillisecondsSinceEpoch(element.get('date').seconds*1000))==true && (DateTime.fromMillisecondsSinceEpoch(element.get('date').seconds*1000)).isBefore(end.add(Duration(days: 1)))==true){
                                orders.add(element.get('order'));
                                consts.add(element.get('const'));
                          }
                      });
                    });
                    hh.docs.forEach((element) {
                      setState(() {
                        _dateTimeRange=date!;
                        start=date.start;
                        end=date.end;
                        if(start.isBefore(DateTime.fromMillisecondsSinceEpoch(element.get('date').seconds*1000))==true && (DateTime.fromMillisecondsSinceEpoch(element.get('date').seconds*1000)).isBefore(end.add(Duration(days: 1)))==true){
                          orders.add(element.get('order'));
                        }
                      });
                    });
                  });
                },
                  child:Text('Select Days',style:TextStyle(fontSize: 30)),
                  style: ButtonStyle(backgroundColor:MaterialStateProperty.all<Color>(Colors.blue),
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
                width: 600,
                child:  Column(
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: EdgeInsets.fromLTRB(20,0,0,5),
                          width: 300,
                          child:Text('Order#',style: TextStyle(fontWeight: FontWeight.bold, color: Colors.blue, fontSize: 30,)),
                        ),
                        Container(
                          width: 230,
                          child:
                          Text('Price',style: TextStyle(fontWeight: FontWeight.bold, color: Colors.blue, fontSize: 30,)),
                        ),
                      ],
                    ),
                    Text('-------------------------------',style: TextStyle(fontWeight: FontWeight.bold, color: Colors.blue, fontSize: 30,)),
                    for(int i=0;i<orders.length;i++)
                      ExpansionTile(
                                  collapsedIconColor: Colors.black,
                                  iconColor: Colors.black,
                                  childrenPadding: EdgeInsets.all(16).copyWith(top: 0),
                                  title:Row(children:[
                                  Container(
                            padding: EdgeInsets.fromLTRB(20,0,0,5),
                            width: 300,
                            child:Text("order${i+1}",style: TextStyle( color: Colors.black, fontSize: 20,fontWeight: FontWeight.bold)),
                            ),
                                    Container(
                            width: 230,
                            child:(i<consts.length)?
                            Text(getSumD(i),style: TextStyle( color: Colors.black, fontSize: 20,fontWeight: FontWeight.bold)):
                            Text(getSum(i),style: TextStyle( color: Colors.black, fontSize: 20,fontWeight: FontWeight.bold))  ,
                          ),
                      ],
                                  ),
                        children: [
                          for (var j in orders[i].values)
                          Row(
                            children: [
                              Container(
                                padding: EdgeInsets.fromLTRB(8,0,0,5),
                                width: 200,
                                child:Text(j[0],style: TextStyle( color: Colors.black, fontSize: 20,)),
                              ),
                              Container(
                                padding: EdgeInsets.fromLTRB(0,0,0,5),
                                width: 100,
                                child:Text('x'+j[1],style: TextStyle( color: Colors.black, fontSize: 20,)),
                              ),
                              Container(
                                padding: EdgeInsets.fromLTRB(0,0,0,5),
                                width: 230,
                                child:Text(j[2],style: TextStyle( color: Colors.black, fontSize: 20,)),
                              ),
                            ],
                          ),
                          Row(
                            children:[
                              Container(
                                width: 300,
                                padding: EdgeInsets.fromLTRB(20,0,0,5),
                                child:(i<consts.length)?
                                Text('Delivery',style:TextStyle( color: Colors.black, fontSize: 20,)):
                                Text('Service',style:TextStyle( color: Colors.black, fontSize: 20,)),
                              ),
                              Container(
                                width: 230,
                                child:(i<consts.length)?
                                Text(consts[i],style: TextStyle( color: Colors.black, fontSize: 20,)):
                                Text(getService(i),style: TextStyle( color: Colors.black, fontSize: 20,)),
                              ),
                            ],
                          ),
                        ],
                      ),
                    Text('-------------------------------',style: TextStyle(fontWeight: FontWeight.bold, color: Colors.blue, fontSize: 30,)),
                    Row(
                      children:[
                        Container(
                          width: 300,
                          padding: EdgeInsets.fromLTRB(20,0,0,5),
                          child: Text('Total',style:TextStyle(fontWeight: FontWeight.bold, color: Colors.blue, fontSize: 30,)),
                        ),
                        Container(
                          width: 230,
                          child: Text(total.toString(),style: TextStyle( color: Colors.black, fontSize: 23,fontWeight: FontWeight.bold)),
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