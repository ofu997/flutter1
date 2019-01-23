import 'package:flutter/material.dart';

class ProductCreatePage extends StatefulWidget {
  final Function addProduct;

  ProductCreatePage(this.addProduct);

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
    return Container(
      margin: EdgeInsets.all(10.0),
      child: ListView(
        children: <Widget>[
          TextField(
            decoration: InputDecoration(labelText: 'Product Title'),
            onChanged: (String value) {
              setState(() {
                titleValue = value;
              });
            },
          ),
          TextField(
            decoration: InputDecoration(labelText: 'Product Description'),
            maxLines: 4,
            onChanged: (String value) {
              setState(() {
                description = value;
              });
            },
          ),
          TextField(              
            decoration: InputDecoration(labelText: 'Product Price'),          
            keyboardType: TextInputType.number,
            onChanged: (String value) {
              setState(() {
                price = double.parse(value);
              });
            },
          ),
          SizedBox(height: 25.0,),
          RaisedButton(
            color: Theme.of(context).primaryColorLight,
            child: Text('Save'),
            onPressed: (){
              final Map<String, dynamic> product = {
                'title': titleValue, 'description': description,
              'price': price, 'image': 'assets/food.jpg'
              };
            widget.addProduct(product);
            Navigator.pushReplacementNamed(context,'/');// gives you no option of going back
            },

          )
        ],
      ),
    );
  }
}
