import 'dart:math';

import 'package:riverpod/riverpod.dart';

import '../unitconverter.dart';

class UnitConverterNotifier extends StateNotifier<UnitConverter> {
  UnitConverterNotifier(UnitConverter unitConverter) : super(unitConverter);

  void setValue({required double newValue}) {
    state.value = newValue;
    state = state.copyWith();
  }

  void setValueFromDim({required double sourceValue, required dynamic sourceDim, required dynamic conversionMap}) {
    state.setValueFromDim(sourceValue: sourceValue, sourceDim: sourceDim, conversionMap: conversionMap);
    state = state.copyWith();
  }

  void setType({required AirPressureType airPressureType}) {
    state.unitType = airPressureType;
    state = state.copyWith();
  }

  void setDim({required dynamic newUnitDim, required dynamic conversionMap, required Map<dynamic,dynamic> dimLimitsMap}) {
    state = state.convertDim(targetDim: newUnitDim, conversionMap: conversionMap, dimLimitsMap: dimLimitsMap);
  }

  void assignValueDim({required double sourceValue, required dynamic sourceDim, required dynamic targetDim, required dynamic conversionMap, required dynamic unitLimitsMap}) {
    state = state.convertValueToDim(sourceValue: sourceValue, sourceDim: sourceDim, targetDim: targetDim, conversionMap: conversionMap, unitLimitsMap: unitLimitsMap);
  }

  double incrementValue() {
    if (state.value < state.unitLimitsMap[maxValueKey]) {
      var multiplier = (1/pow(10,(state.unitLimitsMap[decimalPrecisionKey])));
      state.value = (state.value + 1*multiplier);
      state = state.copyWith();
    }
    return state.value;
  }

  double decrementValue() {
    if (state.value > state.unitLimitsMap[minValueKey]) {
      var multiplier = (1/pow(10,(state.unitLimitsMap[decimalPrecisionKey])));
      state.value = (state.value - 1*multiplier);
      state = state.copyWith();
    }
    return state.value;
  }

  void convertTemperatureDim({double? sourceValue, dynamic sourceDim, required TemperatureDim targetDim, required dynamic unitLimitsMap}) {
    state = state.convertTemperatureDim(
      sourceValue: sourceValue,
      sourceDim: sourceDim,
      targetDim: targetDim,
      unitLimitsMap: unitLimitsMap
    );
  }
}