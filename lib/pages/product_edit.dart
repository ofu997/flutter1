import 'package:flutter/material.dart';
import '../widgets/helpers/ensure-visible.dart';
import '../models/product.dart';
import 'package:scoped_model/scoped_model.dart';
import '../scoped-models/main.dart';



class ProductEditPage extends StatefulWidget {
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

  Widget _buildTitleTextField(Product product) {
    return EnsureVisibleWhenFocused(
      focusNode: _titleFocusNode, //this must get binded below
      child: TextFormField(
        focusNode: _titleFocusNode,
        decoration: InputDecoration(labelText: 'Product Title'),
        //if not a complete create, the widget would be null and not constructed, causing a render error when fetching 'title'
        initialValue: product == null ? '' : product.title,
        validator: (String value) {
          if (value.isEmpty || value.length < 5) {
            return ('Title is required and should be 5+ characters long.');
          }
        },
        onSaved: (String value) {
          _formData['title'] = value;
        },
      ),
    );
  }

  Widget _buildDescriptionTextField(Product product) {
    return EnsureVisibleWhenFocused(
      focusNode: _descriptionFocusNode,
      child: TextFormField(
          focusNode: _descriptionFocusNode,
          decoration: InputDecoration(labelText: 'Product Description'),
          initialValue:
              product == null ? '' : product.description,
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

  Widget _buildPriceTextField(Product product) {
    return EnsureVisibleWhenFocused(
      focusNode: _priceFocusNode,
      child: TextFormField(
        focusNode: _priceFocusNode,
        decoration: InputDecoration(labelText: 'Product Price'),
        initialValue:
          product == null ? '' : product.price.toString(),
        keyboardType: TextInputType.number,
        validator: (String value) {
          if (value.isEmpty ||
              !RegExp(r'^(?:[1-9]\d*|0)?(?:\.\d+)?$').hasMatch(value)) {
            return ('Price is required and should be a number.');
          }
        },
        onSaved: (String value) {
          _formData['price'] = double.parse(value);
        },
      ),
    );
  }

  Widget _buildSubmitButton(){
    return ScopedModelDescendant<MainModel>(
      builder: (BuildContext context, Widget child, MainModel model){
        return RaisedButton(
          child: Text('Save'),
          textColor: Colors.white,,
          onPressed: () => _submitForm(model.addProduct, model.updateProduct,
            model.selectProduct, model.selectedProductIndex),
        );
      },
    );
  }

  Widget _buildPageContent(BuildContext context, Product product) {
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
                  _buildTitleTextField(product),
                  _buildDescriptionTextField(product),
                  _buildPriceTextField(product),
                  SizedBox(
                    height: 25.0,
                  ),
                  _buildSubmitButton(),
                  // GestureDetector(
                  //   //offers more types of listener events than RaisedButton
                  //   onTap: _submitForm,
                  //   child: Container(
                  //     color: Theme.of(context)
                  //         .primaryColorLight, //Colors.orangeAccent,
                  //     padding: EdgeInsets.all(5.0),
                  //     child: Center(child: Text('Save')),
                  //   ),
                  // ),
                ],
              ),
            )));
  }

    void _submitForm(
      Function addProduct, Function updateProduct, Function setSelectedProduct,
      [int selectedProductIndex]) {
    if (!_formKey.currentState.validate()) {
      return;
    }
    _formKey.currentState.save();
    if (selectedProductIndex == null) {
      addProduct(
        _formData['title'],
        _formData['description'],
        _formData['price'],
        _formData['image']
        ); //widget calls parent class ProductCreatePage
    } else {
      updateProduct(
        _formData['title'],
        _formData['description'],
        _formData['image'],
        _formData['price'],
      );  
    }
    Navigator.pushReplacementNamed(
        context, '/products').then((_) => setSelectedProduct(null)); 
  }

  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<MainModel>(
      builder: (Buildcontext context, Widget child, MainModel model) {
        final Widget pagecontent =
          _buildPageContent(context, model.selectedProduct);
        return model.selectedProductIndex == null
          ? pageContent
          : Scaffold(
              appBar: AppBar(
                title: Text('Edit Products'),
              ),
              body: pageContent,
            );
      },
    );
  }
}
