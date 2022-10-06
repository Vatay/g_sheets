import 'package:balance/model/top_card_info.dart';
import 'package:gsheets/gsheets.dart';

class GoogleSheetsApi {
  static const _credentials = r'''
  {
    "type": "service_account",
    "project_id": "flutter-gsheeld",
    "private_key_id": "6969247e6108337b55254303d8119f5e29c2ac17",
    "private_key": "-----BEGIN PRIVATE KEY-----\nMIIEvQIBADANBgkqhkiG9w0BAQEFAASCBKcwggSjAgEAAoIBAQCzlaYAZ121/YuZ\nlpYwh+VmS+kdYtCkyWazLYXojP1Z6I0irsZ2+JmcFtqrbbAuiUw9IgYL7cUgIwYo\nOCs0W9DRjtzmQHlo4z2yoLw4HFav/P3EDYg6lZB5pGJxPPXvzrotqHVf30itDqLq\n0esVUlBVsBInNYry0tHxLEjDHkwnmLQdhq0AAvq3SGFQT/dSZ7cijGwOR6Yw8F6q\nsg/I/W+oqNB04Dv17zRwRGxFhCnJ4fAfUQDS1l4LEcfXjrduCJEnD6I+xt4bCXUC\nBPyckEB+t8H/MuPhbiECYoAYTaPZDfm1Xn/cFPn9HyLMd8nLoJeowrqekA5iX5Nk\ny4X3ELY7AgMBAAECggEATFCJzJ4gepgWXNxbUqBNYd1cYPp/A6f6lqX/w8U2XKCw\naU6wVBps3KHxpuvj9MKvvULaIvOV04ROt4S3B3cFFCiLwuUfMu1uaJxZn9abGAqA\npHHDtHGehbLPiqOHN7M39vMhfe5a6f/QR82RAuyJ6v/5luPv+iSQxtY0zYXwgtpv\nZHUW2kB0A8TjzbDz2UsjS7Gy9X7WUr7wo+p8dm0mlAVzd45RuZnTI1VxooCf6TQm\ng5/WosIP4UoovicB86cFpUcosdaGqfGUckNj09SYYl70Z8YsgqhE07Kos8NHzWmd\nyqRMWPUt3ok1oGw08bu/DEaWfvmbBJas2IJqZtuUkQKBgQD4nL1Eg2QilNd8YHfe\nTjf8mMn08IwrPgSvJuYJIJOb6ohAq2g74f8KNRWPo30ycI6jvdthiWjnqYC1OOf6\nK8+8g9E1c86wKEVyxc8rU6qZlEvb2inBU4P0uirOBlchUY+buiqy8HURfuIFe23j\ncHxNNRVvY/nFN2d3jUOXYm9VfQKBgQC468v4S0ies0NvICae8Wg3yDOdMn1vbQRT\necRpVftwa6MTaJq3Xn1+9Ayaadxwk2/xi+MPm9seSjydi9i5mBqhv1iMlp5QGhGf\njNz79i7Dlg/9PzWfQ9/YhiPpFxefstlSMdIr2EnvoPmWfX5CXpd17ifkGPYfamEN\nDNVlBK6oFwKBgCmgLLx092Ym37GOgWNyW0Nq3Z2qTP3Mg4JEFA4BK1XWvft995TX\nMRmna7XCHOs+F1PpLPs2w57OLaOqJIUpor2goH2/pyKti3s9DYPmnVDbmJv1+jnJ\nXvWx2grm2t3URyQ+1nlhc2h7gyKB2RNUuStAMReWeLKBpUxKFcAaFiQNAoGBAKJ3\ncHYOVpgv8WAxxBzDBgh0WXyT/oamJjXc9saBJ28G8ni736qZVvLyIhyMQ4OY1bJH\nb8+n5CTBnm3gjyHIVCWlwnuKXT8NGEywavrnuQBX2GZsYYUzEfjfKa/BfRzu+mZv\npTKmTZc+O+qPCR3wk2umON/7WkoRoYDgtJ+TNIwzAoGAfQBykxbud3/lAzB/tPOs\nk+N/z/Ov+niNLHRd6JnEKP/JufcMyot729hMSDFQYa890IyYGpgww8pmci5MJ5VT\nVJTmZNkvs5LzXQzd+2HdkNB98vLENi1UBK4lSVsTYIUjzhyGBmIlHbDoGq8biAsi\nzBwWy16R5TQurEF2HfN4zLg=\n-----END PRIVATE KEY-----\n",
    "client_email": "flutter-gsheets@flutter-gsheeld.iam.gserviceaccount.com",
    "client_id": "108099485481323490908",
    "auth_uri": "https://accounts.google.com/o/oauth2/auth",
    "token_uri": "https://oauth2.googleapis.com/token",
    "auth_provider_x509_cert_url": "https://www.googleapis.com/oauth2/v1/certs",
    "client_x509_cert_url": "https://www.googleapis.com/robot/v1/metadata/x509/flutter-gsheets%40flutter-gsheeld.iam.gserviceaccount.com"
  }
  ''';

  static final _spreadsheeltID = '1oZotPb9apuV9Hz_Y0eEx_UmMwuSGuqJ6g7HOH1QxUYg';
  static final _gsheets = GSheets(_credentials);
  // ignore: unused_field
  static Worksheet? _worksheet;

  static int numberOfTransaction = 0;
  static List<List<dynamic>> currentTransaction = [];
  static bool loading = true;

  Future init() async {
    // final gsheets = GSheets(credentials);
    final ss = await _gsheets.spreadsheet(_spreadsheeltID);
    _worksheet = ss.worksheetByTitle('Balance');
    countRows();
  }

  static Future countRows() async {
    while ((await _worksheet!.values
            .value(column: 1, row: numberOfTransaction + 1)) !=
        '') {
      numberOfTransaction++;
    }
    loadTransactions();
  }

  static Future loadTransactions() async {
    if (_worksheet == null) return;

    for (int i = 2; i < numberOfTransaction + 1; i++) {
      final String name = await _worksheet!.values.value(column: 1, row: i);
      final String amount = await _worksheet!.values.value(column: 2, row: i);
      final String type = await _worksheet!.values.value(column: 3, row: i);

      if (currentTransaction.length < numberOfTransaction) {
        currentTransaction.add([
          name,
          amount,
          type,
        ]);
      }
    }

    // покаже кінець завантаження
    loading = false;
  }

  // Додати транзакцію
  static Future insert({
    required String name,
    required String amount,
    required bool type,
  }) async {
    if (_worksheet == null) return;

    numberOfTransaction++;
    currentTransaction.add([
      name,
      amount,
      type ? 'income' : 'expense',
    ]);
    await _worksheet!.values.appendRow([
      name,
      amount,
      type ? 'income' : 'expense',
    ]);
  }

  static TopCardInfo calulateMoney() {
    double income = 0;
    double expense = 0;
    double moneyNow = 0;

    for (int i = 0; i < currentTransaction.length; i++) {
      if (currentTransaction[i][2] == 'income') {
        income += double.parse(currentTransaction[i][1]);
      } else {
        expense += double.parse(currentTransaction[i][1]);
      }
    }
    moneyNow = income - expense;
    return TopCardInfo(income: income, expense: expense, moneyNow: moneyNow);
  }
}
