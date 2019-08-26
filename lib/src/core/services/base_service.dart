import 'package:flutter_web/foundation.dart';

class BaseService {
  List<VoidCallback> callbacks = List();
  void subscribe(VoidCallback callback) {
    callbacks.add(callback);
  }

  void unsubscribe(VoidCallback callback) {
    callbacks.remove(callback);
  }

  void triggerCallbacks() {
    for (VoidCallback callback in callbacks) {
      callback();
    }
  }
}
