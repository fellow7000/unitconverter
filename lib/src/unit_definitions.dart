import 'unit_definition.dart';
import 'unit_types.dart';

const mbarLimits = UnitLimits(
  enabled: true,
  min: 948,
  max: 1083,
  precision: 2,
);
const hPaLimits = UnitLimits(
  enabled: true,
  min: 948,
  max: 1083,
  precision: 2,
);
const mmHgLimits = UnitLimits(
  enabled: true,
  min: 711,
  max: 812,
  precision: 2,
);
const inHgLimits = UnitLimits(
  enabled: true,
  min: 28,
  max: 32,
  precision: 2,
);

const kgLimits = UnitLimits(
  enabled: false,
  min: 0,
  max: 0,
  precision: 2,
);
const lbsLimits = UnitLimits(
  enabled: false,
  min: 0,
  max: 0,
  precision: 2,
);
const tonneLimits = UnitLimits(
  enabled: false,
  min: 0,
  max: 0,
  precision: 3,
);

const meterHeightLimits = UnitLimits(
  enabled: false,
  min: -1000,
  max: 14000,
  precision: 2,
);
const feetHeightLimits = UnitLimits(
  enabled: false,
  min: -3000,
  max: 46000,
  precision: 2,
);

const meterDistanceLimits = UnitLimits(
  enabled: false,
  min: -1000,
  max: 14000,
  precision: 2,
);
const feetDistanceLimits = UnitLimits(
  enabled: false,
  min: -3000,
  max: 46000,
  precision: 2,
);
const kilometerDistanceLimits = UnitLimits(
  enabled: false,
  min: -3000,
  max: 46000,
  precision: 3,
);
const mileDistanceLimits = UnitLimits(
  enabled: false,
  min: -3000,
  max: 46000,
  precision: 3,
);
const nauticalMileDistanceLimits = UnitLimits(
  enabled: false,
  min: -3000,
  max: 46000,
  precision: 3,
);

const metersPerSecondSpeedLimits = UnitLimits(
  enabled: false,
  min: 0,
  max: 0,
  precision: 2,
);
const kilometersPerHourSpeedLimits = UnitLimits(
  enabled: false,
  min: 0,
  max: 0,
  precision: 2,
);
const milesPerHourSpeedLimits = UnitLimits(
  enabled: false,
  min: 0,
  max: 0,
  precision: 2,
);
const knotsSpeedLimits = UnitLimits(
  enabled: false,
  min: 0,
  max: 0,
  precision: 2,
);

const metersPerSecondWindLimits = UnitLimits(
  enabled: true,
  min: 0,
  max: 20,
  precision: 2,
);
const kilometersPerHourWindLimits = UnitLimits(
  enabled: true,
  min: 0,
  max: 70,
  precision: 2,
);
const milesPerHourWindLimits = UnitLimits(
  enabled: true,
  min: 0,
  max: 45,
  precision: 2,
);
const knotsWindLimits = UnitLimits(
  enabled: true,
  min: 0,
  max: 40,
  precision: 2,
);

const feetPerMinuteSpeedLimits = UnitLimits(
  enabled: false,
  min: 0,
  max: 0,
  precision: 2,
);

const celsiusLimits = UnitLimits(
  enabled: true,
  min: -35,
  max: 45,
  precision: 2,
);
const fahrenheitLimits = UnitLimits(
  enabled: true,
  min: -31,
  max: 113,
  precision: 2,
);

const literLimits = UnitLimits(
  enabled: false,
  min: 0,
  max: 0,
  precision: 3,
);
const usGallonLimits = UnitLimits(
  enabled: false,
  min: 0,
  max: 0,
  precision: 3,
);
const imperialGallonLimits = UnitLimits(
  enabled: false,
  min: 0,
  max: 0,
  precision: 3,
);
const usQuartLimits = UnitLimits(
  enabled: false,
  min: 0,
  max: 0,
  precision: 3,
);

const secondLimits = UnitLimits(
  enabled: false,
  min: 0,
  max: 0,
  precision: 2,
);
const minuteLimits = UnitLimits(
  enabled: false,
  min: 0,
  max: 0,
  precision: 2,
);
const hourLimits = UnitLimits(
  enabled: false,
  min: 0,
  max: 0,
  precision: 3,
);

const kgPerLiterLimits = UnitLimits(
  enabled: false,
  min: 0,
  max: 0,
  precision: 4,
);
const kgPerCubicMeterLimits = UnitLimits(
  enabled: false,
  min: 0,
  max: 0,
  precision: 2,
);
const lbPerUsGallonLimits = UnitLimits(
  enabled: false,
  min: 0,
  max: 0,
  precision: 3,
);

const literPerHourLimits = UnitLimits(
  enabled: false,
  min: 0,
  max: 0,
  precision: 3,
);
const usGallonPerHourLimits = UnitLimits(
  enabled: false,
  min: 0,
  max: 0,
  precision: 3,
);
const imperialGallonPerHourLimits = UnitLimits(
  enabled: false,
  min: 0,
  max: 0,
  precision: 3,
);

const kgPerHourLimits = UnitLimits(
  enabled: false,
  min: 0,
  max: 0,
  precision: 3,
);
const lbPerHourLimits = UnitLimits(
  enabled: false,
  min: 0,
  max: 0,
  precision: 3,
);

final airPressureUnits = UnitDefinition<AirPressureDim>(
  factors: const {
    AirPressureDim.mbar: 33.8638866667,
    AirPressureDim.hPa: 33.8638866667,
    AirPressureDim.mmHg: 25.4,
    AirPressureDim.inHg: 1,
  },
  limits: const {
    AirPressureDim.mbar: mbarLimits,
    AirPressureDim.hPa: hPaLimits,
    AirPressureDim.mmHg: mmHgLimits,
    AirPressureDim.inHg: inHgLimits,
  },
);

final weightUnits = UnitDefinition<WeightDim>(
  factors: const {
    WeightDim.kg: 1,
    WeightDim.lbs: 2.20462262185,
    WeightDim.tonne: 0.001,
  },
  limits: const {
    WeightDim.kg: kgLimits,
    WeightDim.lbs: lbsLimits,
    WeightDim.tonne: tonneLimits,
  },
);

final heightUnits = UnitDefinition<HeightDim>(
  factors: const {
    HeightDim.m: 1,
    HeightDim.ft: 3.28083989501,
  },
  limits: const {
    HeightDim.m: meterHeightLimits,
    HeightDim.ft: feetHeightLimits,
  },
);

final distanceUnits = UnitDefinition<DistanceDim>(
  factors: const {
    DistanceDim.m: 1,
    DistanceDim.ft: 3.28083989501,
    DistanceDim.km: 0.001,
    DistanceDim.ml: 0.000621371192237,
    DistanceDim.nm: 0.000539956803456,
  },
  limits: const {
    DistanceDim.m: meterDistanceLimits,
    DistanceDim.ft: feetDistanceLimits,
    DistanceDim.km: kilometerDistanceLimits,
    DistanceDim.ml: mileDistanceLimits,
    DistanceDim.nm: nauticalMileDistanceLimits,
  },
);

final runwayDistanceUnits = UnitDefinition<RunwayDistanceDim>(
  factors: const {
    RunwayDistanceDim.m: 1,
    RunwayDistanceDim.ft: 3.28083989501,
  },
  limits: const {
    RunwayDistanceDim.m: meterDistanceLimits,
    RunwayDistanceDim.ft: feetDistanceLimits,
  },
);

final horizontalSpeedUnits = UnitDefinition<HorizontalSpeedDim>(
  factors: const {
    HorizontalSpeedDim.ms: 1,
    HorizontalSpeedDim.kmh: 3.6,
    HorizontalSpeedDim.mph: 2.23693629205,
    HorizontalSpeedDim.kt: 1.94384449244,
  },
  limits: const {
    HorizontalSpeedDim.ms: metersPerSecondSpeedLimits,
    HorizontalSpeedDim.kmh: kilometersPerHourSpeedLimits,
    HorizontalSpeedDim.mph: milesPerHourSpeedLimits,
    HorizontalSpeedDim.kt: knotsSpeedLimits,
  },
);

final windUnits = UnitDefinition<HorizontalSpeedDim>(
  factors: horizontalSpeedUnits.factors,
  limits: const {
    HorizontalSpeedDim.ms: metersPerSecondWindLimits,
    HorizontalSpeedDim.kmh: kilometersPerHourWindLimits,
    HorizontalSpeedDim.mph: milesPerHourWindLimits,
    HorizontalSpeedDim.kt: knotsWindLimits,
  },
);

final verticalSpeedUnits = UnitDefinition<VerticalSpeedDim>(
  factors: const {
    VerticalSpeedDim.ms: 1,
    VerticalSpeedDim.ftmin: 196.850393701,
  },
  limits: const {
    VerticalSpeedDim.ms: metersPerSecondSpeedLimits,
    VerticalSpeedDim.ftmin: feetPerMinuteSpeedLimits,
  },
);

final temperatureUnits = UnitDefinition<TemperatureDim>(
  converter: _convertTemperature,
  limits: const {
    TemperatureDim.c: celsiusLimits,
    TemperatureDim.f: fahrenheitLimits,
  },
);

final volumeUnits = UnitDefinition<VolumeDim>(
  factors: const {
    VolumeDim.liter: 1,
    VolumeDim.usGallon: 0.264172052358,
    VolumeDim.imperialGallon: 0.219969248299,
    VolumeDim.usQuart: 1.05668820943,
  },
  limits: const {
    VolumeDim.liter: literLimits,
    VolumeDim.usGallon: usGallonLimits,
    VolumeDim.imperialGallon: imperialGallonLimits,
    VolumeDim.usQuart: usQuartLimits,
  },
);

final timeUnits = UnitDefinition<TimeDim>(
  factors: const {
    TimeDim.second: 1,
    TimeDim.minute: 1 / 60,
    TimeDim.hour: 1 / 3600,
  },
  limits: const {
    TimeDim.second: secondLimits,
    TimeDim.minute: minuteLimits,
    TimeDim.hour: hourLimits,
  },
);

final densityUnits = UnitDefinition<DensityDim>(
  factors: const {
    DensityDim.kgPerLiter: 1,
    DensityDim.kgPerCubicMeter: 1000,
    DensityDim.lbPerUsGallon: 8.34540445202,
  },
  limits: const {
    DensityDim.kgPerLiter: kgPerLiterLimits,
    DensityDim.kgPerCubicMeter: kgPerCubicMeterLimits,
    DensityDim.lbPerUsGallon: lbPerUsGallonLimits,
  },
);

final volumetricFlowUnits = UnitDefinition<VolumetricFlowDim>(
  factors: const {
    VolumetricFlowDim.literPerHour: 1,
    VolumetricFlowDim.usGallonPerHour: 0.264172052358,
    VolumetricFlowDim.imperialGallonPerHour: 0.219969248299,
  },
  limits: const {
    VolumetricFlowDim.literPerHour: literPerHourLimits,
    VolumetricFlowDim.usGallonPerHour: usGallonPerHourLimits,
    VolumetricFlowDim.imperialGallonPerHour: imperialGallonPerHourLimits,
  },
);

final massFlowUnits = UnitDefinition<MassFlowDim>(
  factors: const {
    MassFlowDim.kgPerHour: 1,
    MassFlowDim.lbPerHour: 2.20462262185,
  },
  limits: const {
    MassFlowDim.kgPerHour: kgPerHourLimits,
    MassFlowDim.lbPerHour: lbPerHourLimits,
  },
);

double _convertTemperature(
  double value,
  TemperatureDim from,
  TemperatureDim to,
) {
  if (from == TemperatureDim.c && to == TemperatureDim.f) {
    return (value * 9 / 5) + 32;
  }

  if (from == TemperatureDim.f && to == TemperatureDim.c) {
    return (value - 32) * 5 / 9;
  }

  return value;
}
