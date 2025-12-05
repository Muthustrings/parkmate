import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ParkingRateProvider with ChangeNotifier {
  double _bikeRate = 4.0;
  double _bikeDuration = 1.0; // In hours

  double _carRate = 15.0;
  double _carDuration = 1.0; // In hours

  double get bikeRate => _bikeRate;
  double get bikeDuration => _bikeDuration;

  double get carRate => _carRate;
  double get carDuration => _carDuration;

  ParkingRateProvider() {
    _loadRates();
  }

  Future<void> _loadRates() async {
    final prefs = await SharedPreferences.getInstance();
    _bikeRate = prefs.getDouble('bikeRate') ?? 4.0;
    _bikeDuration = prefs.getDouble('bikeDuration') ?? 1.0;

    _carRate = prefs.getDouble('carRate') ?? 15.0;
    _carDuration = prefs.getDouble('carDuration') ?? 1.0;
    notifyListeners();
  }

  Future<void> updateBikeRates({
    required double rate,
    required double duration,
  }) async {
    _bikeRate = rate;
    _bikeDuration = duration;
    notifyListeners();

    final prefs = await SharedPreferences.getInstance();
    await prefs.setDouble('bikeRate', rate);
    await prefs.setDouble('bikeDuration', duration);
  }

  Future<void> updateCarRates({
    required double rate,
    required double duration,
  }) async {
    _carRate = rate;
    _carDuration = duration;
    notifyListeners();

    final prefs = await SharedPreferences.getInstance();
    await prefs.setDouble('carRate', rate);
    await prefs.setDouble('carDuration', duration);
  }

  double calculateCost(String vehicleType, Duration duration) {
    double rate;
    double unitDuration;

    if (vehicleType == 'Bike') {
      rate = _bikeRate;
      unitDuration = _bikeDuration;
    } else {
      rate = _carRate;
      unitDuration = _carDuration;
    }

    // Use seconds for precise calculation.
    // If duration is 0 (just checked in), maybe charge 0 or 1 unit?
    // Let's charge 0 if exactly 0, otherwise 1 unit minimum.
    if (duration.inSeconds == 0) return 0.0;

    double totalHours = duration.inSeconds / 3600.0;
    double units = (totalHours / unitDuration).ceilToDouble();

    return units * rate;
  }
}
