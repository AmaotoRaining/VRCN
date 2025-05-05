import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// FirebaseAnalyticsのインスタンス
final analyticsRepository = Provider((ref) => FirebaseAnalytics.instance);

/// FirebaseAnalyticsObserverのインスタンス
final analyticsObserverRepository = Provider(
  (ref) => FirebaseAnalyticsObserver(analytics: ref.watch(analyticsRepository)),
);

/// setCurrentScreenメソッドの追加
void setCurrentScreen({required String screenName}) {
  if (kDebugMode) {
    print('Screen view: $screenName');
    return;
  }
  FirebaseAnalytics.instance.logScreenView(screenName: screenName);
}
