import 'package:flutter/material.dart';

class ProductCreatePage extends StatefulWidget {
  final Function addProduct;

  ProductCreatePage(this.addProduct);

  @override
  State<StatefulWidget> createState() {
    return _ProductCreatePageState();
  }
}

class _ProductCreatePageState extends State<ProductCreatePage> {
  String _titleValue = '';
  String _descriptionValue = '';
  double _priceValue = 0.00;

  Widget _buildTitleTextField(){
    return TextField(
            decoration: InputDecoration(labelText: 'Product Title'),
            onChanged: (String value) {
              setState(() {
                _titleValue = value;
              });
            },
          );
  }

  Widget _buildDescriptionTextField(){
    return  TextField(
            decoration: InputDecoration(labelText: 'Product Description'),
            maxLines: 4,
            onChanged: (String value) {
              setState(() {
                _descriptionValue = value;
              });
            },
          );
  }

Widget _buildPriceTextField(){
  return  TextField(              
            decoration: InputDecoration(labelText: 'Product Price'),          
            keyboardType: TextInputType.number,
            onChanged: (String value) {
              setState(() {
                _priceValue = double.parse(value);
                print(_priceValue.toString());
              });
            },
          );
}

void _submitForm(){
              final Map<String, dynamic> product = {
                'title': _titleValue, 'description': _descriptionValue,
              'price': _priceValue, 'image': 'assets/food.jpg'
              };
            widget.addProduct(product);//widget calls parent class ProductCreatePage
            Navigator.pushReplacementNamed(context,'/products');// this method gives you no option of going back
            }

  @override
  Widget build(BuildContext context) {
    final double deviceWidth = MediaQuery.of(context).size.width;
    final double targetWidth = deviceWidth > 550.0 ? 500.0 : deviceWidth * 0.95;
    final double targetPadding = deviceWidth - targetWidth;
    return Container(
      width: targetWidth,
      margin: EdgeInsets.all(10.0),
      child: ListView(
        padding: EdgeInsets.symmetric(horizontal: targetPadding /2),
        children: <Widget>[//ListView children always take full available width
          _buildTitleTextField(),
          _buildDescriptionTextField(),
          _buildPriceTextField(),
          SizedBox(height: 25.0,),
          // RaisedButton(
          //   color: Theme.of(context).primaryColorLight,
          //   child: Text('Save'),
          //   onPressed: _submitForm,
          // ),
          GestureDetector(//offers other types of listener events
            onTap: _submitForm,
            child: Container(
              color: Colors.green,
              padding: EdgeInsets.all(5.0),
              child: Text('My Button'),
            ),
          ),
        ],
      ),
    );
  }
}

