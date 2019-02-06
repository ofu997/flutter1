import 'package:flutter/material.dart';

class AuthPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _AuthPage();
  }
}

class _AuthPage extends State<AuthPage> {
  final Map<String,dynamic> _authData = {
    'email': null,
    'passWord': null,
    'acceptTerms': false
  };
  final GlobalKey<FormState> _authFormKey = GlobalKey<FormState>();
  // String userName;
  // String password;
  // bool _acceptTerms = false;

  DecorationImage _buildBackgroundImage(){
  return 
    DecorationImage(
      colorFilter: ColorFilter.mode(Colors.black.withOpacity(0.09), BlendMode.dstATop),
      fit: BoxFit.fill,
      image: AssetImage('assets/background.jpg'),
    );
  }

Widget _buildEmailTextfield(){
  return  TextFormField(
                decoration: InputDecoration(labelText: 'Email', filled: true, fillColor: Colors.white),
                keyboardType: TextInputType.emailAddress,
                onSaved: (String value) {
                  _authData['email'] = value;
                },
                validator: (String value) {
                  if (value.isEmpty ||
                      !RegExp(r"[a-z0-9!#$%&'*+/=?^_`{|}~-]+(?:\.[a-z0-9!#$%&'*+/=?^_`{|}~-]+)*@(?:[a-z0-9](?:[a-z0-9-]*[a-z0-9])?\.)+[a-z0-9](?:[a-z0-9-]*[a-z0-9])?").hasMatch(value)) {
                    return ('needs to be a valid email address.');
                  }
                }
              );
  }

  Widget _buildPassword(){
  return  TextFormField(
                decoration: InputDecoration(labelText: 'Password', filled: true, fillColor: Colors.white),
                maxLines: 4,
                obscureText: true,
                keyboardType: TextInputType.text,
                onSaved: (String value) {
                
                 _authData['passWord'] = value;
                  
                },
                validator: (String value){
                  if (value.isEmpty){
                    return 'Needs to be filled out';
                  }
                },
              );
}

Widget _buildSwitch(){
  return  SwitchListTile(
                value: _authData['acceptTerms'],
                onChanged: (bool value) {
                
                    _authData['acceptTerms'] = value;
                    print('switch button changed');
                },
                title: Text('accept terms'),
              );
}

void _submitForm(){

                  // final Map<String, dynamic> userInfo = {
                  //   'name': userName,
                  //   'description': password,
                  // };
                  print('submit button pushed');
                  if (!_authFormKey.currentState.validate() || !_authData['acceptTerms']) {
                    return;
                  }
                  // if (_authData['acceptTerms']==false){
                  //   return;
                  // }
                  _authFormKey.currentState.save();
                  print(_authData['email'] + ' ' + _authData['passWord']);
                  //print(userInfo.toString());
                  //widget.addProduct(product);
                  
                  Navigator.pushReplacementNamed(context,
                      '/products'); // gives you no option of going back
}

  @override
  Widget build(BuildContext context) {
    final double deviceWidth = MediaQuery.of(context).size.width;
    final double targetWidth = deviceWidth > 550.0 ? 500.0 : deviceWidth *0.95;
    return Scaffold(
        appBar: AppBar(
          title: Text('Log In'),
        ),
        body: Container(
          decoration: BoxDecoration(
            image: _buildBackgroundImage(),
          ),
          padding: EdgeInsets.all(10.0),
          child: Form(
            key: _authFormKey,
            child: Center(
            child: SingleChildScrollView(
              child: Container(
                width: targetWidth,
                child: Column( 
                  children: <Widget>[
                    _buildEmailTextfield(),
                    SizedBox(
                      height: 11.0
                    ),
                    _buildPassword(),
                    _buildSwitch(),
                    SizedBox(
                      height: 25.0,
                    ),
                    RaisedButton (
                      textColor: Colors.brown,
                      color: Theme.of(context).primaryColorLight,
                      child: Text('submit'),
                      onPressed: _submitForm
                    ),
                  ],
                ),
              )
            )
          ),
          )
        )
      );
  }
}

/* pushReplacementNamed: replace the route by pushing the route named routeName 
and then disposing the previous route once the new route has finished animating in.*/

