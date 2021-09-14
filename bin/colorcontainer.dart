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
    await HttpServer.bind(InternetAddress.anyIPv4, 8080, shared: true)
      ..idleTimeout = Duration.zero,
    // await HttpServer.bind(InternetAddress.anyIPv6, 8080, shared: true)
    //   ..idleTimeout = null,
  ])) {
    request.response
      ..headers.contentType = ContentType.html
      ..headers.set("Cache-Control", "no-cache, no-store, must-revalidate")
      ..headers.set("Pragma", "no-cache")
      ..headers.set("Expires", "0")
      ..writeln("""
<!DOCTYPE html>
<html>
<head>
<title>ColorContainer</title>
</head>
<body style="background: $color"></body></html>""")
      ..close();
  }
}
