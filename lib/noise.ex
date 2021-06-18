defmodule Noisex.Noise do
  @moduledoc """
  Provide functions to work with different types of noises.

  This library provides Elixir bindings to the rust's [bracket-noise](https://crates.io/crates/bracket-noise)
  library, which is a rust port of [FastNoise](https://github.com/Auburn/FastNoiseLite).
  """

  alias Noisex.NIF

  defmodule Options do
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
            noise_type: Noisex.Noise.noise(),
            fractal_type: Noisex.Noise.fractal(),
            gain: float(),
            octaves: integer(),
            lacunarity: float(),
            frequency: float()
          }
  end

  @typedoc """
  A reference to the noise generator. This is
  needed for most of the library functions.
  """
  @type noise_ref :: reference()

  @typedoc """
  A noisemap object, represented by a list
  containing lists of floats (the noise values).
  """
  @type noisemap :: [[float()]]

  @typedoc """
  A coordinate {x, y} in a cartesian plane.
  """
  @type coord :: {integer(), integer()}

  @typedoc """
  A tuple containing width and height
  """
  @type size :: {non_neg_integer(), non_neg_integer()}

  @typedoc """
  Noise types available.
  > `:simplex` and `:simplex_fractal` are actually OpenSimplex.
  """
  @type noise ::
          :perlin
          | :simplex
          | :white
          | :cubic
          | :value
          | :cellular
          | :simplex_fractal
          | :perin_fractal
          | :cubic_fractal
          | :value_fractal

  @typedoc """
  Fractal types available.
  """
  @type fractal :: :fbm | :rigid_multi | :billow

  @typedoc """
  Options available when initializing the noise.
  """
  @type options :: Options.t()

  @doc """
  Returns a new noise object.
  Use default noise options if options are not provided.
  """
  @spec new(options()) :: {atom, noise_ref()}
  def new(), do: %Noisex.Noise.Options{} |> Map.from_struct() |> NIF.new()

  def new(options),
    do: options |> Map.from_struct() |> NIF.new()

  @doc """
  Returns a 2D noise map from `start_point` to `end_point`
  """
  @spec chunk(noise_ref(), coord(), coord()) :: noisemap()
  def chunk(noise, start_point, end_point)

  def chunk(noise, {start_x, start_y}, {end_x, end_y}),
    do: NIF.chunk(noise, start_x, start_y, end_x, end_y)

  @doc """
  Returns the noise value for two given floats `f1` and `f2`.
  """
  @spec get_noise(noise_ref(), float(), float()) :: float()
  def get_noise(noise, f1, f2), do: NIF.get_noise(noise, f1, f2)

  @doc """
  Generates a 2D noise map of `size` and returns it.
  """
  @spec noise_map(reference(), size()) :: noisemap()
  def noise_map(noise, size)
  def noise_map(noise, {w, h}), do: NIF.noise_map(noise, w, h)
end
