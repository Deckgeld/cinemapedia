import 'package:cinemapedia/presentation/views/home_views/favorites_view.dart';
import 'package:cinemapedia/presentation/views/home_views/home_view.dart';
import 'package:flutter/material.dart';
import 'package:cinemapedia/presentation/widgets/widgets.dart';

class HomeScreen extends StatelessWidget {
  static const String name = 'home-screen';
  final int pageIndex;

  const HomeScreen({
    super.key,
    required this.pageIndex,
  });

  final viewRoutes = const <Widget>[
    HomeView(),
    SizedBox(),
    FavoritesView()
    
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //indexedStack nos permite tener un stack de widgets y mostrar solo uno a la vez, sin perder el estado de los demas
        body: IndexedStack(
          index: pageIndex,
          children: viewRoutes,
        
        ), 
        bottomNavigationBar: CustomBottomNavigation( currentIndex: pageIndex)
    );
  }
}
