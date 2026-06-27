import 'dart:math';

import 'package:test/test.dart';
import 'package:unitconverter/unitconverter.dart';

void main() {
  group('aviation unit conversions', () {
    test('hectopascal and millibar are numerically equivalent', () {
      expect(
        UnitConverter.convert(
          1013.25,
          from: AirPressureDim.hPa,
          to: AirPressureDim.mbar,
          using: airPressureUnits,
        ),
        1013.25,
      );
    });

    test('volume', () {
      expect(
        UnitConverter.convert(
          1,
          from: VolumeDim.usGallon,
          to: VolumeDim.liter,
          using: volumeUnits,
        ),
        3.785,
      );
      expect(
        UnitConverter.convert(
          1,
          from: VolumeDim.imperialGallon,
          to: VolumeDim.liter,
          using: volumeUnits,
        ),
        4.546,
      );
      expect(
        UnitConverter.convert(
          4,
          from: VolumeDim.usQuart,
          to: VolumeDim.usGallon,
          using: volumeUnits,
        ),
        1,
      );
    });

    test('time', () {
      expect(
        UnitConverter.convert(
          90,
          from: TimeDim.minute,
          to: TimeDim.hour,
          using: timeUnits,
        ),
        1.5,
      );
      expect(
        UnitConverter.convert(
          2,
          from: TimeDim.hour,
          to: TimeDim.second,
          using: timeUnits,
        ),
        7200,
      );
    });

    test('density', () {
      expect(
        UnitConverter.convert(
          0.8,
          from: DensityDim.kgPerLiter,
          to: DensityDim.kgPerCubicMeter,
          using: densityUnits,
        ),
        800,
      );
      expect(
        UnitConverter.convert(
          0.8,
          from: DensityDim.kgPerLiter,
          to: DensityDim.lbPerUsGallon,
          using: densityUnits,
        ),
        6.676,
      );
    });

    test('volumetric flow', () {
      expect(
        UnitConverter.convert(
          10,
          from: VolumetricFlowDim.usGallonPerHour,
          to: VolumetricFlowDim.literPerHour,
          using: volumetricFlowUnits,
        ),
        37.854,
      );
    });

    test('mass flow', () {
      expect(
        UnitConverter.convert(
          100,
          from: MassFlowDim.lbPerHour,
          to: MassFlowDim.kgPerHour,
          using: massFlowUnits,
        ),
        45.359,
      );
    });
  });

  group('aviation unit round trips', () {
    test('all new linear unit pairs remain within configured precision', () {
      _expectAllLinearRoundTrips(
        value: 42.125,
        units: VolumeDim.values,
        using: volumeUnits,
      );
      _expectAllLinearRoundTrips(
        value: 7200,
        units: TimeDim.values,
        using: timeUnits,
      );
      _expectAllLinearRoundTrips(
        value: 0.81,
        units: DensityDim.values,
        using: densityUnits,
      );
      _expectAllLinearRoundTrips(
        value: 32.5,
        units: VolumetricFlowDim.values,
        using: volumetricFlowUnits,
      );
      _expectAllLinearRoundTrips(
        value: 120.5,
        units: MassFlowDim.values,
        using: massFlowUnits,
      );
    });
  });

  group('fuel conversions', () {
    test('converts fuel volume to mass using supplied density', () {
      expect(
        FuelConversions.massFromVolume(
          100,
          volumeUnit: VolumeDim.liter,
          massUnit: WeightDim.kg,
          density: 0.8,
          densityUnit: DensityDim.kgPerLiter,
        ),
        80,
      );
      expect(
        FuelConversions.massFromVolume(
          10,
          volumeUnit: VolumeDim.usGallon,
          massUnit: WeightDim.lbs,
          density: 6,
          densityUnit: DensityDim.lbPerUsGallon,
        ),
        closeTo(60, 0.02),
      );
    });

    test('converts fuel mass to volume using supplied density', () {
      expect(
        FuelConversions.volumeFromMass(
          80,
          massUnit: WeightDim.kg,
          volumeUnit: VolumeDim.liter,
          density: 0.8,
          densityUnit: DensityDim.kgPerLiter,
        ),
        100,
      );
      expect(
        FuelConversions.volumeFromMass(
          60,
          massUnit: WeightDim.lbs,
          volumeUnit: VolumeDim.usGallon,
          density: 6,
          densityUnit: DensityDim.lbPerUsGallon,
        ),
        closeTo(10, 0.002),
      );
    });

    test('converts volume flow to mass flow using supplied density', () {
      expect(
        FuelConversions.massFlowFromVolumeFlow(
          50,
          volumeFlowUnit: VolumetricFlowDim.literPerHour,
          massFlowUnit: MassFlowDim.kgPerHour,
          density: 0.8,
          densityUnit: DensityDim.kgPerLiter,
        ),
        40,
      );
    });

    test('converts mass flow to volume flow using supplied density', () {
      expect(
        FuelConversions.volumeFlowFromMassFlow(
          40,
          massFlowUnit: MassFlowDim.kgPerHour,
          volumeFlowUnit: VolumetricFlowDim.literPerHour,
          density: 0.8,
          densityUnit: DensityDim.kgPerLiter,
        ),
        50,
      );
    });

    test('rejects non-positive and non-finite density', () {
      for (final density in [0.0, -1.0, double.nan, double.infinity]) {
        expect(
          () => FuelConversions.massFromVolume(
            100,
            volumeUnit: VolumeDim.liter,
            massUnit: WeightDim.kg,
            density: density,
            densityUnit: DensityDim.kgPerLiter,
          ),
          throwsArgumentError,
        );
      }
    });

    test('rejects negative and non-finite fuel quantities', () {
      for (final volume in [-1.0, double.nan, double.infinity]) {
        expect(
          () => FuelConversions.massFromVolume(
            volume,
            volumeUnit: VolumeDim.liter,
            massUnit: WeightDim.kg,
            density: 0.8,
            densityUnit: DensityDim.kgPerLiter,
          ),
          throwsArgumentError,
        );
      }
    });
  });
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
  }
}
