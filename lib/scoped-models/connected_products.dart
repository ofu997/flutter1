import 'package:scoped_model/scoped_model.dart';
import '../models/product.dart';
import '../models/user.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

mixin ConnectedProductsModel on Model{
  int count = 0;
  List<Product> _products = [];
  int _selProductIndex;

  User _authenticatedUser;
  // I added _selProductId;
  String _selProductId;

  void addsProducts(String title, String description, String image, double price) {
        final Map<String,dynamic> productData = {
          'title': title,
          'description': description,
          'image': 'https://www.google.com/url?sa=i&rct=j&q=&esrc=s&source=images&cd=&cad=rja&uact=8&ved=2ahUKEwiWquab48PgAhWSHDQIHXUVD58QjRx6BAgBEAU&url=https%3A%2F%2Fbarefeetinthekitchen.com%2Fhow-to-make-a-cheese-board%2F&psig=AOvVaw1ig44_mDut58gEs7RKuZ12&ust=1550527502726219',
          'price': price,
        };
      http.post('https://flutterbyof.firebaseio.com/products.json', 
      body: json.encode(productData));

      count++;
      final Product newProduct = Product(
        title: title,
        description: description,
        image: image,
        price: price,
        userEmail: _authenticatedUser.email,
        userId: _authenticatedUser.id        
      );
      _products.add(newProduct);
      notifyListeners();
      print(' addProduct() text count: ' + count.toString() + ' ' + DateTime.now().toIso8601String());
  }
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
    return _selProductIndex;
  }

  Product get selectedProduct {
    if (selectedProductIndex == null || _products.isEmpty) {
      return null;
    }
    return _products[selectedProductIndex];
    
  }

  bool get displayFavoritesOnly {
    return _showFavorites;
  }

  void updateProduct(
      String title, String description, String image, double price) {
    final Product updatedProduct = Product(
        title: title,
        description: description,
        image: image,
        price: price,
        userEmail: selectedProduct.userEmail,
        userId: selectedProduct.userId);
    _products[selectedProductIndex] = updatedProduct;
    notifyListeners();
  }

  void deleteProduct(int index) {
    _products.removeAt(index);
    print(index);
    _selProductIndex = null;
    notifyListeners();
  }

  void toggleProductFavoriteStatus() {
    final bool isCurrentlyFavorite = selectedProduct.isFavorite;
    final bool newFavoriteStatus = !isCurrentlyFavorite;
    final Product updatedProduct = Product(
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

  void selectProduct(int index) {
    _selProductIndex = index;
    
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

mixin UserModel on ConnectedProductsModel {
    void login(String email, String password) {
    _authenticatedUser = User(id: 'fdalsdfasf', email: email, password: password);
  }
}

