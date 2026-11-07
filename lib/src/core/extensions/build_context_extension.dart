import 'package:flutter/material.dart';

extension BuildContextExtension on BuildContext {

  Future<T?> push<T extends Object?>(Widget page) {
    return Navigator.of(this).push<T>(MaterialPageRoute(builder: (_) => page));
  }

  /// Push and remove all previous routes
  Future<T?> pushAndRemoveUntil<T extends Object?>(
      Widget page,
      bool Function(Route<dynamic>) predicate,
      ) {
    return Navigator.of(
      this,
    ).pushAndRemoveUntil<T>(MaterialPageRoute(builder: (_) => page), predicate);
  }

  void pop<T extends Object?>([T? result]) {
    return Navigator.of(this).pop<T>(result);
  }

  double get screenHeight => MediaQuery.of(this).size.height;
  double get screenWidth => MediaQuery.of(this).size.width;
}
