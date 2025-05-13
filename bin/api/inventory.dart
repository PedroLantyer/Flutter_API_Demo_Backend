import 'dart:convert';

import 'package:shelf/shelf.dart';
import 'package:shelf_router/shelf_router.dart';

class Item {
  int? id;
  String? name;
  int? unitCount;
  Item(this.id, this.name, this.unitCount);

  Item.fromJson(Map<String, dynamic> json)
    : id = json["id"] as int,
      name = json["name"] as String,
      unitCount = int.tryParse(json["unitCount"]) ?? 0;

  Map<String, dynamic> toJson() {
    return {"id": id, "name": name, "unitCount": unitCount};
  }
}

class Inventory {
  Handler get handler {
    Router router = Router();

    router.get('/inventory', (Request req) {
      //TEMP
      List<Item> data = [
        Item(0, "ITEM A", 1),
        Item(1, "ITEM B", 3),
        Item(2, "ITEM C", 0),
      ];
      //TEMP

      String json = jsonEncode(data);
      Response res = Response.ok(
        json,
        headers: {"content-type": 'application/json'},
      );

      return res;
    });
    return router;
  }
}
