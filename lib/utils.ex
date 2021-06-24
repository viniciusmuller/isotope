defmodule Isotope.Utils do
  @moduledoc """
  Utilitary functions for working with noise maps.
  """

  alias Isotope.Noise

  @doc """
  Writes the given noise map to a PNG file.

      iex> {:ok, noise} = Isotope.Noise.new()
      iex> {:ok, "/tmp/my_test_noise.png"} =
      ...>   noise
      ...>     |> Isotope.Noise.noise_map({200, 200})
      ...>     |> Isotope.Utils.write_to_file("/tmp/my_test_noise.png")
  """
  @spec write_to_file(Noise.noisemap(), String.t()) :: {:ok, String.t()}
  def write_to_file(noisemap, filename) do
    noisemap
    |> Enum.map(fn row -> Enum.map(row, &to_pixel/1) end)
    |> ExPng.Image.new()
    |> ExPng.Image.to_file(filename)
  end

  @spec to_pixel(float()) :: ExPng.Color.t()
  defp to_pixel(noise_value) do
    ((noise_value * 0.5 + 0.5) * 255)
    |> trunc()
    |> ExPng.Color.grayscale()
  end

  @doc """
  Shows the given noise map on the stdout using ANSI color codes.
  > This won't work if your terminal doesn't support ANSI color codes.

  ```elixir
  {:ok, noise} = Isotope.Noise.new()
  noise |> Isotope.Noise.noise_map({50, 50})
        |> Isotope.Utils.show_noisemap()
  # Outputs noise visualization
  :ok
  ```
  """
  @spec show_noisemap(Noise.noisemap()) :: :ok
  def show_noisemap(noisemap) do
    Enum.each(noisemap, fn y ->
      Enum.each(y, fn x ->
        color = (x * 255) |> floor() |> abs() |> rem(255)
        ansi_char = IO.ANSI.color(color) <> "▒"
        IO.write(ansi_char)
      end)

      IO.puts("")
    end)
  end
end
