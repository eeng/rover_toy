import 'package:shared_preferences/shared_preferences.dart';
import 'dart:async';

enum ConstrainType { circle, box }

class Settings {
  static Settings _instance;

  static Settings getInstance() {
    return _instance ??= Settings._();
  }

  ConstrainType constrainType = ConstrainType.circle;
  int originSensibility = 5;
  int dangerZone = 20;

  Settings._() {
    SharedPreferences.getInstance().then((prefs) {
      constrainType = ConstrainType.values.firstWhere(
          (v) => v.toString() == prefs.getString('constrainType'),
          orElse: () => constrainType);
      originSensibility =
          prefs.getInt('originSensibility') ?? originSensibility;
      dangerZone = prefs.getInt('dangerZone') ?? dangerZone;
    });
  }

  Future save() {
    return SharedPreferences.getInstance().then((prefs) {
      prefs.setString('constrainType', constrainType.toString());
      prefs.setInt('originSensibility', originSensibility);
      prefs.setInt('dangerZone', dangerZone);
    });
  }
}
