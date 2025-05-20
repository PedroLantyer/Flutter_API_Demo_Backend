import 'dart:convert';
import '../database/connection.dart';
import 'package:shelf/shelf.dart';
import 'package:shelf_router/shelf_router.dart';

class Register {
  DataBase? db;
  Register(this.db);
  Handler get handler {
    Router router = Router();
    try {
      router.post("/register", (Request req) async {
        if (db == null) {
          throw Exception("Failed to initialize Database");
        }

        String res = await req.readAsString();
        Map json = jsonDecode(res);

        String? user = json["user"],
            password = json["password"],
            email = json["email"];

        if (user == null || password == null || email == null) {
          return Response(400, body: "Credentials Missing");
        }

        Map<String, dynamic> reqRes = await db?.createUser(
          user,
          password,
          email,
        );
        switch (reqRes["result"]) {
          case "CREATED":
            return Response(201, headers: {"Content-Type": "text/plain"});
          case "DUPLICATE":
            return Response(
              409,
              body: "${reqRes["dupe"]} already in use",
              headers: {"Content-Type": "text/plain"},
            );
          default:
            print(reqRes);
            return Response.badRequest(
              body: "Failed to create user",
              headers: {"Content-Type": "text/plain"},
            );
        }
      });
      return router;
    } catch (e) {
      print(e);
      return router;
    }
  }
}
