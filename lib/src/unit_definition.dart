typedef UnitConversion<T extends Enum> = double Function(
  double value,
  T from,
  T to,
);

final class UnitLimits {
  const UnitLimits({
    required this.enabled,
    required this.min,
    required this.max,
    required this.precision,
  })  : assert(precision >= 0),
        assert(!enabled || min <= max);

  final bool enabled;
  final double min;
  final double max;
  final int precision;

  double round(double value) => value.toPrecision(precision);

  double roundAndClamp(double value, {double? customMaxValue}) {
    final roundedValue = round(value);

    if (!enabled) {
      return roundedValue;
    }

    if (customMaxValue != null && customMaxValue < min) {
      throw ArgumentError.value(
        customMaxValue,
        'customMaxValue',
        'Must be greater than or equal to the configured minimum.',
      );
    }

    final effectiveMax = customMaxValue ?? max;
    return roundedValue.clamp(min, effectiveMax).toDouble();
  }
}

final class UnitDefinition<T extends Enum> {
  UnitDefinition({
    required Map<T, UnitLimits> limits,
    Map<T, double> factors = const {},
    this.converter,
  })  : factors = Map<T, double>.unmodifiable(factors),
        limits = Map<T, UnitLimits>.unmodifiable(limits);

  final Map<T, double> factors;
  final Map<T, UnitLimits> limits;
  final UnitConversion<T>? converter;

  double convert(
    double value, {
    required T from,
    required T to,
  }) {
    _limitsFor(from, parameterName: 'from');
    final targetLimits = _limitsFor(to, parameterName: 'to');
    final convertedValue = _convertValue(value, from: from, to: to);

    return targetLimits.round(convertedValue);
  }

  double convertAndClamp(
    double value, {
    required T from,
    required T to,
    double? customMaxValue,
  }) {
    _limitsFor(from, parameterName: 'from');
    final targetLimits = _limitsFor(to, parameterName: 'to');
    final convertedValue = _convertValue(value, from: from, to: to);

    return targetLimits.roundAndClamp(
      convertedValue,
      customMaxValue: customMaxValue,
    );
  }

  UnitLimits _limitsFor(T unit, {required String parameterName}) {
    final unitLimits = limits[unit];

    if (unitLimits == null) {
      throw ArgumentError.value(
        unit,
        parameterName,
        'Unsupported unit.',
      );
    }

    return unitLimits;
  }

  double _convertValue(
    double value, {
    required T from,
    required T to,
  }) {
    return converter != null
        ? converter!(value, from, to)
        : _convertWithFactors(value, from: from, to: to);
  }

  double _convertWithFactors(
    double value, {
    required T from,
    required T to,
  }) {
    final sourceFactor = factors[from];
    final targetFactor = factors[to];

    if (sourceFactor == null) {
      throw ArgumentError.value(from, 'from', 'Missing conversion factor.');
    }

    if (sourceFactor == 0) {
      throw ArgumentError.value(
        sourceFactor,
        'from',
        'Conversion factors must not be zero.',
      );
    }

    if (targetFactor == null) {
      throw ArgumentError.value(to, 'to', 'Missing conversion factor.');
    }

    if (targetFactor == 0) {
      throw ArgumentError.value(
        targetFactor,
        'to',
        'Conversion factors must not be zero.',
      );
    }

    return value * targetFactor / sourceFactor;
  }
}

extension on double {
  double toPrecision(int precision) {
    return double.parse(toStringAsFixed(precision));
  }
}
