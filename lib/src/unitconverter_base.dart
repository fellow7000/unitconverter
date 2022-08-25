extension Ex on double {
  double toPrecision(int n) => double.parse(toStringAsFixed(n));
}

enum AirPressureType {QFE, QNH}
enum AirPressureDim {mbar, mmHg, inHg} //Air Pressure in millibar (1013 EU), mmHg (760, RU), inHG (29.92, US)
enum ConverterLimits {minValue, maxValue, roundDecimal}
enum WeightDim {kg, lbs, tonne}
enum HeightDim {m, ft}
enum DistanceDim {m, ft, km, nm, ml}
enum RunwayDistanceDim {m, ft}
enum HorizontalSpeedDim {kt, kmh, ms, mph} // m/s knot / mile/h / km/h
enum VerticalSpeedDim {ftmin, ms} // ft/min m/s
enum TemperatureDim {c, f}

String setLimits = 'setLimits'; //if limits shall be considered
String minValueKey = 'minValue';
String maxValueKey = 'maxValue';
String decimalPrecisionKey = 'decimalPrecision';

class UnitConverter<T> {
  late double value;
  T unitDim;
  T? unitType;
  Map<String, dynamic> unitLimitsMap;
  double? customMaxValue;

  UnitConverter({required this.value, required this.unitDim, this.unitType, required this.unitLimitsMap, this.customMaxValue}) {
    if (customMaxValue != null) {
      unitLimitsMap[maxValueKey] = customMaxValue;
    }

    if (unitLimitsMap[setLimits]) {
      double maxValue = unitLimitsMap[maxValueKey] as double;
      double minValue = unitLimitsMap[minValueKey] as double;

      if (value > maxValue) {
        value = maxValue;
      } else if (value < minValue) {
        value = minValue;
      } else {
        value = value;
      }
    } else {
      value = value;
    }
  }

  UnitConverter convertDim({required T targetDim, required Map<dynamic, dynamic> conversionMap, required Map<dynamic,dynamic> dimLimitsMap, double? customMaxValue}) {
    try {
      var unitLimitsMap = dimLimitsMap[targetDim] as Map<String, Object>;

      double cS = conversionMap[unitDim] as double; //source coefficient
      double cT = conversionMap[targetDim] as double; //destination coefficient
      double newValue = (value * cT / cS).toPrecision(unitLimitsMap[decimalPrecisionKey] as int);

      return UnitConverter(value: newValue, unitDim: targetDim, unitLimitsMap: unitLimitsMap, unitType: unitType, customMaxValue: customMaxValue);
    } catch (e) {
      throw Error();
    }
  }

  UnitConverter convertValueToDim({required double sourceValue, required T sourceDim, required T targetDim, required Map<dynamic, dynamic> conversionMap, required Map<dynamic, dynamic> unitLimitsMap, double? customMaxValue}) {
    try {
      double cS = conversionMap[sourceDim] as double; //source coefficient
      double cT = conversionMap[targetDim] as double; //destination coefficient
      double newValue = sourceValue * cT / cS;

      return UnitConverter(value: newValue, unitDim: targetDim, unitLimitsMap: unitLimitsMap[targetDim]!, unitType: unitType, customMaxValue: customMaxValue);
    } catch (e) {
      throw Error();
    }
  }

  UnitConverter convertTemperatureDim({double? sourceValue, required T? sourceDim, required T targetDim, required Map<dynamic, dynamic> unitLimitsMap}) {
    sourceValue ??= value;
    sourceDim ??= unitDim;
    double newValue;

    if (sourceDim == TemperatureDim.c && targetDim == TemperatureDim.f) {
      newValue = ((sourceValue * 1.8) + 32.0).toPrecision(0);
    } else if (sourceDim == TemperatureDim.f && targetDim == TemperatureDim.c) {
      newValue = ((sourceValue - 32.0) * 0.5556).toPrecision(0);
    } else {
      newValue = sourceValue;
    }

    return UnitConverter(value: newValue, unitDim: targetDim, unitLimitsMap: unitLimitsMap[targetDim]);
  }

  void setValueFromDim({required double sourceValue, required T sourceDim, required Map<dynamic, dynamic> conversionMap}) {
    try {
      double cS = conversionMap[sourceDim] as double; //source coefficient
      double cT = conversionMap[unitDim] as double; //destination coefficient
      value = sourceValue * cT / cS;
    } catch (e) {
      throw Error();
    }
  }

  double directConvert({required double sourceValue, required T sourceDim, required T targetDim, required Map<dynamic, dynamic> conversionMap, double? customMaxValue}) {
    try {
      double cS = conversionMap[sourceDim] as double; //source coefficient
      double cT = conversionMap[targetDim] as double; //destination coefficient
      double newValue = sourceValue * cT / cS;

      return newValue;
    } catch (e) {
      throw Error();
    }
  }

  double calculateDensityAltitude({required airPressureInchHg, required double fieldElevationFt, required oatC}) { //returns value in ft!
        double pressureAltitude = ((29.92 - airPressureInchHg)*1000 + fieldElevationFt);
        double isaTemperature = (15 - 2*fieldElevationFt/1000.0).roundToDouble();
        double densityAltitude = pressureAltitude + (120 * (oatC - isaTemperature));

        return densityAltitude;
  }

  UnitConverter copyWith({
    double? value,
    T? unitDim,
    T? unitType,
    Map<String, dynamic>? unitLimitsMap,
  }) {
    return UnitConverter(
      value: value ?? this.value,
      unitDim: unitDim ?? this.unitDim,
      unitType: unitType ?? this.unitType,
      unitLimitsMap: unitLimitsMap ?? this.unitLimitsMap,
    );
  }
}

///Air Pressure units
var airPressureConversionMap = {
  AirPressureDim.mbar : 33.8639,
  AirPressureDim.mmHg : 25.4,
  AirPressureDim.inHg : 1.0
};

var mbarLimitsMap = {
  setLimits : true,
  minValueKey : 948.0,
  maxValueKey : 1083.0,
  decimalPrecisionKey : 0
};

var mmHgLimitsMap = {
  setLimits : true,
  minValueKey : 711.0,
  maxValueKey : 812.0,
  decimalPrecisionKey : 0
};

var inHgLimitsMap = {
  setLimits : true,
  minValueKey : 28.0,
  maxValueKey : 32.0,
  decimalPrecisionKey : 2
};

var airPressureLimitsMap = {
  AirPressureDim.mbar : mbarLimitsMap,
  AirPressureDim.mmHg: mmHgLimitsMap,
  AirPressureDim.inHg : inHgLimitsMap,
};

//Weight units

var weightConversionMap = {
  WeightDim.kg : 1.0,
  WeightDim.lbs : 2.20462,
  WeightDim.tonne : 0.001
};

var kgLimitsMap = {
  setLimits : true,
  minValueKey : 0.0,
  maxValueKey : 0.0,
  decimalPrecisionKey : 0
};

var lbsLimitsMap = {
  setLimits : true,
  minValueKey : 0.0,
  maxValueKey : 0.0,
  decimalPrecisionKey : 0
};

var tonneLimitsMap = {
  setLimits : true,
  minValueKey : 0.0,
  maxValueKey : 0.0,
  decimalPrecisionKey : 2
};

var weightLimitsMap = {
  WeightDim.kg : kgLimitsMap,
  WeightDim.lbs : lbsLimitsMap,
  WeightDim.tonne : tonneLimitsMap
};

//Height units
var heightConversionMap = {
  HeightDim.m : 1.0,
  HeightDim.ft   : 3.28084,
};

var heightLimitsMap = {
  HeightDim.m : mHeightLimitsMap,
  HeightDim.ft : ftHeightLimitsMap,
};

var mHeightLimitsMap = {
  setLimits :false,
  minValueKey : -1000.0,
  maxValueKey : 14000.0,
  decimalPrecisionKey : 0
};

var ftHeightLimitsMap = {
  setLimits : false,
  minValueKey : -3000.0,
  maxValueKey : 46000.0,
  decimalPrecisionKey : 0
};

//Distance units
var distanceConversionMap = {
  DistanceDim.m : 1.0,
  DistanceDim.ft   : 3.28084,
  DistanceDim.km : 0.001,
  DistanceDim.ml : 0.000621371,
  DistanceDim.nm : 0.000539957
};

var runwayDistanceConversionMap = {
  RunwayDistanceDim.m : 1.0,
  RunwayDistanceDim.ft   : 3.28084,
};

var mDistanceLimitsMap = {
  setLimits :false,
  minValueKey : -1000.0,
  maxValueKey : 14000.0,
  decimalPrecisionKey : 0
};

var ftDistanceLimitsMap = {
  setLimits : false,
  minValueKey : -3000.0,
  maxValueKey : 46000.0,
  decimalPrecisionKey : 0
};

var kmDistanceLimitsMap = {
  setLimits : false,
  minValueKey : -3000.0,
  maxValueKey : 46000.0,
  decimalPrecisionKey : 0
};

var mlDistanceLimitsMap = {
  setLimits : false,
  minValueKey : -3000.0,
  maxValueKey : 46000.0,
  decimalPrecisionKey : 0
};

var nmDistanceLimitsMap = {
  setLimits : false,
  minValueKey : -3000.0,
  maxValueKey : 46000.0,
  decimalPrecisionKey : 0
};

var distanceLimitsMap = {
  DistanceDim.m : mDistanceLimitsMap,
  DistanceDim.ft: ftDistanceLimitsMap,
  DistanceDim.km : kmDistanceLimitsMap,
  DistanceDim.ml : mlDistanceLimitsMap,
  DistanceDim.nm : nmDistanceLimitsMap
};

//Speed Units
var horizontalSpeedConversionMap = {
  HorizontalSpeedDim.ms : 1.0,
  HorizontalSpeedDim.kmh   : 3.6,
  HorizontalSpeedDim.mph : 2.23694,
  HorizontalSpeedDim.kt : 1.9438477170141,
};

var horizontalSpeedLimitsMap = {
  HorizontalSpeedDim.ms : msSpeedLimitsMap,
  HorizontalSpeedDim.kmh : kmhSpeedLimitsMap,
  HorizontalSpeedDim.mph : mphSpeedLimitsMap,
  HorizontalSpeedDim.kt : ktSpeedLimitsMap
};

var msSpeedLimitsMap = {
  setLimits :false,
  minValueKey : 0.0,
  maxValueKey : 0.0,
  decimalPrecisionKey : 2
};

var kmhSpeedLimitsMap = {
  setLimits : false,
  minValueKey : 0.0,
  maxValueKey : 0.0,
  decimalPrecisionKey : 2
};

var mphSpeedLimitsMap = {
  setLimits : false,
  minValueKey : 0.0,
  maxValueKey : 0.0,
  decimalPrecisionKey : 0
};

var ktSpeedLimitsMap = {
  setLimits : false,
  minValueKey : 0.0,
  maxValueKey : 0.0,
  decimalPrecisionKey : 0
};

//Wind Limit Maps
var msWindLimitsMap = {
  setLimits :true,
  minValueKey : 0.0,
  maxValueKey : 20.0,
  decimalPrecisionKey : 0
};

var kmhWindLimitsMap = {
  setLimits : true,
  minValueKey : 0.0,
  maxValueKey : 70.0,
  decimalPrecisionKey : 0
};

var mphWindLimitsMap = {
  setLimits : true,
  minValueKey : 0.0,
  maxValueKey : 45.0,
  decimalPrecisionKey : 0
};

var ktWindLimitsMap = {
  setLimits : true,
  minValueKey : 0.0,
  maxValueKey : 40.0,
  decimalPrecisionKey : 0
};

var windLimitsMap = {
  HorizontalSpeedDim.ms : msWindLimitsMap,
  HorizontalSpeedDim.kmh : kmhWindLimitsMap,
  HorizontalSpeedDim.mph : mphWindLimitsMap,
  HorizontalSpeedDim.kt :ktWindLimitsMap
};

//Vertical units
var verticalSpeedConversionMap = {
  VerticalSpeedDim.ms : 1.0,
  VerticalSpeedDim.ftmin   : 196.85,
};

var verticalSpeedLimitsMap = {
  VerticalSpeedDim.ms : msSpeedLimitsMap,
  VerticalSpeedDim.ftmin : ftMinSpeedLimitsMap
};

var ftMinSpeedLimitsMap = {
  setLimits : false,
  minValueKey : 0.0,
  maxValueKey : 0.0,
  decimalPrecisionKey : 2
};

var limitsMap = {
  WeightDim : weightLimitsMap,
  HeightDim : heightLimitsMap,
  DistanceDim : distanceLimitsMap,
  RunwayDistanceDim : distanceLimitsMap,
  HorizontalSpeedDim : horizontalSpeedLimitsMap,
  VerticalSpeedDim : verticalSpeedLimitsMap,
};

var celsiusLimitsMap = {
  setLimits: true,
  minValueKey : -35.0,
  maxValueKey : 45.0,
  decimalPrecisionKey : 0
};

var fahrenheitLimitsMap = {
  setLimits: true,
  minValueKey : -31.0,
  maxValueKey : 113.0,
  decimalPrecisionKey : 0
};

var temperatureLimitsMap = {
  TemperatureDim.c : celsiusLimitsMap,
  TemperatureDim.f : fahrenheitLimitsMap
};

