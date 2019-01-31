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
  final Map<String,dynamic> _formData = {
    'title':null,
    'description':null,
    'price':null,
    'image':'assets/food.jpg'
  };
  // String _titleValue = '';
  // String _descriptionValue = '';
  // double _priceValue = 0.00;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  Widget _buildTitleTextField() {
    return TextFormField(
      decoration: InputDecoration(labelText: 'Product Title'),
      validator: (String value) {
        if (value.isEmpty || value.length < 5) {
          return ('Title is required and should be 5+ characters long.');
        }
      },
      onSaved: (String value) {//setState not necessary because we're not rerendering
          _formData['title'] = value;
      },
    );
  }

  Widget _buildDescriptionTextField() {
    return TextFormField(
        decoration: InputDecoration(labelText: 'Product Description'),
        maxLines: 4,
        validator: (String value) {
          if (value.isEmpty || value.length < 10) {
            return ('Description is required and should be 10+ characters long.');
          }
        },
        onSaved: (String value) {
            _formData['description'] = value;
        });
  }

  Widget _buildPriceTextField() {
    return TextFormField(
        decoration: InputDecoration(labelText: 'Product Price'),
        keyboardType: TextInputType.number,
        validator: (String value) {
          if (value.isEmpty ||
              !RegExp(r'^(?:[1-9]\d*|0)?(?:\.\d+)?$').hasMatch(value)) {
            return ('Price is required and should be a number.');
          }
        },
        onSaved: (String value) {
            _formData['price'] = double.parse(value);
        });
  }

  void _submitForm() {
    if (!_formKey.currentState.validate()) {
      return;
    }
    _formKey.currentState.save();
    // final Map<String, dynamic> product = {
    //   'title': _titleValue,
    //   'description': _descriptionValue,
    //   'price': _priceValue,
    //   'image': 'assets/food.jpg'
    // };
    widget.addProduct(_formData); //widget calls parent class ProductCreatePage
    Navigator.pushReplacementNamed(
        context, '/products'); // this method gives you no option of going back
  }

  @override
  Widget build(BuildContext context) {
    final double deviceWidth = MediaQuery.of(context).size.width;
    final double targetWidth = deviceWidth > 550.0 ? 500.0 : deviceWidth * 0.95;
    final double targetPadding = deviceWidth - targetWidth;
    return GestureDetector(
      onTap:(){
        FocusScope.of(context).requestFocus(FocusNode());//instantiates an empty focus node, looks at form elements 
      },
      child: Container(
        width: targetWidth,
        margin: EdgeInsets.all(10.0),
        child: Form(
          key: _formKey,
          child: ListView(
            padding: EdgeInsets.symmetric(horizontal: targetPadding / 2),
            children: <Widget>[//ListView children always take full available width
              _buildTitleTextField(),
              _buildDescriptionTextField(),
              _buildPriceTextField(),
              SizedBox(
                height: 25.0,
              ),
              GestureDetector(
                //offers other types of listener events
                onTap: _submitForm,
                child: Container(
                  color: Theme.of(context)
                      .primaryColorLight, //Colors.orangeAccent,
                  padding: EdgeInsets.all(5.0),
                  child: Center(child: Text('Save')),
                ),
              ),
            ],
          ),
        )
      )
    );
  }
}

// RaisedButton(
//   color: Theme.of(context).primaryColorLight,
//   child: Text('Save'),
//   onPressed: _submitForm,
// ),