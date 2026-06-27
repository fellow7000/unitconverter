import 'unit_definition.dart';
import 'unit_definitions.dart';
import 'unit_types.dart';

abstract final class FuelConversions {
  static double massFromVolume(
    double volume, {
    required VolumeDim volumeUnit,
    required WeightDim massUnit,
    required double density,
    required DensityDim densityUnit,
    bool roundResult = true,
  }) {
    _validateQuantity(volume, 'volume');
    _validateDensity(density);

    final liters = _convertLinear(
      volume,
      from: volumeUnit,
      to: VolumeDim.liter,
      using: volumeUnits,
    );
    final kgPerLiter = _convertLinear(
      density,
      from: densityUnit,
      to: DensityDim.kgPerLiter,
      using: densityUnits,
    );

    return _convertLinearAndApplyPrecision(
      liters * kgPerLiter,
      from: WeightDim.kg,
      to: massUnit,
      using: weightUnits,
      roundResult: roundResult,
    );
  }

  static double volumeFromMass(
    double mass, {
    required WeightDim massUnit,
    required VolumeDim volumeUnit,
    required double density,
    required DensityDim densityUnit,
    bool roundResult = true,
  }) {
    _validateQuantity(mass, 'mass');
    _validateDensity(density);

    final kilograms = _convertLinear(
      mass,
      from: massUnit,
      to: WeightDim.kg,
      using: weightUnits,
    );
    final kgPerLiter = _convertLinear(
      density,
      from: densityUnit,
      to: DensityDim.kgPerLiter,
      using: densityUnits,
    );

    return _convertLinearAndApplyPrecision(
      kilograms / kgPerLiter,
      from: VolumeDim.liter,
      to: volumeUnit,
      using: volumeUnits,
      roundResult: roundResult,
    );
  }

  static double massFlowFromVolumeFlow(
    double volumeFlow, {
    required VolumetricFlowDim volumeFlowUnit,
    required MassFlowDim massFlowUnit,
    required double density,
    required DensityDim densityUnit,
    bool roundResult = true,
  }) {
    _validateQuantity(volumeFlow, 'volumeFlow');
    _validateDensity(density);

    final litersPerHour = _convertLinear(
      volumeFlow,
      from: volumeFlowUnit,
      to: VolumetricFlowDim.literPerHour,
      using: volumetricFlowUnits,
    );
    final kgPerLiter = _convertLinear(
      density,
      from: densityUnit,
      to: DensityDim.kgPerLiter,
      using: densityUnits,
    );

    return _convertLinearAndApplyPrecision(
      litersPerHour * kgPerLiter,
      from: MassFlowDim.kgPerHour,
      to: massFlowUnit,
      using: massFlowUnits,
      roundResult: roundResult,
    );
  }

  static double volumeFlowFromMassFlow(
    double massFlow, {
    required MassFlowDim massFlowUnit,
    required VolumetricFlowDim volumeFlowUnit,
    required double density,
    required DensityDim densityUnit,
    bool roundResult = true,
  }) {
    _validateQuantity(massFlow, 'massFlow');
    _validateDensity(density);

    final kgPerHour = _convertLinear(
      massFlow,
      from: massFlowUnit,
      to: MassFlowDim.kgPerHour,
      using: massFlowUnits,
    );
    final kgPerLiter = _convertLinear(
      density,
      from: densityUnit,
      to: DensityDim.kgPerLiter,
      using: densityUnits,
    );

    return _convertLinearAndApplyPrecision(
      kgPerHour / kgPerLiter,
      from: VolumetricFlowDim.literPerHour,
      to: volumeFlowUnit,
      using: volumetricFlowUnits,
      roundResult: roundResult,
    );
  }

  static double _convertLinear<T extends Enum>(
    double value, {
    required T from,
    required T to,
    required UnitDefinition<T> using,
  }) {
    return value * using.factors[to]! / using.factors[from]!;
  }

  static double _convertLinearAndApplyPrecision<T extends Enum>(
    double value, {
    required T from,
    required T to,
    required UnitDefinition<T> using,
    required bool roundResult,
  }) {
    final converted = _convertLinear(value, from: from, to: to, using: using);

    return roundResult ? using.limits[to]!.round(converted) : converted;
  }

  static void _validateQuantity(double value, String name) {
    if (!value.isFinite || value < 0) {
      throw ArgumentError.value(
        value,
        name,
        'Fuel quantities must be finite and non-negative.',
      );
    }
  }

  static void _validateDensity(double density) {
    if (!density.isFinite || density <= 0) {
      throw ArgumentError.value(
        density,
        'density',
        'Fuel density must be finite and greater than zero.',
      );
    }
  }
}
