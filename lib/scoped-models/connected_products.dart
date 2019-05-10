// import 'package:scoped_model/scoped_model.dart';
// import 'package:second_app/models/product.dart';
// import 'package:second_app/models/user.dart';
// import 'package:http/http.dart' as http;
// import 'package:shared_preferences/shared_preferences.dart';
// import 'package:rxdart/subjects.dart';

// import '../models/product.dart';
// import '../models/user.dart';
// import '../models/auth.dart';
// import '../models/location_data.dart';

// import 'dart:convert';
// import 'dart:async';

// mixin ConnectedProductsModel on Model{
//   int _count = 0;
//   List<Product> _products = [];
//   String _selProductId;
//   User _authenticatedUser;
//   bool _isLoading = false;
// }

// mixin ProductsModel on ConnectedProductsModel {
//   bool _showFavorites = false;

//   List<Product> get allProducts {
//     return List.from(_products);
//   }

//   List<Product> get displayedProducts {
//     if (_showFavorites) {
//       return _products.where((Product product) => product.isFavorite).toList();
//     }
//     return List.from(_products);
//   }  

//   int get selectedProductIndex {
//     return _products.indexWhere((Product product){
//       return product.id == _selProductId;
//     });
//   }

//   String get selectedProductId {
//     return _selProductId;
//   }

//   Product get selectedProduct {
//     if (selectedProductId == null ) {//|| _products.isEmpty
//       return null;
//     }
//     return _products.firstWhere((Product product) {
//       return product.id == _selProductId;
//       //orElse: () => print('No matching element.')
//     });    
//   }

//   bool get displayFavoritesOnly {
//     return _showFavorites;
//   }

//   Future<bool> addProduct(String title, String description, String image, double price, LocationData locData) async {
//       _isLoading = true;
//       DateTime timeStamp = new DateTime.now();
//       String dateSlug = "${timeStamp.month.toString()}-${timeStamp.day.toString()}-${timeStamp.year.toString}+" " + ${timeStamp.hour.toString()}+ ${timeStamp.minute.toString()}";
//       print(dateSlug);
//       notifyListeners();  
//       final Map<String,dynamic> productData = {//we send this object to Firebase
//         'title': title,
//         'description': description,
//         'image': 'https://upload.wikimedia.org/wikipedia/commons/6/68/Chocolatebrownie.JPG',
//         'price': price,
//         'userEmail': _authenticatedUser.email,
//         'userId': _authenticatedUser.id,
//         'loc_lat': locData.latitude,
//         'loc_lng': locData.longitude,
//         'loc_address': locData.address
//         //'dateTime': dateSlug
//       };
//       try{
//         final http.Response response = await http.post(
//           'https://flutterbyof.firebaseio.com/products.json?auth=${_authenticatedUser.token}', 
//           body: json.encode(productData)
//         );
        
//         if (response.statusCode != 200 && response.statusCode != 201) {
//           _isLoading = false;
//           notifyListeners();
//           return false;
//         }
//         final Map<String, dynamic> responseData = json.decode(response.body);
//         print(responseData);
//         final Product newProduct = Product(
//             id: responseData['name'],
//             title: title,
//             description: description,
//             image: image,
//             price: price,
//             location: locData,
//             userEmail: _authenticatedUser.email,
//             userId: _authenticatedUser.id,
//             //dateTime: dateSlug,
//             );

//         _products.add(newProduct);
//         _count++;
//         print(' addProduct() text count: ' + _count.toString() + ' ' + DateTime.now().toIso8601String());
//         _isLoading = false;
//         notifyListeners();
//         return true;
//       }
//       catch (error) {
//       _isLoading = false;
//       notifyListeners();
//       return false;
//     }
//   }

//   Future<bool> updateProduct(String title, String description, String image, double price, LocationData locData) {
//     _isLoading = true;
//     notifyListeners();
//     final Map<String,dynamic> updateData = {
//         'title': title,
//         'description': description,
//         'image':  'https://upload.wikimedia.org/wikipedia/commons/6/68/Chocolatebrownie.JPG',
//         'price': price,
//         'loc_lat': locData.latitude,
//         'loc_lng': locData.longitude,
//         'loc_address': locData.address,
//         'userEmail': _authenticatedUser.email,
//         'userId': _authenticatedUser.id
//     };
//     print(title+" is updated");
//     return http.put(
//             'https://flutterbyof.firebaseio.com/products/${selectedProduct.id}.json?auth=${_authenticatedUser.token}', 
//             body: json.encode(updateData)
//           )
//           .then((http.Response response){
//             _isLoading = false;

//             final Product updatedProduct = Product(
//               id: selectedProduct.id,
//               title: title,
//               description: description,
//               image: image,
//               price: price,
//               location: locData, 
//               userEmail: selectedProduct.userEmail,
//               userId: selectedProduct.userId);

//             _products[selectedProductIndex] = updatedProduct;
//             notifyListeners();
//             print(updatedProduct.id);
//             return true;
//           }).catchError((error) {
//             _isLoading = false;
//             notifyListeners();
//             return false;
//           });
//   }

//   Future<bool> deleteProduct() {
//     _isLoading = true;
//     final deletedProductId = selectedProduct.id;
//     _products.removeAt(selectedProductIndex);
    
//     _selProductId = null;
//     notifyListeners();
//     return http
//       .delete(
//           'https://flutterbyof.firebaseio.com/products/${deletedProductId}.json?auth=${_authenticatedUser.token}')
//       .then((http.Response response) {
//       _isLoading = false;
//       notifyListeners();
//       return true;
//       }).catchError((error) {
//       _isLoading = false;
//       notifyListeners();
//       return false;
//       });    
//   }

//   Future<Null> fetchProducts({onlyForUser = false}) {
//     _isLoading = true;
//     notifyListeners();
//     //print("printing _authenticatedUser.token from connected_products fetchProducts" + _authenticatedUser.token);
//     return http
//         .get('https://flutterbyof.firebaseio.com/products.json?auth=${_authenticatedUser.token}')
//         .then<Null>((http.Response response) {
//       final List<Product> fetchedProductList = [];
//       final Map<String, dynamic> productListData = json.decode(response.body);
//       if (productListData == null) {
//         _isLoading = false;
//         notifyListeners();
//         return;
//       }
//       productListData.forEach((String productId, dynamic productData) {
//         final Product product = Product(
//             id: productId,
//             title: productData['title'],
//             description: productData['description'],
//             image: productData['image'],
//             price: productData['price'],
//             location: LocationData(
//                 address: productData['loc_address'],
//                 latitude: productData['loc_lat'],
//                 longitude: productData['loc_lng']),            
//             userEmail: productData['userEmail'],
//             userId: productData['userId'],
//             isFavorite: productData['wishlistUsers']==null?false:
//               (productData['wishlistUsers'] as Map<String, dynamic>)
//                 .containsKey(_authenticatedUser.id)
//             );
//         fetchedProductList.add(product);
//         print(fetchedProductList.length.toString());
//       });
//       _products = onlyForUser? fetchedProductList.where((Product product) {
//         return product.userId == _authenticatedUser.id;}).toList() 
//         : fetchedProductList;
//       _isLoading = false;
//       notifyListeners();
//       _selProductId = null;
//     }).catchError((error) {
//       _isLoading = false;
//       notifyListeners();
//       return;
//     });
//   }

//   void toggleProductFavoriteStatus() async {
//     final bool isCurrentlyFavorite = selectedProduct.isFavorite;
//     final bool newFavoriteStatus = !isCurrentlyFavorite;
//     final Product updatedProduct = Product(
//         id: selectedProduct.id,
//         title: selectedProduct.title,
//         description: selectedProduct.description,
//         price: selectedProduct.price,
//         image: selectedProduct.image,
//         location: selectedProduct.location,
//         userEmail: selectedProduct.userEmail,
//         userId: selectedProduct.userId,
//         isFavorite: newFavoriteStatus);
//     _products[selectedProductIndex] = updatedProduct;
//     notifyListeners();
//     http.Response response;
//     if (newFavoriteStatus) {
//       response = await http.put(
//           'https://flutterbyof.firebaseio.com/products/${selectedProduct.id}/wishlistUsers/${_authenticatedUser.id}.json?auth=${_authenticatedUser.token}',
//           body: json.encode(true));
//     } else {
//       response = await http.delete(
//           'https://flutterbyof.firebaseio.com/products/${selectedProduct.id}/wishlistUsers/${_authenticatedUser.id}.json?auth=${_authenticatedUser.token}');
//     }
//     if (response.statusCode != 200 && response.statusCode != 201) {
//       final Product updatedProduct = Product(
//           id: selectedProduct.id,
//           title: selectedProduct.title,
//           description: selectedProduct.description,
//           price: selectedProduct.price,
//           image: selectedProduct.image,
//           location: selectedProduct.location,
//           userEmail: selectedProduct.userEmail,
//           userId: selectedProduct.userId,
//           isFavorite: !newFavoriteStatus);
//       _products[selectedProductIndex] = updatedProduct;
//       notifyListeners();
//     }
//   }

//   void selectProduct(String productId) {
//     _selProductId = productId;
//     if (productId != null){
//       notifyListeners();
//     }
//   }

//   void toggleDisplayMode() {
//     _showFavorites = !_showFavorites;
//     notifyListeners();
//   }
// }

// mixin UserModel on ConnectedProductsModel {
//   Timer _authTimer;
//   PublishSubject<bool> _userSubject = PublishSubject();

//   User get user {
//     return _authenticatedUser;
//   }

//   PublishSubject<bool> get userSubject {
//     return _userSubject;
//   }

//   Future<Map<String, dynamic>> authenticate (String email, String password, [AuthMode mode = AuthMode.Login]) async {
//     _isLoading = true;
//     notifyListeners();
//     final Map<String, dynamic> authData = {
//       'email': email,
//       'password': password,
//       'returnSecureToken': true
//     };
//     print(mode);
//     http.Response response;
//     if (mode == AuthMode.Login){
//       response = await http.post(
//         'https://www.googleapis.com/identitytoolkit/v3/relyingparty/verifyPassword?key=AIzaSyC6uawrA3OJMCH7lyFbzpkyg7k5OS1mWqQ',
//         body: json.encode(authData),
//         headers: {'Content-Type': 'application/json'},
//       );
//       print('log in works' + authData.toString());
//     } 
//     else 
//     {
//       response = await http.post(
//         'https://www.googleapis.com/identitytoolkit/v3/relyingparty/signupNewUser?key=AIzaSyC6uawrA3OJMCH7lyFbzpkyg7k5OS1mWqQ',
//         body: json.encode(authData),
//         headers: {'Content-Type': 'application/json'},          
//       );
//       print("authData is: "+ authData.toString() +' signup worked');
//     }
    
      
      
    
//     print("printing response.body from connected_products" + response.body);
//     final Map<String, dynamic> responseData = json.decode(response.body);
//     bool hasError = true;
//     String message = 'Something went wrong.';
//     print("responseData is " + responseData.toString());
//     if (responseData.containsKey('idToken')) {
//       hasError = false;
//       print('authentication succeeded');
//       message = 'Authentication succeeded!';
//      _authenticatedUser = User(
//       id: responseData['localId'],
//       email: email,
//       token: responseData['idToken']);

//       print("connected_products.authenticate: " + _authenticatedUser.token);

//       setAuthTimeout(int.parse(responseData['expiresIn']));
//       _userSubject.add(true);
//       final DateTime now = DateTime.now();
//       final DateTime expiryTime =
//           now.add(Duration(seconds: int.parse(responseData['expiresIn'])));
//       final SharedPreferences prefs = await SharedPreferences.getInstance();
//       prefs.setString('token', responseData['idToken']);
//       prefs.setString('userEmail', email);
//       prefs.setString('userId', responseData['localId']);
//       prefs.setString('expiryTime', expiryTime.toIso8601String());
//     } else if (responseData['error']['message'] == 'EMAIL_EXISTS') {
//       message = 'This email already exists.';
//     } else if (responseData['error']['message'] == 'EMAIL_NOT_FOUND') {
//       message = 'This email was not found.';
//     } else if (responseData['error']['message'] == 'INVALID_PASSWORD') {
//       message = 'The password is invalid.';
//     }
//     _isLoading = false;
//     notifyListeners();
//     return {'success': !hasError, 'message': message};
//   }

//   void autoAuthenticate() async {
//     final SharedPreferences prefs = await SharedPreferences.getInstance();
//     final String token = prefs.getString('token');
//     print(token);
//     final String expiryTimeString = prefs.getString('expiryTime');
//     if (token != null) {
//       final DateTime now = DateTime.now();
//       final parsedExpiryTime = DateTime.parse(expiryTimeString);
//       if (parsedExpiryTime.isBefore(now)) {
//         _authenticatedUser = null;
//         notifyListeners();
//         return;
//       }
//       final String userEmail = prefs.getString('userEmail');
//       final String userId = prefs.getString('userId');
//       final int tokenLifespan = parsedExpiryTime.difference(now).inSeconds;
//       _authenticatedUser = User(id: userId, email: userEmail, token: token);
//       _userSubject.add(true);
//       setAuthTimeout(tokenLifespan);
//       notifyListeners();
//     }
//   }

//    void logout() async {
//     _authenticatedUser = null;
//     _authTimer.cancel();
//     _userSubject.add(false);
//     final SharedPreferences prefs = await SharedPreferences.getInstance();
//     prefs.remove('token');
//     prefs.remove('userEmail');
//     prefs.remove('userId');
//   }

//    void setAuthTimeout(int time) {
//     _authTimer = Timer(Duration(seconds: time), logout);
//   }
// }

// mixin UtilityModel on ConnectedProductsModel {
//   bool get isLoading {
//     return _isLoading;
//   }
// }

import 'dart:convert';
import 'dart:async';

import 'package:scoped_model/scoped_model.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:rxdart/subjects.dart';

import '../models/product.dart';
import '../models/user.dart';
import '../models/auth.dart';
import '../models/location_data.dart';

mixin ConnectedProductsModel on Model {
  List<Product> _products = [];
  String _selProductId;
  User _authenticatedUser;
  bool _isLoading = false;
}

mixin ProductsModel on ConnectedProductsModel {
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
    return _products.indexWhere((Product product) {
      return product.id == _selProductId;
    });
  }

  String get selectedProductId {
    return _selProductId;
  }

  Product get selectedProduct {
    if (selectedProductId == null) {
      return null;
    }

    return _products.firstWhere((Product product) {
      return product.id == _selProductId;
    });
  }

  bool get displayFavoritesOnly {
    return _showFavorites;
  }

  Future<bool> addProduct(String title, String description, String image,
      double price, LocationData locData) async {
    _isLoading = true;
    notifyListeners();
    final Map<String, dynamic> productData = {
      'title': title,
      'description': description,
      'image':
          'https://upload.wikimedia.org/wikipedia/commons/6/68/Chocolatebrownie.JPG',
      'price': price,
      'userEmail': _authenticatedUser.email,
      'userId': _authenticatedUser.id,
      'loc_lat': locData.latitude,
      'loc_lng': locData.longitude,
      'loc_address': locData.address
    };
    try {
      final http.Response response = await http.post(
          'https://flutterbyof.firebaseio.com/products.json?auth=${_authenticatedUser.token}',
          body: json.encode(productData));

      if (response.statusCode != 200 && response.statusCode != 201) {
        _isLoading = false;
        notifyListeners();
        return false;
      }
      final Map<String, dynamic> responseData = json.decode(response.body);
      final Product newProduct = Product(
          id: responseData['name'],
          title: title,
          description: description,
          image: image,
          price: price,
          location: locData,
          userEmail: _authenticatedUser.email,
          userId: _authenticatedUser.id);
      _products.add(newProduct);
      _isLoading = false;
      notifyListeners();
      return true;
    } catch (error) {
      _isLoading = false;
      notifyListeners();
      return false;
    }
    // .catchError((error) {
    //   _isLoading = false;
    //   notifyListeners();
    //   return false;
    // });
  }

  Future<bool> updateProduct(String title, String description, String image,
      double price, LocationData locData) {
    _isLoading = true;
    notifyListeners();
    final Map<String, dynamic> updateData = {
      'title': title,
      'description': description,
      'image':
          'https://upload.wikimedia.org/wikipedia/commons/6/68/Chocolatebrownie.JPG',
      'price': price,
      'loc_lat': locData.latitude,
      'loc_lng': locData.longitude,
      'loc_address': locData.address,
      'userEmail': selectedProduct.userEmail,
      'userId': selectedProduct.userId
    };
    return http
        .put(
            'https://flutterbyof.firebaseio.com/products/${selectedProduct.id}.json?auth=${_authenticatedUser.token}',
            body: json.encode(updateData))
        .then((http.Response reponse) {
      _isLoading = false;
      final Product updatedProduct = Product(
          id: selectedProduct.id,
          title: title,
          description: description,
          image: image,
          price: price,
          location: locData,
          userEmail: selectedProduct.userEmail,
          userId: selectedProduct.userId);
      _products[selectedProductIndex] = updatedProduct;
      notifyListeners();
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
            'https://flutterbyof.firebaseio.com/products/${deletedProductId}.json?auth=${_authenticatedUser.token}')
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
    print("printing _authenticatedUser.token from connected_products fetchProducts" + _authenticatedUser.token);
    return http
        .get(
            'https://flutterbyof.firebaseio.com/products.json?auth=${_authenticatedUser.token}')
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
            location: LocationData(
                address: productData['loc_address'],
                latitude: productData['loc_lat'],
                longitude: productData['loc_lng']),
            userEmail: productData['userEmail'],
            userId: productData['userId'],
            isFavorite: productData['wishlistUsers'] == null
                ? false
                : (productData['wishlistUsers'] as Map<String, dynamic>)
                    .containsKey(_authenticatedUser.id));
        fetchedProductList.add(product);
      });
      _products = onlyForUser
          ? fetchedProductList.where((Product product) {
              return product.userId == _authenticatedUser.id;
            }).toList()
          : fetchedProductList;
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
        location: selectedProduct.location,
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
          location: selectedProduct.location,
          userEmail: selectedProduct.userEmail,
          userId: selectedProduct.userId,
          isFavorite: !newFavoriteStatus);
      _products[selectedProductIndex] = updatedProduct;
      notifyListeners();
    }
  }

  void selectProduct(String productId) {
    _selProductId = productId;
    if (productId != null) {
      notifyListeners();
    }
  }

  void toggleDisplayMode() {
    _showFavorites = !_showFavorites;
    notifyListeners();
  }
}

mixin UserModel on ConnectedProductsModel {
  Timer _authTimer;
  PublishSubject<bool> _userSubject = PublishSubject();

  User get user {
    return _authenticatedUser;
  }

  PublishSubject<bool> get userSubject {
    return _userSubject;
  }

  Future<Map<String, dynamic>> authenticate(String email, String password,
      [AuthMode mode = AuthMode.Login]) async {
    _isLoading = true;
    notifyListeners();
    final Map<String, dynamic> authData = {
      'email': email,
      'password': password,
      'returnSecureToken': true
    };
    http.Response response;
    if (mode == AuthMode.Login) {
      response = await http.post(
        'https://www.googleapis.com/identitytoolkit/v3/relyingparty/verifyPassword?key=AIzaSyC6uawrA3OJMCH7lyFbzpkyg7k5OS1mWqQ',
        body: json.encode(authData),
        headers: {'Content-Type': 'application/json'},
      );
      print('log in works' + authData.toString());
    } else {
      response = await http.post(
        'https://www.googleapis.com/identitytoolkit/v3/relyingparty/signupNewUser?key=AIzaSyC6uawrA3OJMCH7lyFbzpkyg7k5OS1mWqQ',
        body: json.encode(authData),
        headers: {'Content-Type': 'application/json'},
      );
    }

    final Map<String, dynamic> responseData = json.decode(response.body);
    bool hasError = true;
    String message = 'Something went wrong.';
    print('the responsedata');
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
    print(token);
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
      print("TOKEN EXISTS == $token");
      _authenticatedUser = User(id: userId, email: userEmail, token: token);
      _userSubject.add(true);
      setAuthTimeout(tokenLifespan);
      notifyListeners();
    }
    else{
      print('user token not here');
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

mixin UtilityModel on ConnectedProductsModel {
  bool get isLoading {
    return _isLoading;
  }
}
