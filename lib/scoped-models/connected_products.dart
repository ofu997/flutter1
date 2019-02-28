import 'package:scoped_model/scoped_model.dart';
// import '../models/product.dart';
// import '../models/user.dart';
import 'package:second_app/models/product.dart';
import 'package:second_app/models/user.dart';
import 'package:http/http.dart' as http;
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
      notifyListeners();  
      final Map<String,dynamic> productData = {//we send this object to Firebase
        'title': title,
        'description': description,
        'image': 'https://upload.wikimedia.org/wikipedia/commons/6/68/Chocolatebrownie.JPG',
        'price': price,
        'userEmail': _authenticatedUser.email,
        'userId': _authenticatedUser.id
      };
      try{
        final http.Response response = await 
          http
            .post(
            'https://flutterbyof.firebaseio.com/products.json', 
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
            userId: _authenticatedUser.id);
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
    return http
      .put(
            'https://flutterbyof.firebaseio.com/products.json', 
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
          'https://flutterbyof.firebaseio.com/products/${deletedProductId}.json')
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

  Future<Null> fetchProducts() {
    _isLoading = true;
    notifyListeners();
    return http
        .get('https://flutterbyof.firebaseio.com/products.json')
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
            userId: productData['userId']);
        fetchedProductList.add(product);
      });
      _products = fetchedProductList;
      //_isLoading = false;
      notifyListeners();
      _selProductId = null;
    }).catchError((error) {
      _isLoading = false;
      notifyListeners();
      return;
    });
  }

  void toggleProductFavoriteStatus() {
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

  }

  void selectProduct(String productId) {
    _selProductId = productId;
    notifyListeners();
  }

  // What lesson proposes
  //  void selectProduct(String productId) {
  //   _selProductId = productId;
  //   if (productId != null) {
  //     notifyListeners();
  //   }
  // }

  void toggleDisplayMode() {
    _showFavorites = !_showFavorites;
    notifyListeners();
  }
}


class UserModel extends ConnectedProductsModel {
  void login(String email, String password) {
    _authenticatedUser = User(id: 'fdalsdfasf', email: email, password: password);
  }

  Future<Map<String, dynamic>> signup(String email, String password) async {
    _isLoading = true;
    notifyListeners();
    final Map<String, dynamic> authData = {
      'email': email,
      'password': password,
      'returnSecureToken': true
    };
    final http.Response response = await http.post(
      'https://www.googleapis.com/identitytoolkit/v3/relyingparty/signupNewUser?key=AIzaSyC6uawrA3OJMCH7lyFbzpkyg7k5OS1mWqQ',
      body: json.encode(authData),
      headers: {'Content-Type': 'application/json'},
    );
    final Map<String, dynamic> responseData = json.decode(response.body);
    bool hasError = true;
    String message = 'Something went wrong.';
    if (responseData.containsKey('idToken')) {
      hasError = false;
      message = 'Authentication succeeded!';
    } else if (responseData['error']['message'] == 'EMAIL_EXISTS') {
      message = 'This email already exists.';
    }
    _isLoading = false;
    notifyListeners();
    return {'success': !hasError, 'message': message};
  }
}

class UtilityModel extends ConnectedProductsModel {
  bool get isLoading {
    return _isLoading;
  }
}