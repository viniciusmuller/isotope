defmodule Isotope.Noise do
  @moduledoc """
  Provide functions to create and work with different types of noises.
  """

  @noise_types [
    :perlin,
    :perlin_fractal,
    :simplex,
    :simplex_fractal,
    :value,
    :value_fractal,
    :cubic,
    :cubic_fractal,
    :cellular,
    :white
  ]

  alias Isotope.NIF
  alias Isotope.Options

  @typedoc """
  A reference to the noise generator. This is
  needed for most of the library functions.
  """
  @type noise_ref() :: reference()

  @typedoc """
  A noise map, represented by a list
  containing lists of floats (the noise values).
  """
  @type noisemap() :: [[float()]]

  @typedoc """
  A coordinate `{x, y}` in a cartesian plane.
  """
  @type coord() :: {integer(), integer()}

  @typedoc """
  2-element tuple containg x and y values as floats.
  """
  @type point2d() :: {float(), float()}

  @typedoc """
  3-element tuple containg x, y and z values as floats.
  """
  @type point3d() :: {float(), float(), float()}

  @typedoc """
  A tuple containing width and height
  """
  @type size() :: {non_neg_integer(), non_neg_integer()}

  @typedoc """
  Options available when initializing the noise.
  """
  @type options() :: Options.t()

  @doc """
  Returns a new noise reference using the default options.

      iex> {:ok, _ref} = Isotope.Noise.new()
  """
  @spec new(options()) :: {:ok, noise_ref()} | {:error, :unsupported_noise}
  def new(), do: NIF.new(%Options{})

  @doc """
  Returns a new noise reference using the provided `options`.

      iex> {:ok, _ref} = Isotope.Noise.new(%Isotope.Options{seed: 100})

      iex> {:error, :unsupported_noise} = Isotope.Noise.new(%Isotope.Options{noise_type: :foobar})
  """
  def new(options) when options.noise_type not in @noise_types,
    do: {:error, :unsupported_noise}

  def new(options), do: NIF.new(options)

  @doc """
  Returns a 2D noise map from `start_point` to `end_point`

      iex> {:ok, noise} = Isotope.Noise.new(%Isotope.Options{seed: 100})
      iex> Isotope.Noise.chunk(noise, {0, 0}, {100, 100})
  """
  @spec chunk(noise_ref(), coord(), coord()) :: noisemap()
  def chunk(noise, start_point, end_point)

  def chunk(noise, {start_x, start_y}, {end_x, end_y}),
    do: NIF.chunk(noise, start_x, start_y, end_x, end_y)

  @doc """
  Returns the 2D or 3D noise value depending on `axes`.
  If `axes` is a 2-float tuple, it will return the 2D noise value for the point.
  If `axes` is a 3-float tuple, it will return the 3D noise value for the point.

      iex> {:ok, noise} = Isotope.Noise.new()
      iex> Isotope.Noise.get_noise(noise, {10.0, 10.0})
      -0.6350845098495483

      iex> {:ok, noise} = Isotope.Noise.new()
      iex> Isotope.Noise.get_noise(noise, {10.0, 10.0, 10.0})
      -0.1322503685951233
  """
  @spec get_noise(noise_ref(), point2d() | point3d()) :: float()
  def get_noise(noise, axes)
  def get_noise(noise, {x, y}), do: NIF.get_noise(noise, x, y)
  def get_noise(noise, {x, y, z}), do: NIF.get_noise3d(noise, x, y, z)

  @doc """
  Generates a 2D noise map of `size` and returns it.

      iex> {:ok, noise} = Isotope.Noise.new()
      iex> Isotope.Noise.noise_map(noise, {20, 20})
  """
  @spec noise_map(reference(), size()) :: noisemap()
  def noise_map(noise, size)
  def noise_map(noise, {w, h}), do: NIF.noise_map(noise, w, h)
end
