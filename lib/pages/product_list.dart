import 'package:flutter/material.dart';
import './product_edit.dart';
import 'package:scoped_model/scoped_model.dart';
import '../scoped-models/main.dart';



class ProductListPage extends StatefulWidget {
  final MainModel model;

  ProductListPage(this.model);

  @override
    State<StatefulWidget> createState() {
      return _ProductListPageState();
    }
}

class _ProductListPageState extends State<ProductListPage>{
  @override
  initState() {
    widget.model.fetchProducts(onlyForUser: true);
    super.initState();
  }

  Widget _buildEditButton(BuildContext context, int index, MainModel model) {
    return IconButton(
      icon: Icon(Icons.edit),
      onPressed: () {
        model.selectProduct(model.allProducts[index].id);
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (BuildContext context) {
              return ProductEditPage(); //we don't pass addProduct here
            },
          ),
        )
        .then(
          (_){
          model.selectProduct(null);
          }
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<MainModel>(
      builder: (BuildContext context, Widget child, MainModel model) {
        Widget content = ListView.builder(
        itemBuilder: (BuildContext context, int index) {
          return Dismissible(
            background: Container(color: Colors.pink),
            key: Key(model.allProducts[index].title),
            onDismissed: (DismissDirection direction) {
              if (direction == DismissDirection.endToStart) {
                print('end to start...');

                void deleteSelected(){
                  model.selectProduct(model.allProducts[index].id);
                  print('before deleting, number of products is $model.allProducts.length.toString()');
                  model.deleteProduct();
                  print('after deleting, number of products is $model.allProducts.length.toString()');
                }

                return showDialog<Null>(
                  context: context,
                  builder: (BuildContext context){
                    return AlertDialog(
                      title: Text('Deleting by swipe'),
                      content: Text('Do you want to delete this item permanently?'),
                      actions: <Widget>[
                        FlatButton(color: Colors.greenAccent, textColor: Colors.white, child: Text('No', style: TextStyle(fontWeight: FontWeight.bold)), onPressed: ()
                          {
                            Navigator.of(context).pop();
                          }
                        ),
                        FlatButton(color: Colors.redAccent, textColor: Colors.white, child: Text('Yes. Delete', style: TextStyle(fontWeight: FontWeight.w400)), onPressed: ()
                          {
                            deleteSelected();
                            Navigator.of(context).pop();
                          },
                        ),
                      ],
                    );
                  }
                );

              } 
              else if (direction == DismissDirection.startToEnd) {
                print('start to end');
                // return AlertDialog(
                //   title: Text('Delete item?'),
                //   content: Text('this will permanently delete the item'),
                //   actions: <Widget>[
                //     FlatButton(
                //       child: Text('cancel'), onPressed: (){Navigator.of(context).pop();}
                //     ),
                //     FlatButton(
                //       child: Text('delete'), onPressed: (){model.selectProduct(model.allProducts[index].id); model.deleteProduct();}
                //     )
                //   ],
                // );
              } else {
                print('other swipe');
              }
            },
            child: Column(
              children: <Widget>[
                ListTile(
                  //leading: Container(child: Image.asset(products[index]['image']),width: 75.0),
                  leading: CircleAvatar(
                    backgroundImage: 
                      NetworkImage(model.allProducts[index].image),
                  ),
                  title: Text(model.allProducts[index].title),
                  subtitle:
                      Text('\$${model.allProducts[index].price.toString()}'),
                  trailing: _buildEditButton(context, index, model),
                ),
                Divider(),
              ],
            ),
          );
        },
        itemCount: model.allProducts.length,
      );
      if (model.allProducts.isEmpty){content = Center(child:Text('is empty'));}
      return content;
    });
  }
}
