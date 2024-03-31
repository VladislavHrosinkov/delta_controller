import 'package:admin/screens/dashboard/cartesian_control_contents/cartesian_control.dart';
import 'package:admin/screens/dashboard/info_contents/info_page.dart';
import 'package:admin/screens/dashboard/load_path_contents/load_path.dart';
import 'package:admin/screens/dashboard/memorize_path_contents/learn_path.dart';
import 'package:admin/screens/dashboard/phase_control_contents/phase_control.dart';
import 'package:flutter/material.dart';

enum Location {
  phase_control,
  cartesian_control,
  memorize_path,
  load_path, 
  info,
}


class LocationProvider extends ChangeNotifier {
  Location _location = Location.phase_control;

  Location get location => _location;
  
  Widget get screen {
    switch (_location){
      case Location.phase_control:
        return PhaseControl();
      case Location.cartesian_control:
        return CartesianControl();
      case Location.memorize_path:
        return LearnPath();
      case Location.info:
        return InfoPage();
      case Location.load_path:
      default:
        return LoadPath();
    }
  }

  void setLocation(Location location) {
    _location = location;
    notifyListeners(); // Notifies listeners about the change
  }
}
