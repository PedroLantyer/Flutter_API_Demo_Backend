import 'package:shelf/shelf.dart';
import 'api/login.dart';
import 'infrastructure/custom_server.dart';
import 'api/inventory.dart';
import 'infrastructure/cors.dart';
import 'database/connection.dart';

void main() async {
  DataBase db = DataBase();
  await db.initConnection();

  Handler cascadeHandler =
      Cascade().add(Login(db).handler).add(Inventory().handler).handler;

  var handler = Pipeline()
      .addMiddleware(logRequests())
      .addMiddleware(Cors.middleware)
      .addHandler(cascadeHandler);

  await CustomServer().initalize(handler);
}
