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
  String _titleValue = '';
  String _descriptionValue = '';
  double _priceValue = 0.00;

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
                _titleValue = value;
              });
            },
          ),
          TextField(
            decoration: InputDecoration(labelText: 'Product Description'),
            maxLines: 4,
            onChanged: (String value) {
              setState(() {
                _descriptionValue = value;
              });
            },
          ),
          TextField(              
            decoration: InputDecoration(labelText: 'Product Price'),          
            keyboardType: TextInputType.number,
            onChanged: (String value) {
              setState(() {
                _priceValue = double.parse(value);
                print(_priceValue.toString());
              });
            },
          ),
          SizedBox(height: 25.0,),
          RaisedButton(
            color: Theme.of(context).primaryColorLight,
            child: Text('Save'),
            onPressed: (){
              final Map<String, dynamic> product = {
                'title': _titleValue, 'description': _descriptionValue,
              'price': _priceValue, 'image': 'assets/food.jpg'
              };
            widget.addProduct(product);
            Navigator.pushReplacementNamed(context,'/products');// this method gives you no option of going back
            },

          )
        ],
      ),
    );
  }
}
