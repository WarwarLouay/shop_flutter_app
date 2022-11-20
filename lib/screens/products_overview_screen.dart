// ignore_for_file: use_key_in_widget_constructors, prefer_const_constructors, sort_child_properties_last, avoid_print

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../screens/cart_screen.dart';

import '../widgets/product_grid.dart';
import '../widgets/badge.dart';
import '../widgets/app_drawer_widget.dart';

import '../providers/cart.dart';
import '../providers/products_provider.dart';

// ignore: constant_identifier_names
enum FilterOptions { Favorites, All }

class ProductsOverviewScreen extends StatefulWidget {

  @override
  State<ProductsOverviewScreen> createState() => _ProductsOverviewScreenState();
}

class _ProductsOverviewScreenState extends State<ProductsOverviewScreen> {
  var _showOnlyFavorites = false;
  var _isInit = true;
  var _isLoading = false;

  @override
  void initState() {
    // Future.delayed(Duration.zero).then((_) {
    //   Provider.of<ProductsProvider>(context).fetchAndSetProducts();
    // });
    super.initState();
  }

  @override
  void didChangeDependencies() {
    if (_isInit) {
      setState(() {
        _isLoading = true;
      });
      Provider.of<ProductsProvider>(context).fetchAndSetProducts().then((_) {
        setState(() {
        _isLoading = false;
      });
      });
    }
    _isInit = false;
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    var scaffold = Scaffold(
        appBar: AppBar(
          title: Text('Shop App'),
          actions: [
            PopupMenuButton(
              onSelected: (FilterOptions selectedvalue) {
                setState(() {
                  if (selectedvalue == FilterOptions.Favorites) {
                    _showOnlyFavorites = true;
                  } else {
                    _showOnlyFavorites = false;
                  }
                });
              },
              icon: Icon(Icons.more_vert),
              itemBuilder: (_) => [
                PopupMenuItem(
                  child: Text('Only Favorites'),
                  value: FilterOptions.Favorites,
                ),
                PopupMenuItem(
                  child: Text('Show All'),
                  value: FilterOptions.All,
                ),
              ],
            ),
            Consumer<Cart>(
              builder: (_, cart, child) => Badge(
                child: IconButton(
                  icon: Icon(Icons.shopping_cart),
                  onPressed: () {
                    Navigator.of(context).pushNamed(CartScreen.routeName);
                  },
                ),
                value: cart.itemCount.toString(),
                color: Colors.red,
              ),
            ),
          ],
        ),
        drawer: AppDrawerWidget(),
        body: _isLoading ?
        Center(
          child: CircularProgressIndicator(),
        )
        :
        ProductGrid(_showOnlyFavorites));
    return scaffold;
  }
}
