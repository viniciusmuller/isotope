defmodule Noisex.Noise.Options do
  alias Noisex.Noise

  @moduledoc """
  Options available when initializing the noise.
  """

  defstruct seed: 1337,
            noise_type: :simplex,
            fractal_type: :fbm,
            gain: 0.6,
            octaves: 6,
            lacunarity: 2.0,
            frequency: 1.0

  @type t :: %__MODULE__{
          seed: integer(),
          noise_type: Noise.noise(),
          fractal_type: Noise.fractal(),
          gain: float(),
          octaves: integer(),
          lacunarity: float(),
          frequency: float()
        }
end
