import 'dart:math';

import 'package:test/test.dart';
import 'package:unitconverter/unitconverter.dart';

enum TestUnit { a, b, c }

void main() {
  group('known conversions', () {
    test('air pressure', () {
      expect(
        UnitConverter.convert(
          1013.25,
          from: AirPressureDim.mbar,
          to: AirPressureDim.inHg,
          using: airPressureUnits,
        ),
        29.92,
      );
      expect(
        UnitConverter.convert(
          29.92,
          from: AirPressureDim.inHg,
          to: AirPressureDim.mmHg,
          using: airPressureUnits,
        ),
        759.97,
      );
    });

    test('weight', () {
      expect(
        UnitConverter.convert(
          1,
          from: WeightDim.kg,
          to: WeightDim.lbs,
          using: weightUnits,
        ),
        2.2,
      );
      expect(
        UnitConverter.convert(
          1000,
          from: WeightDim.kg,
          to: WeightDim.tonne,
          using: weightUnits,
        ),
        1,
      );
    });

    test('height', () {
      expect(
        UnitConverter.convert(
          100,
          from: HeightDim.m,
          to: HeightDim.ft,
          using: heightUnits,
        ),
        328.08,
      );
    });

    test('distance', () {
      expect(
        UnitConverter.convert(
          10,
          from: DistanceDim.km,
          to: DistanceDim.ml,
          using: distanceUnits,
        ),
        6.214,
      );
      expect(
        UnitConverter.convert(
          1,
          from: DistanceDim.ml,
          to: DistanceDim.m,
          using: distanceUnits,
        ),
        1609.34,
      );
      expect(
        UnitConverter.convert(
          1,
          from: DistanceDim.nm,
          to: DistanceDim.m,
          using: distanceUnits,
        ),
        1852,
      );
    });

    test('runway distance', () {
      expect(
        UnitConverter.convert(
          1000,
          from: RunwayDistanceDim.m,
          to: RunwayDistanceDim.ft,
          using: runwayDistanceUnits,
        ),
        3280.84,
      );
    });

    test('horizontal speed', () {
      expect(
        UnitConverter.convert(
          10,
          from: HorizontalSpeedDim.ms,
          to: HorizontalSpeedDim.kmh,
          using: horizontalSpeedUnits,
        ),
        36,
      );
      expect(
        UnitConverter.convert(
          10,
          from: HorizontalSpeedDim.ms,
          to: HorizontalSpeedDim.mph,
          using: horizontalSpeedUnits,
        ),
        22.37,
      );
      expect(
        UnitConverter.convert(
          10,
          from: HorizontalSpeedDim.ms,
          to: HorizontalSpeedDim.kt,
          using: horizontalSpeedUnits,
        ),
        19.44,
      );
    });

    test('vertical speed', () {
      expect(
        UnitConverter.convert(
          1,
          from: VerticalSpeedDim.ms,
          to: VerticalSpeedDim.ftmin,
          using: verticalSpeedUnits,
        ),
        196.85,
      );
    });

    test('temperature', () {
      expect(
        UnitConverter.convert(
          20,
          from: TemperatureDim.c,
          to: TemperatureDim.f,
          using: temperatureUnits,
        ),
        68,
      );
      expect(
        UnitConverter.convert(
          68,
          from: TemperatureDim.f,
          to: TemperatureDim.c,
          using: temperatureUnits,
        ),
        20,
      );
    });
  });

  group('round trips', () {
    test('all linear unit pairs remain within configured precision', () {
      _expectAllLinearRoundTrips(
        value: 1013.25,
        units: AirPressureDim.values,
        using: airPressureUnits,
      );
      _expectAllLinearRoundTrips(
        value: 73.25,
        units: WeightDim.values,
        using: weightUnits,
      );
      _expectAllLinearRoundTrips(
        value: 123.45,
        units: HeightDim.values,
        using: heightUnits,
      );
      _expectAllLinearRoundTrips(
        value: 1000,
        units: DistanceDim.values,
        using: distanceUnits,
      );
      _expectAllLinearRoundTrips(
        value: 850.25,
        units: RunwayDistanceDim.values,
        using: runwayDistanceUnits,
      );
      _expectAllLinearRoundTrips(
        value: 12.34,
        units: HorizontalSpeedDim.values,
        using: horizontalSpeedUnits,
      );
      _expectAllLinearRoundTrips(
        value: 7.89,
        units: VerticalSpeedDim.values,
        using: verticalSpeedUnits,
      );
    });

    test('all temperature unit pairs remain within configured precision', () {
      for (final from in TemperatureDim.values) {
        for (final to in TemperatureDim.values) {
          _expectRoundTrip(
            value: 21.25,
            from: from,
            to: to,
            using: temperatureUnits,
            tolerance: 0.02,
          );
        }
      }
    });
  });

  group('limits', () {
    test('convert rounds without clamping', () {
      expect(
        UnitConverter.convert(
          2000,
          from: AirPressureDim.mbar,
          to: AirPressureDim.inHg,
          using: airPressureUnits,
        ),
        59.06,
      );
    });

    test('convert can return the unrounded value', () {
      final rawValue = 1 *
          distanceUnits.factors[DistanceDim.ft]! /
          distanceUnits.factors[DistanceDim.m]!;

      expect(
        UnitConverter.convert(
          1,
          from: DistanceDim.m,
          to: DistanceDim.ft,
          using: distanceUnits,
          roundResult: false,
        ),
        rawValue,
      );
    });

    test('convert supports call-site precision override', () {
      expect(
        UnitConverter.convert(
          1,
          from: DistanceDim.m,
          to: DistanceDim.ft,
          using: distanceUnits,
          precision: 4,
        ),
        3.2808,
      );
    });

    test('convertAndClamp can clamp without rounding first', () {
      final rawValue = 1013.25 *
          airPressureUnits.factors[AirPressureDim.inHg]! /
          airPressureUnits.factors[AirPressureDim.mbar]!;

      expect(
        UnitConverter.convertAndClamp(
          1013.25,
          from: AirPressureDim.mbar,
          to: AirPressureDim.inHg,
          using: airPressureUnits,
          roundResult: false,
        ),
        rawValue,
      );
    });

    test('convertAndClamp supports call-site precision override', () {
      expect(
        UnitConverter.convertAndClamp(
          1013.25,
          from: AirPressureDim.mbar,
          to: AirPressureDim.inHg,
          using: airPressureUnits,
          precision: 4,
        ),
        29.9213,
      );
    });

    test('convertAndClamp applies maximum and minimum', () {
      expect(
        UnitConverter.convertAndClamp(
          2000,
          from: AirPressureDim.mbar,
          to: AirPressureDim.inHg,
          using: airPressureUnits,
        ),
        32,
      );
      expect(
        UnitConverter.convertAndClamp(
          500,
          from: AirPressureDim.mbar,
          to: AirPressureDim.inHg,
          using: airPressureUnits,
        ),
        28,
      );
    });

    test('convertAndClamp supports a custom maximum', () {
      expect(
        UnitConverter.convertAndClamp(
          2000,
          from: AirPressureDim.mbar,
          to: AirPressureDim.inHg,
          using: airPressureUnits,
          customMaxValue: 30,
        ),
        30,
      );
    });

    test('disabled limits do not clamp', () {
      expect(
        UnitConverter.convertAndClamp(
          100,
          from: WeightDim.kg,
          to: WeightDim.lbs,
          using: weightUnits,
        ),
        220.46,
      );
    });

    test('wind limits clamp independently from speed limits', () {
      expect(
        UnitConverter.convertAndClamp(
          30,
          from: HorizontalSpeedDim.ms,
          to: HorizontalSpeedDim.kt,
          using: windUnits,
        ),
        40,
      );
      expect(
        UnitConverter.convertAndClamp(
          30,
          from: HorizontalSpeedDim.ms,
          to: HorizontalSpeedDim.kt,
          using: horizontalSpeedUnits,
        ),
        58.32,
      );
    });

    test('rejects a custom maximum below the configured minimum', () {
      expect(
        () => UnitConverter.convertAndClamp(
          1013.25,
          from: AirPressureDim.mbar,
          to: AirPressureDim.inHg,
          using: airPressureUnits,
          customMaxValue: 27,
        ),
        throwsArgumentError,
      );
    });

    test('rejects a negative precision override', () {
      expect(
        () => UnitConverter.convert(
          1,
          from: DistanceDim.m,
          to: DistanceDim.ft,
          using: distanceUnits,
          precision: -1,
        ),
        throwsArgumentError,
      );
    });
  });

  group('definitions', () {
    test('maps are immutable', () {
      expect(
        () => distanceUnits.factors[DistanceDim.m] = 2,
        throwsUnsupportedError,
      );
      expect(
        () => distanceUnits.limits[DistanceDim.m] = meterDistanceLimits,
        throwsUnsupportedError,
      );
    });

    test('rejects a missing source limit', () {
      final definition = UnitDefinition<TestUnit>(
        factors: const {TestUnit.a: 1, TestUnit.b: 2},
        limits: const {
          TestUnit.b: UnitLimits(
            enabled: false,
            min: 0,
            max: 0,
            precision: 2,
          ),
        },
      );

      expect(
        () => definition.convert(1, from: TestUnit.a, to: TestUnit.b),
        throwsArgumentError,
      );
    });

    test('rejects a missing target limit', () {
      final definition = UnitDefinition<TestUnit>(
        factors: const {TestUnit.a: 1, TestUnit.b: 2},
        limits: const {
          TestUnit.a: UnitLimits(
            enabled: false,
            min: 0,
            max: 0,
            precision: 2,
          ),
        },
      );

      expect(
        () => definition.convert(1, from: TestUnit.a, to: TestUnit.b),
        throwsArgumentError,
      );
    });

    test('rejects a missing target conversion factor', () {
      final definition = UnitDefinition<TestUnit>(
        factors: const {TestUnit.a: 1},
        limits: const {
          TestUnit.a: UnitLimits(
            enabled: false,
            min: 0,
            max: 0,
            precision: 2,
          ),
          TestUnit.b: UnitLimits(
            enabled: false,
            min: 0,
            max: 0,
            precision: 2,
          ),
        },
      );

      expect(
        () => definition.convert(1, from: TestUnit.a, to: TestUnit.b),
        throwsArgumentError,
      );
    });

    test('rejects a missing source conversion factor', () {
      final definition = UnitDefinition<TestUnit>(
        factors: const {TestUnit.a: 1},
        limits: const {
          TestUnit.a: UnitLimits(
            enabled: false,
            min: 0,
            max: 0,
            precision: 2,
          ),
          TestUnit.b: UnitLimits(
            enabled: false,
            min: 0,
            max: 0,
            precision: 2,
          ),
        },
      );

      expect(
        () => definition.convert(1, from: TestUnit.b, to: TestUnit.a),
        throwsArgumentError,
      );
    });

    test('rejects a zero conversion factor', () {
      final definition = UnitDefinition<TestUnit>(
        factors: const {TestUnit.a: 1, TestUnit.b: 0},
        limits: const {
          TestUnit.a: UnitLimits(
            enabled: false,
            min: 0,
            max: 0,
            precision: 2,
          ),
          TestUnit.b: UnitLimits(
            enabled: false,
            min: 0,
            max: 0,
            precision: 2,
          ),
        },
      );

      expect(
        () => definition.convert(1, from: TestUnit.a, to: TestUnit.b),
        throwsArgumentError,
      );
    });
  });

  group('aviation helpers', () {
    test('calculates density altitude', () {
      expect(
        UnitConverter.calculateDensityAltitude(
          airPressureInchHg: 29.92,
          fieldElevationFt: 1000,
          oatC: 20,
        ),
        1840,
      );
    });
  });
}

void _expectRoundTrip<T extends Enum>({
  required double value,
  required T from,
  required T to,
  required UnitDefinition<T> using,
  required double tolerance,
}) {
  final converted = UnitConverter.convert(
    value,
    from: from,
    to: to,
    using: using,
  );
  final roundTrip = UnitConverter.convert(
    converted,
    from: to,
    to: from,
    using: using,
  );

  expect(roundTrip, closeTo(value, tolerance));
}

void _expectAllLinearRoundTrips<T extends Enum>({
  required double value,
  required List<T> units,
  required UnitDefinition<T> using,
}) {
  for (final from in units) {
    for (final to in units) {
      final sourceFactor = using.factors[from]!;
      final targetFactor = using.factors[to]!;
      final sourcePrecision = using.limits[from]!.precision;
      final targetPrecision = using.limits[to]!.precision;
      final targetRoundingError = 0.5 * pow(10, -targetPrecision);
      final sourceRoundingError = 0.5 * pow(10, -sourcePrecision);
      final tolerance = targetRoundingError * sourceFactor / targetFactor +
          sourceRoundingError +
          1e-9;

      _expectRoundTrip(
        value: value,
        from: from,
        to: to,
        using: using,
        tolerance: tolerance,
      );
    }
  }
}
