import 'package:flutter/material.dart';

class ProductCreatePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _ProductCreatePageState();
  }
}

class _ProductCreatePageState extends State<ProductCreatePage> {
  String titleValue = '';
  String description = '';
  double price = 0.00;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        TextField(
          onChanged: (String value) {
            setState(
              () {
              titleValue = value;
              }
            );
          },
        ),
        TextField(
          maxLines: 4,
          onChanged: (String value) {
            setState( () {
                description = value;
              });
          },
        ),
        TextField(
          keyboardType: TextInputType.number,
          onChanged: (String value) {
            setState( () {
              price = double.parse(value);
            });
          },
        ),
      ],
    );
  }
}

// Bye immutable non-interactive content
// Center(
//       child: RaisedButton(
//         child: Text('Save'),
//         onPressed: (){
//           showModalBottomSheet(
//             context: context, builder: (BuildContext context){
//               return Center(child: Text('This is our modal'),);
//             }
//           );
//         },
//       ),
//     );
