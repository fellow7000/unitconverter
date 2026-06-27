# Unit Converter

A pure Dart library for converting values between common units. It has no
Flutter or state-management dependencies and supports sound null safety.

## Supported dimensions

- Air pressure
- Weight
- Height
- Distance and runway distance
- Horizontal and vertical speed
- Wind speed with configurable limits
- Temperature
- Volume: liters, US gallons, Imperial gallons, and US quarts
- Time: seconds, minutes, and hours
- Density: kg/L, kg/m3, and lb/US gal
- Volumetric flow: L/h, US gal/h, and Imperial gal/h
- Mass flow: kg/h and lb/h

Air pressure supports both `mbar` and `hPa`. They are numerically equivalent,
but both names are available for aviation-facing APIs.

## Usage

Use the generic `UnitConverter.convert` method with a typed unit definition:

```dart
import 'package:unitconverter/unitconverter.dart';

void main() {
  final miles = UnitConverter.convert(
    10,
    from: DistanceDim.km,
    to: DistanceDim.ml,
    using: distanceUnits,
  );

  print(miles); // 6.214
}
```

`DistanceDim.ml` is the package's established enum value for statute miles.
`DistanceDim.nm` represents nautical miles.

Each `UnitDefinition` contains the conversion factors, precision, and optional
target-unit limits, so they cannot be mixed accidentally at the call site.

## Limits and precision

`UnitConverter.convert` converts and rounds using the target unit's precision by
default. It does not apply min/max limits:

```dart
final pressure = UnitConverter.convert(
  2000,
  from: AirPressureDim.mbar,
  to: AirPressureDim.inHg,
  using: airPressureUnits,
);

print(pressure); // 59.06
```

Pass `precision` to override the target unit's configured decimal precision for
one call:

```dart
final pressure = UnitConverter.convert(
  2000,
  from: AirPressureDim.mbar,
  to: AirPressureDim.inHg,
  using: airPressureUnits,
  precision: 4,
);
```

Set `roundResult` to `false` when the caller needs the raw converted value:

```dart
final pressure = UnitConverter.convert(
  2000,
  from: AirPressureDim.mbar,
  to: AirPressureDim.inHg,
  using: airPressureUnits,
  roundResult: false,
);
```

Use `UnitConverter.convertAndClamp` when configured limits are part of the
required behavior. It also rounds by default and accepts `roundResult: false`
when clamping should be applied to the raw converted value. `precision` is also
available on `convertAndClamp` and the fuel conversion helpers:

```dart
final pressure = UnitConverter.convertAndClamp(
  2000,
  from: AirPressureDim.mbar,
  to: AirPressureDim.inHg,
  using: airPressureUnits,
);

print(pressure); // 32.0
```

The clamping call can override the configured maximum:

```dart
final pressure = UnitConverter.convertAndClamp(
  2000,
  from: AirPressureDim.mbar,
  to: AirPressureDim.inHg,
  using: airPressureUnits,
  customMaxValue: 30,
);
```

## Fuel calculations

Fuel mass/volume and mass-flow/volume-flow conversions require an explicit
density. The library does not assume one density for every aviation fuel:

```dart
final fuelMass = FuelConversions.massFromVolume(
  100,
  volumeUnit: VolumeDim.liter,
  massUnit: WeightDim.kg,
  density: 0.8,
  densityUnit: DensityDim.kgPerLiter,
);

final massFlow = FuelConversions.massFlowFromVolumeFlow(
  45,
  volumeFlowUnit: VolumetricFlowDim.literPerHour,
  massFlowUnit: MassFlowDim.kgPerHour,
  density: 0.8,
  densityUnit: DensityDim.kgPerLiter,
);
```

Fuel quantities must be finite and non-negative. Density must be finite and
greater than zero.

## Console example

Run the included aviation-oriented console demonstration:

```shell
dart run example/unitconverter_example.dart
```

## Custom definitions

Linear conversions use factors relative to a common base unit:

```dart
enum LengthUnit { meter, centimeter }

final lengthUnits = UnitDefinition<LengthUnit>(
  factors: {
    LengthUnit.meter: 1,
    LengthUnit.centimeter: 100,
  },
  limits: {
    LengthUnit.meter: UnitLimits(
      enabled: false,
      min: 0,
      max: 0,
      precision: 2,
    ),
    LengthUnit.centimeter: UnitLimits(
      enabled: false,
      min: 0,
      max: 0,
      precision: 2,
    ),
  },
);
```

`UnitDefinition` also accepts a custom converter for affine or other
non-factor conversions, as used by `temperatureUnits`.

## Package structure

- `unit_types.dart`: supported unit enums
- `unit_definition.dart`: typed definitions and limit behavior
- `unit_definitions.dart`: audited built-in factors, precision, and limits
- `fuel_conversions.dart`: density-dependent fuel calculations
- `unit_converter.dart`: conversion API
