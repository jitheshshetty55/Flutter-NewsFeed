import 'package:flutter/material.dart';
import '../../utils/constants.dart';

class AlertView extends StatefulWidget {
  final String message;
  bool info;

  AlertView(this.message, this.info);

  @override
  AlertViewState createState() => AlertViewState();
}

class AlertViewState extends State<AlertView> with Constants {
  @override
  void initState() {
    print(widget.message);
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Card(
        color: Theme.of(context).backgroundColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(10.0))
          ,
        ),
        elevation: 5,
        margin: EdgeInsets.all(10),
        child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Padding(
                  padding: EdgeInsets.only(top: 40),
                  child: widget.info==true?Icon(Icons.info,color:Theme.of(context).primaryColor,size: 120,):Icon(Icons.warning,color:Theme.of(context).primaryColor,size: 120,),),
              Padding(
                  padding: EdgeInsets.only(top: 40,left: 20,right: 20,bottom:40),
                      child: Text(
                        widget.message,
                        style: Theme.of(context).textTheme.display3,
                      )),
            ]),
    );
  }
}
