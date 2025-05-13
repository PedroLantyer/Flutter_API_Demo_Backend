import 'dart:convert';

import 'package:shelf/shelf.dart';
import 'package:shelf_router/shelf_router.dart';

class ServerHandl {
  Handler get handler {
    final router = Router();

    //GET ROUTES
    router.get('/hello_world', (Request req) => Response.ok("Hello World"));
    router.get(
      '/hello_user/<user>',
      (Request req, String user) => Response.ok("Hello $user"),
    );
    router.get('/get_query', (Request req) {
      String? name = req.url.queryParameters['name'];
      String? age = req.url.queryParameters["age"];
      return Response.ok("Query is: ${name ?? "N/A"}, Age: $age");
    });
    //GET ROUTES

    //CONTENT TYPE DEMO
    router.get(
      "/",
      (Request req) =>
          Response.ok("<h1>Root</h1>", headers: {"content-type": "text/html"}),
    );
    //CONTENT TYPE DEMO

    //POST ROUTES
    router.post('/login', (Request req) async {
      try {
        Map json = jsonDecode(await req.readAsString());
        String? user = json["user"];
        String? password = json["password"];

        if (user == null || password == null) {
          throw Exception("Credentials missing");
        }

        if (user == "admin" && password == "123456") {
          String res = jsonEncode({"id": 1, "user": "admin"});
          return Response.ok(
            res,
            headers: {"content-type": "application/json"},
          );
        }
        return Response.forbidden('Acess Denied');
      } catch (error) {
        print(error);
        return Response.badRequest(body: "Login failed");
      }
    });
    //POST ROUTES

    return router;
  }
}
