import 'package:shelf/shelf.dart';

class Cors {
  static Middleware get middleware {
    final corsHeaders = {
      'Access-Control-Allow-Origin': '*',
      "Access-Control-Allow-Methods": "*",
      "Access-Control-Allow-Headers": "*",
    };

    Response? handleOptions(Request req) {
      return req.method == "OPTIONS"
          ? Response(200, headers: corsHeaders)
          : null;
    }

    Response addCorsHeaders(Response res) => res.change(headers: corsHeaders);

    return createMiddleware(
      requestHandler: handleOptions,
      responseHandler: addCorsHeaders,
    );
  }
}
