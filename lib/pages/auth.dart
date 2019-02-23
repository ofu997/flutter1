import 'package:flutter/material.dart';

import 'package:scoped_model/scoped_model.dart';

import '../scoped-models/main.dart';

enum AuthMode {Signup, Login}

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

  final TextEditingController _passwordTextController = TextEditingController();
  AuthMode _authMode = AuthMode.Login;

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
                controller: _passwordTextController,
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

  Widget _buildPasswordConfirmTextField() {
    return TextFormField(
      decoration: InputDecoration(
        labelText: 'Confirm Password', filled: true, fillColor: Colors.white),
      obscureText: true,
      validator: (String value) {
        if (_passwordTextController.text != value) {
          return 'Passwords do not match.';
        }
      },
    );
  }

  Widget _buildSwitch(){
    return  SwitchListTile(
                  value: _authData['acceptTerms'],
                  onChanged: (bool value) {           
                    setState((){
                      _authData['acceptTerms'] = value;
                    });    
                  },
                  title: Text('accept terms'),
                );
  }

  void _submitForm(Function login, Function signup) async
  { 
    if (!_authFormKey.currentState.validate() || !_authData['acceptTerms']) {
      return;
    }
    _authFormKey.currentState.save();
    if (_authMode == AuthMode.Login){
      login(_authData['email'], _authData['password']);
      } else {
        final Map<String, dynamic> successInformation =
            await signup(_authData['email'], _authData['password']);
        if (successInformation['success']) {
          Navigator.pushReplacementNamed(context, '/products');
        } else {
          showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  title: Text('An Error Occurred!'),
                  content: Text(successInformation['message']),
                  actions: <Widget>[
                    FlatButton(
                      child: Text('Okay'),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                    )
                  ],
                );
              });
        }
      }
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
                      SizedBox(
                        height: 10.0,
                      ),
                    _authMode == AuthMode.Signup
                        ? _buildPasswordConfirmTextField()
                        : Container(),                      
                      _buildSwitch(),
                      SizedBox(
                        height: 25.0,
                      ),
                      FlatButton(
                        child: Text(
                            'Switch to ${_authMode == AuthMode.Login ? 'Signup' : 'Login'}'),
                        onPressed: () {
                          setState(() {
                            _authMode = _authMode == AuthMode.Login
                                ? AuthMode.Signup
                                : AuthMode.Login;
                            });
                        },
                      ),
                    SizedBox(
                      height: 10.0,
                    ),                      
                      ScopedModelDescendant<MainModel> (
                        builder: (BuildContext context, Widget child, MainModel model){
                          return model.isLoading?
                          CircularProgressIndicator():
                          RaisedButton(
                            child: Text(_authMode ==AuthMode.Login?
                              'LOGIN':
                              'SIGNUP'
                            ),
                            textColor: Colors.white,
                            onPressed: ( ) => _submitForm(model.login, model.signup),
                          );
                        }
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

