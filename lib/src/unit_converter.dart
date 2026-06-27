import 'unit_definition.dart';

abstract final class UnitConverter {
  static double convert<T extends Enum>(
    double value, {
    required T from,
    required T to,
    required UnitDefinition<T> using,
    bool roundResult = true,
  }) {
    return using.convert(
      value,
      from: from,
      to: to,
      roundResult: roundResult,
    );
  }

  static double convertAndClamp<T extends Enum>(
    double value, {
    required T from,
    required T to,
    required UnitDefinition<T> using,
    double? customMaxValue,
    bool roundResult = true,
  }) {
    return using.convertAndClamp(
      value,
      from: from,
      to: to,
      customMaxValue: customMaxValue,
      roundResult: roundResult,
    );
  }

  static double calculateDensityAltitude({
    required double airPressureInchHg,
    required double fieldElevationFt,
    required double oatC,
  }) {
    final pressureAltitude =
        (29.92 - airPressureInchHg) * 1000 + fieldElevationFt;
    final isaTemperature = (15 - 2 * fieldElevationFt / 1000).roundToDouble();

    return pressureAltitude + 120 * (oatC - isaTemperature);
  }
}
