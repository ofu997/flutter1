import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import '../scoped-models/main.dart';
import '../models/auth.dart';
import '../widgets/ui_elements/adaptive_progress_indicator.dart';

class AuthPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _AuthPage();
  }
}



class _AuthPage extends State<AuthPage> with TickerProviderStateMixin{
  final Map<String,dynamic> _formData = {
    'email': null,
    'password': null,
    'acceptTerms': false
  };
  final GlobalKey<FormState> _authFormKey = GlobalKey<FormState>();

  final TextEditingController _passwordTextController = TextEditingController();
  AuthMode _authMode = AuthMode.Login;  
  AnimationController _controller;
  Animation<Offset> _slideAnimation;

  void initState() {
    _controller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 300),
    );
    _slideAnimation =
        Tween<Offset>(begin: Offset(0.0, -1.5), end: Offset.zero).animate(
      CurvedAnimation(parent: _controller, curve: Curves.fastOutSlowIn),
    );
    super.initState();
  }

  DecorationImage _buildBackgroundImage(){
  return 
    DecorationImage(
      colorFilter: ColorFilter.mode(Colors.black.withOpacity(0.18), BlendMode.dstATop),
      fit: BoxFit.fill,
      image: AssetImage('assets/Tchotchkes.jpg'),
    );
  }

  Widget _buildEmailTextfield(){
    return  TextFormField(
                  decoration: InputDecoration(labelText: 'Email', filled: true, fillColor: Colors.white),
                  keyboardType: TextInputType.emailAddress,
                  onSaved: (String value) {
                    _formData['email'] = value;
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
                  _formData['password'] = value;
                  },
                  validator: (String value){
                    if (value.isEmpty){
                      return 'Needs to be filled out';
                    }
                  },
                );
  }

  Widget _buildPasswordConfirmTextField() {

    return FadeTransition(
      opacity: CurvedAnimation(parent: _controller, curve: Curves.easeIn),
      child: SlideTransition(
        position: _slideAnimation,
        child: TextFormField(
          decoration: InputDecoration(
              labelText: 'Confirm Password',
              filled: true,
              fillColor: Colors.white),
          obscureText: true,
          validator: (String value) {
            if (_passwordTextController.text != value &&
                _authMode == AuthMode.Signup) {
              return 'Passwords do not match.';
            }
          },
        ),
      ),
    );    
  }

  Widget _buildSwitch(){
    return  SwitchListTile(
                  value: _formData['acceptTerms'],
                  onChanged: (bool value) {           
                    setState((){
                      _formData['acceptTerms'] = value;
                    });    
                  },
                  title: Text('accept terms'),
                );
  }

  void _submitForm(Function authenticate) async
  { 
    if (!_authFormKey.currentState.validate() || !_formData['acceptTerms']) {
      return;
    }
    _authFormKey.currentState.save();
    Map<String, dynamic> successInformation;
    successInformation = await authenticate(
        _formData['email'], _formData['password'], _authMode);
    if (successInformation['success']) {
      Navigator.pushReplacementNamed(context, '/');
      } else {
        print('not a success');
        showDialog(
          context: context,
          builder: (BuildContext context){
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
          },
        );
      }
    }


  @override
  Widget build(BuildContext context) {
    final double deviceWidth = MediaQuery.of(context).size.width;
    final double targetWidth = deviceWidth > 550.0 ? 500.0 : deviceWidth *0.95;
    return Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          title: Text('Log In', style: TextStyle(fontFamily: 'Pacifico')),
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
                      Text('Item lister', style: TextStyle(fontFamily: 'Pacifico', fontSize: 25.0),),
                      SizedBox(height: 30.0),
                      _buildEmailTextfield(),
                      SizedBox(
                        height: 11.0
                      ),
                      _buildPassword(),
                      SizedBox(
                        height: 10.0,
                      ),
                      _buildPasswordConfirmTextField(),
                    // _authMode == AuthMode.Signup
                    //     ? _buildPasswordConfirmTextField()
                    //     : Container(),                      
                      _buildSwitch(),
                      SizedBox(
                        height: 25.0,
                      ),
                      FlatButton(
                        child: Text(
                            'Switch to ${_authMode == AuthMode.Login ? 'Signup' : 'Login'}'),
                        onPressed: () {
                          // setState(() {
                          //   _authMode = _authMode == AuthMode.Login
                          //       ? AuthMode.Signup
                          //       : AuthMode.Login;
                          //       print("switch pressed");
                          //   });
                          if (_authMode == AuthMode.Login) {
                            setState(() {
                              _authMode = AuthMode.Signup;
                            });
                            _controller.forward();
                          } else {
                            setState(() {
                              _authMode = AuthMode.Login;
                            });
                            _controller.reverse();
                          }                          
                        },
                      ),
                    SizedBox(
                      height: 10.0,
                    ),                      
                      ScopedModelDescendant<MainModel> (
                        builder: (BuildContext context, Widget child, MainModel model){
                          return model.isLoading?
                          AdaptiveProgressIndicator():
                          RaisedButton(
                            child: Text(_authMode ==AuthMode.Login?
                              'LOGIN':
                              'SIGNUP'
                            ),
                            textColor: Colors.white,
                            onPressed: () => _submitForm(model.authenticate),
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

