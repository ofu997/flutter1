import 'dart:convert';
import 'dart:async';
import 'dart:io'; 
import 'package:scoped_model/scoped_model.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:rxdart/subjects.dart';
import 'package:mime/mime.dart';
import 'package:http_parser/http_parser.dart';
import '../models/product.dart';
import '../models/user.dart';
import '../models/auth.dart';
import '../models/location_data.dart';

import '../models/latlong.dart';

mixin ConnectedProductsModel on Model {
  List<Product> _products = [];
  List<LatLong> _latlongs=[];
  String _selProductId;
  User _authenticatedUser;
  bool _isLoading = false;

  
}

mixin ProductsModel on ConnectedProductsModel {
  bool _showFavorites = false;

  List<Product> get allProducts {
    return List.from(_products);
  }

  List<LatLong> get allLatLongs {
    return List.from(_latlongs);
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

  Future<Map<String, dynamic>> uploadImage(File image, {String imagePath}) async {
    final mimeTypeData = lookupMimeType(image.path).split('/');
    final imageUploadRequest = http.MultipartRequest(
        'POST',
        Uri.parse(
            'https://us-central1-flutterbyof.cloudfunctions.net/storeImage'));
    final file = await http.MultipartFile.fromPath(
      'image',
      image.path,
      contentType: MediaType(
        mimeTypeData[0],
        mimeTypeData[1],
      ),
    );
    imageUploadRequest.files.add(file);
    if (imagePath != null) {
      imageUploadRequest.fields['imagePath'] = Uri.encodeComponent(imagePath);
    }
    imageUploadRequest.headers['Authorization'] =
        'Bearer ${_authenticatedUser.token}';

    try {
      final streamedResponse = await imageUploadRequest.send();
      final response = await http.Response.fromStream(streamedResponse);
      if (response.statusCode != 200 && response.statusCode != 201) {
        print('Something went wrong (connected products)');
        print(json.decode(response.body));
        return null;
      }
      final responseData = json.decode(response.body);
      return responseData;
    } catch (error) {
      print(error);
      return null;
    }
  }

  Future<bool> addProduct(String title, String description, File image, double _price, LocationData locData, String dateTime) 
    async {
    _isLoading = true;
    notifyListeners();	    
    final uploadData = await uploadImage(image);
    // print('uploadData is $uploadData');"selectedproductindex:"
    if (uploadData == null) {
      print('Upload failed!');
      return false;
    }
    final Map<String, dynamic> productData = {
      'title': title,
      'description': description,
      'price': _price, // 4.99 (input a double to avoid a null price),
      'userEmail': _authenticatedUser.email,
      'userId': _authenticatedUser.id,      
      'imagePath': uploadData['imagePath'],
      'imageUrl': uploadData['imageUrl'],
      'loc_lat': locData.latitude,
      'loc_lng': locData.longitude,
      'loc_address': locData.address,
      'dateTime': dateTime,
    };
    print('connected products: productData: $productData');
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
          image: uploadData['imageUrl'],
          imagePath: uploadData['imagePath'],
          price: _price,
          location: locData,
          userEmail: _authenticatedUser.email,
          userId: _authenticatedUser.id,
          dateTime: dateTime);
      _products.add(newProduct);

      final LatLong newLatLong = LatLong(lat: locData.latitude,long: locData.longitude);
      _latlongs.add(newLatLong);
      //print(newProduct.price);
      _isLoading = false;
      notifyListeners();
      return true;
    } catch (error) {
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  Future<bool> updateProduct(String title, String description, File image,
  double price, LocationData locData) async{
    _isLoading = true;
    notifyListeners();
    String imageUrl = selectedProduct.image;
    String imagePath = selectedProduct.imagePath;
    if (image != null) {
      final uploadData = await uploadImage(image);

      if (uploadData == null) {
        print('Upload failed!');
        return false;
      }

      imageUrl = uploadData['imageUrl'];
      imagePath = uploadData['imagePath'];
    }   
    final Map<String, dynamic> updateData = {
      'title': title,
      'description': description,
      'imageUrl': imageUrl,
      'imagePath': imagePath,
      'price': price,
      'loc_lat': locData.latitude,
      'loc_lng': locData.longitude,
      'loc_address': locData.address,
      'userEmail': selectedProduct.userEmail,
      'userId': selectedProduct.userId,
      'dateTime': selectedProduct.dateTime,
    };

    try {
      await http.put(
        'https://flutterbyof.firebaseio.com/products/${selectedProduct.id}.json?auth=${_authenticatedUser.token}',
        body: json.encode(updateData)
      );

      _isLoading = false;
      final Product updatedProduct = Product(
          id: selectedProduct.id,
          title: title,
          description: description,
          image: imageUrl,
          imagePath: imagePath,
          price: price,
          location: locData,
          userEmail: selectedProduct.userEmail,
          userId: selectedProduct.userId,
          dateTime: selectedProduct.dateTime);
      _products[selectedProductIndex] = updatedProduct;
      notifyListeners();
      return true;
    } catch(error) {
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  Future<bool> deleteProduct() {
    _isLoading = true;
    final deletedProductId = selectedProduct.id;
    _products.removeAt(selectedProductIndex);
    _selProductId = null;
    notifyListeners();
    return http
        .delete(
            'https://flutterbyof.firebaseio.com/products/$deletedProductId.json?auth=${_authenticatedUser.token}')
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

  Future<Null> fetchProducts({onlyForUser = false, clearExisting = false}) {
    _isLoading = true;
    if (clearExisting) {
      _products = [];
    }
    notifyListeners();
    //print("printing _authenticatedUser.token from connected_products fetchProducts" + _authenticatedUser.token);
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
            image: productData['imageUrl'],
            imagePath: productData['imagePath'],
            price: productData['price'],
            location: LocationData(
                address: productData['loc_address'],
                latitude: productData['loc_lat'],
                longitude: productData['loc_lng']),
            userEmail: productData['userEmail'],
            userId: productData['userId'],
            dateTime: productData['dateTime'],
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

    Future<Null> fetchAllLocations() {
    _isLoading = true;

    notifyListeners();
    //print("printing _authenticatedUser.token from connected_products fetchProducts" + _authenticatedUser.token);
    return http
        .get(
            'https://flutterbyof.firebaseio.com/products.json?auth=${_authenticatedUser.token}')
        .then<Null>((http.Response response) {
      final List<LatLong> allLocationsList = [];
      final Map<String, dynamic> productListData = json.decode(response.body);

      if (productListData == null) {
        _isLoading = false;
        notifyListeners();
        return;
      }
      productListData.forEach((String productId, dynamic productData) {
        final LatLong latLong = LatLong(
          lat: productData['loc_lat'],
          long: productData['loc_lng']
        );
        allLocationsList.add(latLong);
      });
      _isLoading = false;
      notifyListeners();
      _selProductId = null;
    }).catchError((error) {
      _isLoading = false;
      notifyListeners();
      return;
    });
  }

  void toggleProductFavoriteStatus(Product toggledProduct) async {
    final bool isCurrentlyFavorite = toggledProduct.isFavorite;
    final bool newFavoriteStatus = !isCurrentlyFavorite;
    // NEWLY ADDED => Get the index of the product passed into the method
    final int toggledProductIndex = _products.indexWhere((Product product) {
      return product.id == toggledProduct.id;
    });
    final Product updatedProduct = Product(
        id: toggledProduct.id,
        title: toggledProduct.title,
        description: toggledProduct.description,
        price: toggledProduct.price,
        image: toggledProduct.image,
        imagePath: toggledProduct.imagePath,
        location: toggledProduct.location,
        userEmail: toggledProduct.userEmail,
        userId: toggledProduct.userId,
        dateTime: toggledProduct.dateTime,
        isFavorite: newFavoriteStatus);
    _products[toggledProductIndex] = updatedProduct; // Use the "toggledProductIndex" derived earlier in the method
    notifyListeners();
    http.Response response;
    if (newFavoriteStatus) {
      response = await http.put(
        'https://flutterbyof.firebaseio.com/products/${selectedProduct.id}/wishlistUsers/${_authenticatedUser.id}.json?auth=${_authenticatedUser.token}',
        body: json.encode(true)
      );
    } else {
      response = await http.delete(
        'https://flutterbyof.firebaseio.com/products/${selectedProduct.id}/wishlistUsers/${_authenticatedUser.id}.json?auth=${_authenticatedUser.token}'
      );
    }
    if (response.statusCode != 200 && response.statusCode != 201) {
      final Product updatedProduct = Product(
          id: toggledProduct.id,
          title: toggledProduct.title,
          description: toggledProduct.description,
          price: toggledProduct.price,
          image: toggledProduct.image,
          imagePath: toggledProduct.imagePath,
          location: toggledProduct.location,
          userEmail: toggledProduct.userEmail,
          userId: toggledProduct.userId,
          dateTime: toggledProduct.dateTime,
          isFavorite: !newFavoriteStatus);
      _products[toggledProductIndex] = updatedProduct;
      notifyListeners();
    }
    // _selProductId = null; => This has to be removed/ commented out!
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
    String message = 'Something went wrong (responseData)';
    
    print('the responsedata is $responseData');
    
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
    // print(token);
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
    _selProductId=null;
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
