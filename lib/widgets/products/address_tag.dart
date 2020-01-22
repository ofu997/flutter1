import 'package:flutter_web/material.dart';

class AddressTag extends StatelessWidget{
  final String address;

  AddressTag(this.address);

  @override
  Widget build(BuildContext context) {
    return
      Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Expanded(flex: 2, child: Column()),
          Expanded(flex: 10, child: DecoratedBox(
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey, width: 1.0),
              borderRadius: BorderRadius.circular(8.0)
            ),
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 6.0, vertical: 2.5),
              child: Text(address),
            ),
          ),),          
          Expanded(flex: 2, child: Column()),
        ],
      );
      // return       DecoratedBox(
      //   decoration: BoxDecoration(
      //       border: Border.all(color: Colors.grey, width: 1.0),
      //       borderRadius: BorderRadius.circular(8.0)),
      //   child: Padding(
      //     padding: EdgeInsets.symmetric(horizontal: 6.0, vertical: 2.5),
      //     child: Text(address),
      //   ),
      // );
    }
  
}

