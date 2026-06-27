import 'package:unitconverter/unitconverter.dart';

void main() {
  _printSection('Navigation and weather');
  _printConversion(
    'Distance',
    10,
    'km',
    UnitConverter.convert(
      10,
      from: DistanceDim.km,
      to: DistanceDim.ml,
      using: distanceUnits,
    ),
    'miles',
  );
  _printConversion(
    'Altimeter',
    1013.25,
    'hPa',
    UnitConverter.convert(
      1013.25,
      from: AirPressureDim.hPa,
      to: AirPressureDim.inHg,
      using: airPressureUnits,
    ),
    'inHg',
  );
  _printConversion(
    'Airspeed',
    120,
    'kt',
    UnitConverter.convert(
      120,
      from: HorizontalSpeedDim.kt,
      to: HorizontalSpeedDim.kmh,
      using: horizontalSpeedUnits,
    ),
    'km/h',
  );

  _printSection('Explicit limits');
  final unclampedWind = UnitConverter.convert(
    30,
    from: HorizontalSpeedDim.ms,
    to: HorizontalSpeedDim.kt,
    using: windUnits,
  );
  final clampedWind = UnitConverter.convertAndClamp(
    30,
    from: HorizontalSpeedDim.ms,
    to: HorizontalSpeedDim.kt,
    using: windUnits,
  );
  print('Wind: $unclampedWind kt, clamped for UI: $clampedWind kt');

  _printSection('Fuel planning');
  const fuelDensity = 0.8;
  final fuelMass = FuelConversions.massFromVolume(
    100,
    volumeUnit: VolumeDim.liter,
    massUnit: WeightDim.kg,
    density: fuelDensity,
    densityUnit: DensityDim.kgPerLiter,
  );
  final fuelMassFlow = FuelConversions.massFlowFromVolumeFlow(
    45,
    volumeFlowUnit: VolumetricFlowDim.literPerHour,
    massFlowUnit: MassFlowDim.kgPerHour,
    density: fuelDensity,
    densityUnit: DensityDim.kgPerLiter,
  );
  print('Fuel load: 100 L at $fuelDensity kg/L = $fuelMass kg');
  print('Fuel flow: 45 L/h at $fuelDensity kg/L = $fuelMassFlow kg/h');

  _printSection('Time and temperature');
  _printConversion(
    'Flight time',
    95,
    'min',
    UnitConverter.convert(
      95,
      from: TimeDim.minute,
      to: TimeDim.hour,
      using: timeUnits,
    ),
    'h',
  );
  _printConversion(
    'Outside air temperature',
    20,
    'C',
    UnitConverter.convert(
      20,
      from: TemperatureDim.c,
      to: TemperatureDim.f,
      using: temperatureUnits,
    ),
    'F',
  );
}

void _printSection(String title) {
  print('\n$title');
  print('-' * title.length);
}

void _printConversion(
  String label,
  num sourceValue,
  String sourceUnit,
  num targetValue,
  String targetUnit,
) {
  print('$label: $sourceValue $sourceUnit = $targetValue $targetUnit');
}
