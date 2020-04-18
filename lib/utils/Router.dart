import 'package:flutter/material.dart';
import 'package:nimble_player/screens/DetailedPlayer.dart';
import 'package:nimble_player/screens/MainList.dart';
import 'package:nimble_player/screens/SearchList.dart';

class Router {
  static Route<dynamic> generateRoutes(RouteSettings settings) {
    switch (settings.name) {
      case '/':
        return MaterialPageRoute(builder: (_) => MainList());
      case 'search':
        return slideFromRight(SearchList());
      case 'show':
        return slideFromBottom(DetailedPlayer());
      default:
        return MaterialPageRoute(builder: (_) {
          return Scaffold(
            body: Center(
              child: Text('No route defined for ${settings.name}'),
            ),
          );
        });
    }
  }

  static PageRouteBuilder slideFromRight(Widget widget) {
    return PageRouteBuilder(pageBuilder: (BuildContext context,
        Animation<double> animation, Animation<double> secondaryAnimation) {
      return widget;
    }, transitionsBuilder: (BuildContext context, Animation<double> animation,
        Animation<double> secondaryAnimation, Widget child) {
      var tween = Tween<Offset>(begin: Offset(1.0, 0.0), end: Offset.zero)
          .chain(CurveTween(curve: Curves.easeIn));
      return SlideTransition(
        child: child,
        position: animation.drive(tween),
      );
    });
  }

  static PageRouteBuilder slideFromBottom(Widget widget) {
    return PageRouteBuilder(pageBuilder: (BuildContext context,
        Animation<double> animation, Animation<double> secondaryAnimation) {
      return widget;
    }, transitionsBuilder: (BuildContext context, Animation<double> animation,
        Animation<double> secondaryAnimation, Widget child) {
      var tween = Tween<Offset>(begin: Offset(0.0, 1.0), end: Offset.zero)
          .chain(CurveTween(curve: Curves.easeOut));
      return SlideTransition(
        child: child,
        position: animation.drive(tween),
      );
    });
  }
}
