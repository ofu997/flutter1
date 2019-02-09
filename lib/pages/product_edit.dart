import 'package:flutter/material.dart';
import '../widgets/helpers/ensure-visible.dart';
import '../models/product.dart';

class ProductEditPage extends StatefulWidget {
  final Function addProduct;
  final Function updateProduct;
  final Product product;
  final int productIndex;

  ProductEditPage(
      {this.addProduct, this.updateProduct, this.product, this.productIndex});

  @override
  State<StatefulWidget> createState() {
    return _ProductEditPageState();
  }
}

class _ProductEditPageState extends State<ProductEditPage> {
  final Map<String, dynamic> _formData = {
    'title': null,
    'description': null,
    'price': null,
    'image': 'assets/food.jpg'
  };
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final _titleFocusNode = FocusNode();
  final _descriptionFocusNode = FocusNode();
  final _priceFocusNode = FocusNode();

  Widget _buildTitleTextField() {
    return EnsureVisibleWhenFocused(
      focusNode: _titleFocusNode, //this must get binded below
      child: TextFormField(
        focusNode: _titleFocusNode,
        decoration: InputDecoration(labelText: 'Product Title'),
        //if not a complete create, the widget would be null and not constructed, causing a render error when fetching 'title'
        initialValue: widget.product == null ? '' : widget.product.title,
        validator: (String value) {
          if (value.isEmpty || value.length < 5) {
            return ('Title is required and should be 5+ characters long.');
          }
        },
        onSaved: (String value) {
          //setState not necessary because we're not rerendering
          _formData['title'] = value;
        },
      ),
    );
  }

  Widget _buildDescriptionTextField() {
    return EnsureVisibleWhenFocused(
      focusNode: _descriptionFocusNode,
      child: TextFormField(
          focusNode: _descriptionFocusNode,
          decoration: InputDecoration(labelText: 'Product Description'),
          initialValue:
              widget.product == null ? '' : widget.product.description,
          maxLines: 4,
          validator: (String value) {
            if (value.isEmpty || value.length < 10) {
              return ('Description is required and should be 10+ characters long.');
            }
          },
          onSaved: (String value) {
            _formData['description'] = value;
          }),
    );
  }

  Widget _buildPriceTextField() {
    return EnsureVisibleWhenFocused(
      focusNode: _priceFocusNode,
      child: TextFormField(
          focusNode: _priceFocusNode,
          decoration: InputDecoration(labelText: 'Product Price'),
          initialValue:
              widget.product == null ? '' : widget.product.price.toString(),
          keyboardType: TextInputType.number,
          validator: (String value) {
            if (value.isEmpty ||
                !RegExp(r'^(?:[1-9]\d*|0)?(?:\.\d+)?$').hasMatch(value)) {
              return ('Price is required and should be a number.');
            }
          },
          onSaved: (String value) {
            _formData['price'] = double.parse(value);
          }),
    );
  }

  void _submitForm() {
    if (!_formKey.currentState.validate()) {
      return;
    }
    _formKey.currentState.save();
    if (widget.product == null) {
      widget.addProduct(Product(
          title: _formData['title'],
          description: _formData['description'],
          price: _formData['price'],
          image: _formData['image'])); //widget calls parent class ProductCreatePage
    } else {
      widget.updateProduct(widget.productIndex, _formData);
      print('reached updater function');
    }
    Navigator.pushReplacementNamed(
        context, '/products'); // this method gives you no option of going back
  }

  @override
  Widget build(BuildContext context) {
    final Widget pageContent = _buildPageContent(context);
    return widget.product == null
        ? pageContent
        : Scaffold(
            appBar: AppBar(
              title: Text('Edit Products'),
            ),
            body: pageContent,
          );
  }

  Widget _buildPageContent(BuildContext context) {
    final double deviceWidth = MediaQuery.of(context).size.width;
    final double targetWidth = deviceWidth > 550.0 ? 500.0 : deviceWidth * 0.95;
    final double targetPadding = deviceWidth - targetWidth;
    return GestureDetector(
        onTap: () {
          FocusScope.of(context).requestFocus(
              FocusNode()); //instantiates an empty focus node, looks at form elements
        },
        child: Container(
            width: targetWidth,
            margin: EdgeInsets.all(10.0),
            child: Form(
              key: _formKey,
              child: ListView(
                padding: EdgeInsets.symmetric(horizontal: targetPadding / 2),
                children: <Widget>[
                  //ListView children always take full available width
                  _buildTitleTextField(),
                  _buildDescriptionTextField(),
                  _buildPriceTextField(),
                  SizedBox(
                    height: 25.0,
                  ),
                  GestureDetector(
                    //offers more types of listener events than RaisedButton
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
            )));
  }
}
