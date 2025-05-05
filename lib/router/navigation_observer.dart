import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// ナビゲーションインデックス管理用プロバイダー（まだ定義されていない場合）
final navigationIndexProvider = StateProvider<int>((ref) => 0);

class VRChatNavigationObserver extends NavigatorObserver {
  final StateController<int> navigationController;

  VRChatNavigationObserver(this.navigationController);

  @override
  void didPush(Route<dynamic> route, Route<dynamic>? previousRoute) {
    _updateNavigationIndex(route);
    super.didPush(route, previousRoute);
  }

  @override
  void didReplace({Route<dynamic>? newRoute, Route<dynamic>? oldRoute}) {
    if (newRoute != null) {
      _updateNavigationIndex(newRoute);
    }
    super.didReplace(newRoute: newRoute, oldRoute: oldRoute);
  }

  @override
  void didPop(Route<dynamic> route, Route<dynamic>? previousRoute) {
    if (previousRoute != null) {
      _updateNavigationIndex(previousRoute);
    }
    super.didPop(route, previousRoute);
  }

  void _updateNavigationIndex(Route<dynamic> route) {
    final path = route.settings.name;
    if (path == null) return;

    var index = 0;
    if (path == '/search') {
      index = 1;
    } else if (path == '/notifications') {
      index = 2;
    }

    // ビルド中に状態更新が起きないように遅延実行
    Future.microtask(() {
      navigationController.state = index;
    });
  }
}
