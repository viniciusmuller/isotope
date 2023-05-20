## [0.2.0] - 2023-05-20

### Changed
- Removed the dependency on the `ex_png` library, meaning that `Isotope.Utils.write_to_file/2` is not available anymore.
- Dependencies were bumped to their current stable version

## [0.1.3-rc] - 2021-06-21

### Changed
- Replace the rust `image` crate with the pure elixir `ex_png` library. Resulting in cleaner dependencies and faster compilation times but slower performance on the `Isotope.Utils.write_to_file/2` function.

## [0.1.2-rc] - 2021-06-20

### Changed
- Improve aliases used in the code.

### Fixed
- Add rust source code to hex repository.

## [0.1.1-rc] - 2021-06-20

## Changed
- Add project to `hex.pm`.
