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
        if (db == null) {
          throw Exception("Failed to initialize Database");
        }

        String res = await req.readAsString();
        Map json = jsonDecode(res);

        String? user = json["user"], password = json["password"];
        if (user == null || password == null) {
          return Response.badRequest(body: "Credentials Missing");
        }

        var row = await db?.getUser(user, password);
        if (row == null || row.isEmpty == false) {
          return Response.forbidden(
            jsonEncode({"user": null, "isLogged": false}),
            headers: {"Content-Type": "application/json"},
          );
        }
        return Response.ok(
          jsonEncode({"user": row["username"], "isLogged": true}),
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
