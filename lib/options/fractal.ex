defmodule Isotope.Options.Fractal do
  @moduledoc """
  Options available for fractal noises.
  """

  @typedoc """
  Fractal types available.
  """
  @type fractal() :: :fbm | :rigid_multi | :billow

  @type t() :: %__MODULE__{
          fractal_type: fractal(),
          lacunarity: float(),
          octaves: integer(),
          gain: float()
        }

  defstruct fractal_type: :fbm,
            lacunarity: 2.0,
            octaves: 3,
            gain: 0.5
end
