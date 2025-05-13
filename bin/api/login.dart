import 'dart:convert';
import '../database/connection.dart';
import 'package:shelf/shelf.dart';
import 'package:shelf_router/shelf_router.dart';

class Login {
  DataBase? db;
  Login(this.db);
  Handler get handler {
    Router router = Router();
    try {
      router.post("/login", (Request req) async {
        String res = await req.readAsString();
        Map json = jsonDecode(res);

        String? user = json["user"];
        String? password = json["password"];
        if (db == null || user == null || password == null) {
          throw Exception("Credentials Missing");
        }

        dynamic row = await db?.getUser(user, password);
        if (row == null) {
          return Response.forbidden(
            jsonEncode({"user": null, "isLogged": false}),
            headers: {"Content-Type": "application/json"},
          );
        }
        return Response.ok(
          jsonEncode({"user": user, "isLogged": true}),
          headers: {"Content-Type": "application/json"},
        );
      });
      return router;
    } catch (e) {
      print(e);
      return router;
    }
  }
}
