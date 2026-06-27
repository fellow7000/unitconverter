## 2.0.0

- Added typed generic unit definitions and conversion APIs.
- Added `convertAndClamp` to make limit enforcement explicit.
- Changed `convert` to perform conversion and target precision rounding only.
- Audited built-in conversion factors and increased precision to avoid lossy
  default results.
- Disabled invalid zero-valued weight limits.
- Split unit types, definitions, conversion logic, and fuel helpers.
- Added known-value, full pairwise round-trip, limit, and error tests.
- Added aviation volume, time, density, volumetric-flow, and mass-flow units.
- Added `hPa` as an aviation pressure-unit name equivalent to `mbar`.
- Added density-dependent fuel mass/volume and fuel-flow conversion helpers.
- Expanded the console example into an aviation-oriented walkthrough.
- Removed the legacy map-based and instance-based conversion APIs.
- Removed the Riverpod dependency and notifier.

## 1.x

- Previous map-based API used by existing applications.
