import 'package:flutter/material.dart';

import 'package:legalpedia/judgementdetails.dart';
import 'package:legalpedia/models/summarymodel.dart';
import 'package:legalpedia/models/ratiosmodel.dart';
import 'package:intl/intl.dart';

class CourtofAppeal extends StatefulWidget{

  final List<SummaryModel> summary;
   final List<RatioModel> ratio;
  List<SummaryModel> summary2 = List();
 List<SummaryModel> filteredsummary = List();

  CourtofAppeal(this.summary, this.ratio);


  @override
  _CourtofAppeal createState()=> _CourtofAppeal(this.summary, this.ratio);

}

class _CourtofAppeal extends State<CourtofAppeal>{

 final List<SummaryModel> summary;
  final List<RatioModel> ratio;
  List<SummaryModel> summary2 = List();
 List<SummaryModel> filteredsummary = List();

  _CourtofAppeal(this.summary, this.ratio);

 @override
 void initState() {
   super.initState();

       setState(() {

         summary2 = summary.where((u)=>
         (u.court.toLowerCase().contains('In the Court of Appeal'.toLowerCase()))).toList();
           summary2.sort((a, b) => a.id.compareTo(b.id));
           
         filteredsummary = summary2;
       });


 }

String getDate(str){

    try{
    var parsedDate = DateTime.parse(str);

    var formatter = new DateFormat('yyyy-MM-dd');
    String formatted = formatter.format(parsedDate);

    return formatted;
    } 
    catch(e){
      return 'Invalid Date';
    }
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return new Scaffold(

        body:
        Column(
          children: <Widget>[
            TextField(
              decoration: InputDecoration(
                  contentPadding: EdgeInsets.all(10.0),
                  hintText: 'Filter by title, year or suit number'
              ),
              onChanged: (string){
                setState(() {
                  filteredsummary = summary2.where((u)=>
                  (u.title.toLowerCase().contains(string.toLowerCase()) ||
                      u.judgementDate.toLowerCase().contains(string.toLowerCase()) ||
                      u.suitNo.toLowerCase().contains(string.toLowerCase()))).toList();
                });
              },
            ),
            Expanded(
              child: ListView.builder(
                  padding: EdgeInsets.all(10.0),
                  itemCount: filteredsummary.length,
                  itemBuilder: (BuildContext context, int index){

                    return InkWell(
                        splashColor: Colors.redAccent,
                        borderRadius: BorderRadius.circular(10.0),
                        onTap: (){
                          setState(() {
                            Navigator.push(context, MaterialPageRoute(builder: (context){
                              return JudgementDetail(filteredsummary, filteredsummary[index].suitNo, ratio);
                            }));
                          });
                        },
                    child: Card(
                      child: Padding(
                        padding: EdgeInsets.all(10.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(filteredsummary[index].title==null ||  filteredsummary[index].title.toString().toUpperCase()=='NIL|'? 'None': filteredsummary[index].title, style: TextStyle(
                                fontSize: 15.0,
                                fontFamily: 'Monseratti'

                            ),),
                            SizedBox(height: 10.0),

                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Text(filteredsummary[index].judgementDate==null ||  filteredsummary[index].judgementDate.toString().toUpperCase()=='NIL|'? 'None Available':getDate(filteredsummary[index].judgementDate.toString()) , style: TextStyle(
                                fontSize: 10.0,
                                fontFamily: 'Monseratti',
                                color: Colors.grey

                            ),),
                            
                            ],),
                           
                          ],
                        ),
                      ),
                    ));
                  }),
            )
          ],
        )
    );
  }


}