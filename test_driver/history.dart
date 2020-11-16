import 'package:shared_preferences/shared_preferences.dart';

Future<List<String>> getHistory() async {
  return await SharedPreferences.getInstance().then(
    (pref) => pref.getStringList('history') ?? [],
  );
}
