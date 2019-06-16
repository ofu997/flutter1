import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import '../widgets/helpers/ensure-visible.dart';
import '../models/product.dart';
import 'package:scoped_model/scoped_model.dart';
import '../scoped-models/main.dart';
import '../models/location_data.dart';
import '../widgets/form_inputs/location.dart';
import 'dart:io';
import '../widgets/form_inputs/image.dart';
import '../widgets/ui_elements/adaptive_progress_indicator.dart';

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
    'image': null,
    'location': null
  };
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final _titleFocusNode = FocusNode();
  final _descriptionFocusNode = FocusNode();
  final _priceFocusNode = FocusNode();//FocusNode();

  final _titleTextController = TextEditingController();
  final _descriptionTextController = TextEditingController();
  final _priceTextController = TextEditingController();

  Widget _buildTitleTextField(Product product) {
	  if (product == null && _titleTextController.text.trim() == '') {
      _titleTextController.text = '';
    } else if (product != null && _titleTextController.text.trim() == '') {
      _titleTextController.text = product.title;
    } else if (product != null && _titleTextController.text.trim() != '') {
      _titleTextController.text = _titleTextController.text;
    } else if (product == null && _titleTextController.text.trim() != '') {
      _titleTextController.text = _titleTextController.text;
    } else {
      _titleTextController.text = '';
    }
    return EnsureVisibleWhenFocused(
      focusNode: _titleFocusNode, //this must get binded below
      child: TextFormField(
        focusNode: _titleFocusNode,
        decoration: InputDecoration(labelText: 'Product Title'),
        //if not a complete create, the widget would be null and not constructed, causing a render error when fetching 'title'
        controller: _titleTextController,         
        validator: (String value) {
          if (value.isEmpty || value.length < 5) {
            return ('Title is required and should be 5+ characters long.');
          }
        },
        onSaved: (String value) {
          print('title: ');
          print(value);
          _formData['title'] = value;
        },
      ),
    );
  }

  Widget _buildDescriptionTextField(Product product) {
    if (product == null && _descriptionTextController.text.trim() == '') {
      _descriptionTextController.text = '';
    } else if (product != null && _descriptionTextController.text.trim() == '') {
      _descriptionTextController.text = product.description;
    }
    return EnsureVisibleWhenFocused(
      focusNode: _descriptionFocusNode,
      child: TextFormField(
          focusNode: _descriptionFocusNode,
          decoration: InputDecoration(labelText: 'Product Description'),
          controller: _descriptionTextController,
          maxLines: 2,
          validator: (String value) {
            if (value.isEmpty || value.length < 10) {
              return ('Description is required and should be 10+ characters long.');
            }
          },
          onFieldSubmitted: (value){print('description onFieldSubmitted: '+value);},
          onSaved: (String value) {
            print('description: ');
            print(value);
            _formData['description'] = value;
          }),
    );
  }

  Widget _buildPriceTextField(Product product) {
    if (product == null && _priceTextController.text.trim() == '') {
      _priceTextController.text = '';
    } else if (product != null && _priceTextController.text.trim() == '') {
      _priceTextController.text = product.price.toString();
    }
    return EnsureVisibleWhenFocused(
      focusNode: _priceFocusNode,
      child: TextFormField(
        controller: _priceTextController,
        focusNode: _priceFocusNode,
        decoration: InputDecoration(labelText: 'Product Price'),
        keyboardType: TextInputType.number,
        validator: (String value) {
          if (value.isEmpty ||
              !RegExp(r'^(?:[1-9]\d*|0)?(?:[.,]\d+)?$').hasMatch(value)) {
            return ('Price is required and should be a number.');
          }
        },
        onFieldSubmitted: (value){print('price onFieldSubmitted: '+value);},
        // onSaved: (String value) {
        //   int tempDouble = int.parse(value);
        //   String priceString = tempDouble.toStringAsFixed(2);
        //   double priceDouble = double.tryParse(priceString);
        //   _formData['price'] = priceDouble;
        // },
      ),
    );
  }

  Widget _buildSubmitButton(){
    return ScopedModelDescendant<MainModel>(
      builder: (BuildContext context, Widget child, MainModel model){
        return model.isLoading
          ? Center(
            child: AdaptiveProgressIndicator(), 
          )
        : RaisedButton(
          child: Text('Save'),
          textColor: Colors.white,
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
                    height: 10.0,
                  ),
                  // TextFormField(
                  //   decoration: InputDecoration(labelText: 'Input for Location'),
                  // ),
                  LocationInput(_setLocation, product),	
                  SizedBox(height: 10.0),
                  ImageInput(_setImage, product),
                  SizedBox(
                    height: 35.0,
                  ),
                  _buildSubmitButton(),
                ],
              ),
            )
          )
        );
  }

	void _setLocation(LocationData locData) {
    _formData['location'] = locData;
  }

  void _setImage(File image) {
    _formData['image'] = image;
  }

  void _submitForm(
    Function addProduct, Function updateProduct, Function setSelectedProduct,
    [int selectedProductIndex]) {
      print('product edit _submitForm selectedProductIndex: $selectedProductIndex');
      if (!_formKey.currentState.validate() || (_formData['image'] == null && selectedProductIndex == -1) /*|| (_formData['price'] == null && selectedProductIndex == -1)*/) {
        return;
      }

    _formKey.currentState.save();
    if (selectedProductIndex == -1) {// || selectedProductIndex != null
      addProduct(// sends to connected products
        _titleTextController.text,
        _descriptionTextController.text,
        _formData['image'],
        double.parse(_priceTextController.text.replaceFirst(RegExp(r','), '.')),
        //_formData['price'],
        _formData['location'],
        DateTime.now().toIso8601String(),
        ).then((bool success){
          if (success){
            Navigator
              .pushReplacementNamed(context, '/products')
              .then((_) => setSelectedProduct(null));
          }else{
            showDialog(
              context: context,
              builder: (BuildContext context){
                return AlertDialog(
                  title: Text('something went wrong (product edit)'),
                  content: Text('please try again'),
                  actions: <Widget>[
                    FlatButton(
                      onPressed: () => Navigator.of(context).pop(),
                      child: Text('okay'),
                    )
                  ],
                );
              }
            );
          }
        }
      ); 
    } else {
      print('editing product');
      print(selectedProductIndex);
      updateProduct(
        _titleTextController.text,
        _descriptionTextController.text,
        _formData['image'],
        double.parse(_priceTextController.text.replaceFirst(RegExp(r','), '.')),
        //_formData['price'],
        _formData['location']
      ).then(
      (_) => Navigator
        .pushReplacementNamed(context, '/products')
        .then((_) => setSelectedProduct(null))
      );  
    }
  }

  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<MainModel>(
      builder: (BuildContext context, Widget child, MainModel model) {
        final Widget pageContent =
          _buildPageContent(context, model.selectedProduct);
        return (model.selectedProductIndex == -1)// ||  model.selectedProductIndex != null
          ? pageContent
          : 
          Scaffold(
              appBar: AppBar(
                title: Text('Edit ' + model.selectedProduct.title, style: TextStyle(fontFamily: 'Pacifico')),              
                elevation: Theme.of(context).platform == TargetPlatform.iOS?
                  0.0 : 4.0
                ),
              body: pageContent,            
              );
      },
    );
  }
}
