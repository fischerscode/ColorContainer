import 'dart:io';
import 'dart:math';
import 'package:async/async.dart' show StreamGroup;

void main(List<String> arguments) async {
  Random random = Random();

  String chars = '0123456789ABCDEF';
  String color = "#" +
      List.generate(6, (index) => chars[random.nextInt(16)])
          .reduce((s1, s2) => s1 + s2);

  print("Start server with color: $color");

  await for (HttpRequest request in StreamGroup.merge([
    await HttpServer.bind(InternetAddress.anyIPv4, 8080, shared: true),
    await HttpServer.bind(InternetAddress.anyIPv4, 8080, shared: true),
  ])) {
    request.response
      ..headers.contentType = ContentType.html
      ..writeln("""
<!DOCTYPE html><html><head><title>ColorContainer</title></head><body style="background: $color"></body></html>""")
      ..close();
  }
}
