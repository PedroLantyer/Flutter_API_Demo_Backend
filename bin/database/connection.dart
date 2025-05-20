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
    IResultSet? result = await connection?.execute(
      "SELECT * FROM users WHERE (username = :username OR email = :username) AND pwd = :pwd",
      {"username": username, "pwd": password},
    );

    if (result != null) {
      int rowCount = result.rows.length;
      if (rowCount == 1) {
        Map<String, dynamic> row = result.rows.first.assoc();
        return row;
      }
    }
  }

  createUser(String username, String password, String email) async {
    try {
      IResultSet? find = await connection?.execute(
        "SELECT * FROM users WHERE (username = :username OR email = :email)",
        {"username": username, "email": email, "pwd": password},
      );

      if (find != null && find.rows.length > 0) {
        /* print("FIND is Null ${find == null}");
        print("FIND is empty ${find.isNotEmpty}");
        print("GOT HERE"); */
        Map<String, dynamic> duplicate = find.rows.first.assoc();
        return {
          "result": "DUPLICATE",
          "dupe": duplicate["username"] == username ? "Username" : "Email",
        };
      }

      var result = await connection?.execute(
        "INSERT INTO users (username, email, pwd) VALUES (:username, :email, :pwd)",
        {"username": username, "email": email, "pwd": password},
      );

      return {"result": result != null ? "CREATED" : null};
    } catch (e) {
      print(e);
      return {"result": null};
    }
  }
}
