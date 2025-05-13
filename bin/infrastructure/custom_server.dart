import 'package:shelf/shelf_io.dart' as shelf_io;
import 'package:shelf/shelf.dart';

class CustomServer {
  Future<void> initalize(Handler handler) async {
    final int port = 8080;
    final String address = "localhost";

    await shelf_io.serve(handler, address, port);
    print('Server started @ http://$address:$port');
  }
}
