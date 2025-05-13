import 'package:mysql_client/mysql_client.dart';

class DataBase {
  MySQLConnection? connection;

  initConnection() async {
    final connection = await MySQLConnection.createConnection(
      host: "localhost", // Add your host IP address or server name
      port: 3306, // Add the port the server is running on
      userName: "root", // Your username
      password: "admin", // Your password
      databaseName: "api_test", // Your DataBase name
      secure: false,
    );
    this.connection = connection;
    await connection.connect();
  }

  getUser(String username, String password) async {
    var result = await connection?.execute(
      "SELECT * FROM users WHERE username = :username AND pwd = :pwd",
      {"username": username, "pwd": password},
    );

    if (result != null) {
      int rowCount = result.rows.length;
      if (rowCount > 0) {
        dynamic row = result.rows.first.assoc();
        return row;
      }
    }
    return null;
  }
}
