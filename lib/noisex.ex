defmodule Noisex do
  @moduledoc """
  This library provides Elixir bindings to rust's [bracket-noise](https://crates.io/crates/bracket-noise)
  library, which is a rust port of [FastNoise](https://github.com/Auburn/FastNoiseLite).

  The core of this module is implemented using [NIFs](https://erlang.org/doc/tutorial/nif.html),
  and most of the functions use a reference (`t:Noisex.Noise.noise_ref/0`) to a native rust struct in order
  to compute the results.

  ## Modules

  - `Noisex.Noise` is the core of the library. It contains the necessary functions
  to create different types of noises, get noise values at given 2D and 3D points
  and build or chunk noise maps.

  - `Noisex.Options` contains the available options that one can pass to the noise generator.

  - `Noisex.Utils` contains utility functions such as writing a noise map to a
  file or showing a representation of it on the standard output.
  """
end
