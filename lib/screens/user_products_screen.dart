// ignore_for_file: use_key_in_widget_constructors, prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../screens/edit_product_screen.dart';
import '../widgets/app_drawer_widget.dart';
import '../widgets/user_product_item_widget.dart';
import '../providers/products_provider.dart';

class UserProductsScreen extends StatelessWidget {
  static const routeName = '/user-products';

  Future<void> _refreshProducts(BuildContext context) async {
    await Provider.of<ProductsProvider>(context, listen: false).fetchAndSetProducts(true);
  }

  @override
  Widget build(BuildContext context) {
    // final productsData = Provider.of<ProductsProvider>(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Your Products'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              Navigator.of(context).pushNamed(EditProductSreen.routeName, arguments: '');
            },
          ),
        ],
      ),
      drawer: AppDrawerWidget(),
      body: FutureBuilder(
        future: _refreshProducts(context),
        builder: (context, snapshot) =>
          snapshot.connectionState == ConnectionState.waiting
          ?
          Center(
            child: CircularProgressIndicator(),
          )
          :
          RefreshIndicator(
          onRefresh: () => _refreshProducts(context),
          child: Consumer<ProductsProvider>(
            builder: (context, productsData, child) => Padding(
              padding: EdgeInsets.all(8),
              child: ListView.builder(
                itemCount: productsData.items.length,
                itemBuilder: (context, index) => Column(
                  children: [
                    UserProductItemWidget(
                      productsData.items[index].id,
                      productsData.items[index].title,
                      productsData.items[index].imageUrl
                    ),
                    Divider(),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
