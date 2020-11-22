class Cooldown {
  static final Map<int, int> _tableKmToMins = {
    0: 0,
    2: 1,
    4: 3,
    7: 5,
    10: 7,
    12: 8,
    18: 10,
    30: 15,
    65: 22,
    81: 25,
    250: 45,
    350: 51,
    500: 62,
    700: 77,
    1000: 98,
    1350: 120,
  };

  static int getCooldownForDistance(int distanceInMeter) {
    var cooldown = 0;
    for (var distanceKeyInKm in _tableKmToMins.keys) {
      if (distanceKeyInKm * 1000 <= distanceInMeter) {
        cooldown = _tableKmToMins[distanceKeyInKm];
      }
    }

    return cooldown;
  }
}
