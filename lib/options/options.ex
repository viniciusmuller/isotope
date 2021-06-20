defmodule Isotope.Options do
  alias Isotope.Options

  @moduledoc """
  Options available when initializing the noise.
  """

  @typedoc """
  Available types of interpolation.
  """
  @type interpolation() :: :linear | :quintic | :hermite

  @typedoc """
  Noise types available.
  > `:simplex` and `:simplex_fractal` are actually OpenSimplex2.
  """
  @type noise() ::
          :perlin
          | :simplex
          | :white
          | :cubic
          | :value
          | :cellular
          | :simplex_fractal
          | :perlin_fractal
          | :cubic_fractal
          | :value_fractal

  @type t() :: %__MODULE__{
          noise_type: noise(),
          cellular_options: Options.Cellular.t(),
          fractal_options: Options.Fractal.t(),
          interpolation: interpolation(),
          frequency: float(),
          seed: non_neg_integer()
        }

  defstruct noise_type: :simplex,
            interpolation: :quintic,
            cellular_options: %Options.Cellular{},
            fractal_options: %Options.Fractal{},
            frequency: 1.0,
            seed: 1337
end
