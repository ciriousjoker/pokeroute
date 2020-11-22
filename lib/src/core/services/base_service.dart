import 'package:flutter/foundation.dart';

class BaseService {
  List<VoidCallback> callbacks = [];
  void subscribe(VoidCallback callback) {
    callbacks.add(callback);
  }

  void unsubscribe(VoidCallback callback) {
    callbacks.remove(callback);
  }

  void triggerCallbacks() {
    for (var callback in callbacks) {
      callback();
    }
  }
}
