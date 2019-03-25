import 'package:scoped_model/scoped_model.dart';
import 'package:second_app/models/product.dart';
import 'package:second_app/models/user.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:rxdart/subjects.dart';

import '../models/product.dart';
import '../models/user.dart';
import '../models/auth.dart';

import 'dart:convert';
import 'dart:async';

class ConnectedProductsModel extends Model{
  int _count = 0;
  List<Product> _products = [];
  String _selProductId;
  User _authenticatedUser;
  bool _isLoading = false;
}

class ProductsModel extends ConnectedProductsModel {
  bool _showFavorites = false;

  List<Product> get allProducts {
    return List.from(_products);
  }

  List<Product> get displayedProducts {
    if (_showFavorites) {
      return _products.where((Product product) => product.isFavorite).toList();
    }
    return List.from(_products);
  }  

  int get selectedProductIndex {
    return _products.indexWhere((Product product){
      return product.id == _selProductId;
    });
  }

  String get selectedProductId {
    return _selProductId;
  }

  Product get selectedProduct {
    if (selectedProductId == null ) {//|| _products.isEmpty
      return null;
    }
    return _products.firstWhere((Product product) {
      return product.id == _selProductId;
      //orElse: () => print('No matching element.')
    });    
  }

  bool get displayFavoritesOnly {
    return _showFavorites;
  }

  Future<bool> addsProducts(String title, String description, String image, double price) async {
      _isLoading = true;
      DateTime timeStamp = new DateTime.now();
      String dateSlug = "${timeStamp.month.toString()}-${timeStamp.day.toString()}-${timeStamp.year.toString}+" " + ${timeStamp.hour.toString()}+ ${timeStamp.minute.toString()}";
      print(dateSlug);
      notifyListeners();  
      final Map<String,dynamic> productData = {//we send this object to Firebase
        'title': title,
        'description': description,
        'image': 'https://upload.wikimedia.org/wikipedia/commons/6/68/Chocolatebrownie.JPG',
        'price': price,
        'userEmail': _authenticatedUser.email,
        'userId': _authenticatedUser.id,
        //'dateTime': dateSlug
      };
      try{
        final http.Response response = await http.post(
          'https://flutterbyof.firebaseio.com/products.json?auth=${_authenticatedUser.token}', 
          body: json.encode(productData)
        );
        
        if (response.statusCode != 200 && response.statusCode != 201) {
          _isLoading = false;
          notifyListeners();
          return false;
        }
        final Map<String, dynamic> responseData = json.decode(response.body);
        print(responseData);
        final Product newProduct = Product(
            id: responseData['name'],
            title: title,
            description: description,
            image: image,
            price: price,
            userEmail: _authenticatedUser.email,
            userId: _authenticatedUser.id,
            //dateTime: dateSlug,
            );

        _products.add(newProduct);
        _count++;
        print(' addProduct() text count: ' + _count.toString() + ' ' + DateTime.now().toIso8601String());
        _isLoading = false;
        notifyListeners();
        return true;
      }
      catch (error) {
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  Future<bool> updateProduct(String title, String description, String image, double price) {
    _isLoading = true;
    notifyListeners();
    final Map<String,dynamic> updateData = {
        'title': title,
        'description': description,
        'image':  'https://upload.wikimedia.org/wikipedia/commons/6/68/Chocolatebrownie.JPG',
        'price': price,
        'userEmail': _authenticatedUser.email,
        'userId': _authenticatedUser.id
    };
    print(title+" is updated");
    return http.put(
            'https://flutterbyof.firebaseio.com/products/${selectedProduct.id}.json?auth=${_authenticatedUser.token}', 
            body: json.encode(updateData)
          )
          .then((http.Response response){
            _isLoading = false;

            final Product updatedProduct = Product(
              id: selectedProduct.id,
              title: title,
              description: description,
              image: image,
              price: price,
              userEmail: selectedProduct.userEmail,
              userId: selectedProduct.userId);

            _products[selectedProductIndex] = updatedProduct;
            notifyListeners();
            print(updatedProduct.id);
            return true;
          }).catchError((error) {
            _isLoading = false;
            notifyListeners();
            return false;
          });
  }

  Future<bool> deleteProduct() {
    _isLoading = true;
    final deletedProductId = selectedProduct.id;
    _products.removeAt(selectedProductIndex);
    
    _selProductId = null;
    notifyListeners();
    return http
      .delete(
          'https://flutterbyof.firebaseio.com/products/${deletedProductId}.json?auth=$(_authenticatedUser.token)')
      .then((http.Response response) {
      _isLoading = false;
      notifyListeners();
      return true;
      }).catchError((error) {
      _isLoading = false;
      notifyListeners();
      return false;
      });    
  }

  Future<Null> fetchProducts({onlyForUser = false}) {
    _isLoading = true;
    notifyListeners();
    return http
        .get('https://flutterbyof.firebaseio.com/products.json?auth=${_authenticatedUser.token}')
        .then<Null>((http.Response response) {
      final List<Product> fetchedProductList = [];
      final Map<String, dynamic> productListData = json.decode(response.body);
      if (productListData == null) {
        _isLoading = false;
        notifyListeners();
        return;
      }
      productListData.forEach((String productId, dynamic productData) {
        final Product product = Product(
            id: productId,
            title: productData['title'],
            description: productData['description'],
            image: productData['image'],
            price: productData['price'],
            userEmail: productData['userEmail'],
            userId: productData['userId'],
            isFavorite: productData['wishlistUsers']==null?false:
              (productData['wishlistUsers'] as Map<String, dynamic>)
                .containsKey(_authenticatedUser.id)
            );
        fetchedProductList.add(product);
        print(fetchedProductList.length.toString());
      });
      _products = onlyForUser? fetchedProductList.where((Product product) {
        return product.userId == _authenticatedUser.id;}).toList() : fetchedProductList;
      _isLoading = false;
      notifyListeners();
      _selProductId = null;
    }).catchError((error) {
      _isLoading = false;
      notifyListeners();
      return;
    });
  }

  void toggleProductFavoriteStatus() async {
    final bool isCurrentlyFavorite = selectedProduct.isFavorite;
    final bool newFavoriteStatus = !isCurrentlyFavorite;
    final Product updatedProduct = Product(
        id: selectedProduct.id,
        title: selectedProduct.title,
        description: selectedProduct.description,
        price: selectedProduct.price,
        image: selectedProduct.image,
        userEmail: selectedProduct.userEmail,
        userId: selectedProduct.userId,
        isFavorite: newFavoriteStatus);
    _products[selectedProductIndex] = updatedProduct;
    notifyListeners();
    http.Response response;
    if (newFavoriteStatus) {
      response = await http.put(
          'https://flutterbyof.firebaseio.com/products/${selectedProduct.id}/wishlistUsers/${_authenticatedUser.id}.json?auth=${_authenticatedUser.token}',
          body: json.encode(true));
    } else {
      response = await http.delete(
          'https://flutterbyof.firebaseio.com/products/${selectedProduct.id}/wishlistUsers/${_authenticatedUser.id}.json?auth=${_authenticatedUser.token}');
    }
    if (response.statusCode != 200 && response.statusCode != 201) {
      final Product updatedProduct = Product(
          id: selectedProduct.id,
          title: selectedProduct.title,
          description: selectedProduct.description,
          price: selectedProduct.price,
          image: selectedProduct.image,
          userEmail: selectedProduct.userEmail,
          userId: selectedProduct.userId,
          isFavorite: !newFavoriteStatus);
      _products[selectedProductIndex] = updatedProduct;
      notifyListeners();
    }
  }

  void selectProduct(String productId) {
    _selProductId = productId;
    notifyListeners();
  }

  void toggleDisplayMode() {
    _showFavorites = !_showFavorites;
    notifyListeners();
  }
}

class UserModel extends ConnectedProductsModel {
  Timer _authTimer;
  PublishSubject<bool> _userSubject = PublishSubject();

  User get user {
    return _authenticatedUser;
  }

  PublishSubject<bool> get userSubject {
    return _userSubject;
  }

  Future<Map<String, dynamic>> authenticate (String email, String password, [AuthMode mode = AuthMode.Login]) async {
    _isLoading = true;
    notifyListeners();
    final Map<String, dynamic> authData = {
      'email': email,
      'password': password,
      'returnSecureToken': true
    };
    http.Response response;
    if (mode == AuthMode.Login){
      response = await http.post(
        'https://www.googleapis.com/identitytoolkit/v3/relyingparty/signupNewUser?key=AIzaSyC6uawrA3OJMCH7lyFbzpkyg7k5OS1mWqQ',
        body: json.encode(authData),
        headers: {'Content-Type': 'application/json'},
      );
    } 
    else 
    {
      response = await http.post(
        'https://www.googleapis.com/identitytoolkit/v3/relyingparty/signupNewUser?key=AIzaSyC6uawrA3OJMCH7lyFbzpkyg7k5OS1mWqQ',
        body: json.encode(authData),
        headers: {'Content-Type': 'application/json'},          
      );
    }
    
      
      
    
    print(response.body);
    final Map<String, dynamic> responseData = json.decode(response.body);
    bool hasError = true;
    String message = 'Something went wrong.';
    print(responseData);
    if (responseData.containsKey('idToken')) {
      hasError = false;
      message = 'Authentication succeeded!';
     _authenticatedUser = User(
      id: responseData['localId'],
      email: email,
      token: responseData['idToken']);
      setAuthTimeout(int.parse(responseData['expiresIn']));
      _userSubject.add(true);
      final DateTime now = DateTime.now();
      final DateTime expiryTime =
          now.add(Duration(seconds: int.parse(responseData['expiresIn'])));
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setString('token', responseData['idToken']);
      prefs.setString('userEmail', email);
      prefs.setString('userId', responseData['localId']);
      prefs.setString('expiryTime', expiryTime.toIso8601String());
    } else if (responseData['error']['message'] == 'EMAIL_EXISTS') {
      message = 'This email already exists.';
    } else if (responseData['error']['message'] == 'EMAIL_NOT_FOUND') {
      message = 'This email was not found.';
    } else if (responseData['error']['message'] == 'INVALID_PASSWORD') {
      message = 'The password is invalid.';
    }
    _isLoading = false;
    notifyListeners();
    return {'success': !hasError, 'message': message};
  }

  void autoAuthenticate() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String token = prefs.getString('token');
    final String expiryTimeString = prefs.getString('expiryTime');
    if (token != null) {
      final DateTime now = DateTime.now();
      final parsedExpiryTime = DateTime.parse(expiryTimeString);
      if (parsedExpiryTime.isBefore(now)) {
        _authenticatedUser = null;
        notifyListeners();
        return;
      }
      final String userEmail = prefs.getString('userEmail');
      final String userId = prefs.getString('userId');
      final int tokenLifespan = parsedExpiryTime.difference(now).inSeconds;
      _authenticatedUser = User(id: userId, email: userEmail, token: token);
      _userSubject.add(true);
      setAuthTimeout(tokenLifespan);
      notifyListeners();
    }
  }

   void logout() async {
    _authenticatedUser = null;
    _authTimer.cancel();
    _userSubject.add(false);
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.remove('token');
    prefs.remove('userEmail');
    prefs.remove('userId');
  }

   void setAuthTimeout(int time) {
    _authTimer = Timer(Duration(seconds: time), logout);
  }
}

class UtilityModel extends ConnectedProductsModel {
  bool get isLoading {
    return _isLoading;
  }
}