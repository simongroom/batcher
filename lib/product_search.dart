import 'package:batcher/models/product.dart';
import 'package:batcher/product_view.dart';
import 'package:flutter/material.dart';

class ProductSearch extends SearchDelegate {
  final List<Product> productList;

  ProductSearch({
    @required this.productList,
  });

  List<Product> recentList = [];

  @override
  List<Widget> buildActions(BuildContext context) {
    return <Widget>[
      IconButton(
        icon: Icon(Icons.close),
        onPressed: () {
          query = "";
        },
      ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: Icon(Icons.arrow_back),
      onPressed: () {
        close(context, null);
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    List<Product> resultList = [];
    resultList.addAll(filterProductList());
    return buildProductListView(resultList);
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    List<Product> suggestionList = [];
    query.isEmpty
        ? suggestionList = recentList //In the true case
        : suggestionList.addAll(filterProductList());
    return buildProductListView(suggestionList);
  }

  List<Product> filterProductList() {
    return productList.where((p) {
      if (p.clientName.toLowerCase().startsWith(query.toLowerCase()) ||
          p.productName.toLowerCase().startsWith(query.toLowerCase())) {
        return true;
      }
      return false;
    }).toList();
  }

  ListView buildProductListView(List<Product> products) {
    return ListView.builder(
      itemCount: products.length,
      itemBuilder: (context, index) {
        return Card(
          child: InkWell(
            onTap: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => ProductView(
                    product: products[index],
                  ),
                ),
              );
            },
            splashColor: Colors.blue.withAlpha(30),
            child: ListTile(
              title: Text(products[index].productName),
              subtitle: Text(products[index].clientName),
            ),
          ),
        );
      },
    );
  }
}
