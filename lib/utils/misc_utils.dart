import 'dart:math';

class MiscUtils {
  static String getRandomId(int size) {
    var r = Random();
    const _chars =
        'AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz1234567890';

    return List.generate(size, (index) => _chars[r.nextInt(_chars.length)])
        .join();
  }
}
