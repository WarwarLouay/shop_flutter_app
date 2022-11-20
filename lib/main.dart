// ignore_for_file: prefer_const_constructors, use_key_in_widget_constructors, unused_label, deprecated_member_use, null_check_always_fails

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import './screens/products_overview_screen.dart';
import './screens/cart_screen.dart';
import './screens/product_detail_screen.dart';
import './screens/orders_screen.dart';
import './screens/user_products_screen.dart';
import './screens/edit_product_screen.dart';
import './screens/auth_screen.dart';
import './screens/splash_screen.dart';

import './providers/products_provider.dart';
import './providers/cart.dart';
import './providers/orders.dart';
import './providers/auth.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => Auth(),
        ),
        ChangeNotifierProxyProvider<Auth, ProductsProvider>(
          create: (_) => ProductsProvider('', '', []),
          update: (context, auth, previousProductsProvider) => ProductsProvider(
            auth.token ?? '',
            auth.userId ?? '',
            previousProductsProvider!.items
          ),
        ),
        ChangeNotifierProvider(
          create: (context) => Cart(),
        ),
        ChangeNotifierProxyProvider<Auth, Orders>(
          create: (_) => Orders('', '', []),
          update: (context, auth, previousOrders) => Orders(
            auth.token ?? '',
            auth.userId ?? '',
            previousOrders!.orders
          ),
        ),
      ],
      child: Consumer<Auth>(
        builder: (context, auth, child) => MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Shop App',
          theme: ThemeData(
              primarySwatch: Colors.purple, accentColor: Colors.deepOrange),
          home: auth.isAuth ?
          ProductsOverviewScreen()
          :
          FutureBuilder(
            future: auth.tryAutoLogin(),
            builder: (context, snapshot) =>
            snapshot.connectionState == ConnectionState.waiting ?
            SplashScreen()
            :
            AuthScreen(),
          ),
          routes: {
            ProductDetailScreen.routeName: (context) => ProductDetailScreen(),
            CartScreen.routeName: (context) => CartScreen(),
            OrdersScreen.routeName: (context) => OrdersScreen(),
            UserProductsScreen.routeName: (context) => UserProductsScreen(),
            EditProductSreen.routeName: (context) => EditProductSreen()
          },
        ),
      ),
    );
  }
}
