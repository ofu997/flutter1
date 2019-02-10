import 'package:scoped_model/scoped_model.dart';
import '../models/product.dart';

class ProductsModel extends Model{
  int count = 0;
  List<Product> _products = [];
  List<Product> get products{
    return List.from(_products);
  }

  void addsProducts(Product product) {
    
      count++;
      _products.add(product);
      print(' addProduct() text count: ' +
          count.toString() +
          ' ' +
          DateTime.now().toIso8601String());
    
  }

  void deleteProduct(int index) {
    
      _products.removeAt(index);
    
  }

  void updateProduct(int index, Product product) {
    
      _products[index] = product;
    
  }

}