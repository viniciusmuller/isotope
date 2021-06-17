defmodule Noisex.Noise do
  @moduledoc """

  """

  alias Noisex.NIF

  @default_noise %{
    seed: 19,
    noise_type: :simplex_fractal,
    fractal_type: :fbm,
    frequency: 3.0,
    gain: 0.6,
    octaves: 6,
    lacunarity: 2.0
  }

  @typedoc """

  """
  @type noise_ref :: reference()

  @typedoc """

  """
  @type noisemap :: [[float()]]

  @typedoc """

  """
  @type coord :: {integer(), integer()}

  @typedoc """

  """
  @type size :: {non_neg_integer(), non_neg_integer()}

  @typedoc """

  """
  @type noise ::
          :perlin
          | :perin_fractal
          | :simplex
          | :simplex_fractal
          | :white
          | :cubic
          | :cubic_fractal
          | :value
          | :value_fractal
          | :cellular

  @typedoc """

  """
  @type fractal :: :fbm | :rigid_multi | :billow

  @typedoc """

  """
  @type options :: %{
          noise_type: noise(),
          fractal_type: fractal(),
          octaves: integer(),
          lacunarity: float(),
          frequency: float(),
          seed: non_neg_integer()
        }

  @doc """

  """
  @spec new(options()) :: {atom, noise_ref()}
  def new(), do: NIF.new(@default_noise)

  def new(options),
    do: @default_noise |> Map.merge(options) |> NIF.new()

  @doc """

  """
  @spec chunk(noise_ref(), coord(), coord()) :: noisemap()
  def chunk(noise, start_point, end_point)

  def chunk(noise, {start_x, start_y}, {end_x, end_y}),
    do: NIF.chunk(noise, start_x, start_y, end_x, end_y)

  @doc """

  """
  @spec get_noise(noise_ref(), float(), float()) :: float()
  def get_noise(noise, f1, f2), do: NIF.get_noise(noise, f1, f2)

  @doc """

  """
  @spec noise_map(reference(), size()) :: noisemap()
  def noise_map(noise, size)
  def noise_map(noise, {w, h}), do: NIF.noise_map(noise, w, h)
end
