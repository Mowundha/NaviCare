class JsObject {
  dynamic operator [](Object? key) => null;

  void operator []=(Object? key, dynamic value) {}
}

class JsContext {
  dynamic operator [](Object? key) => null;

  void operator []=(Object? key, dynamic value) {}

  dynamic callMethod(String name, List<dynamic> args) => null;
}

final JsContext context = JsContext();
