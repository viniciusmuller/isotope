defmodule Noisex.Utils do
  @moduledoc """
  Utilitary functions for working with noise maps.
  """

  alias Noisex.NIF

  @doc """
  Writes the given noise map to a file.
  """
  @spec write_to_file(Noise.noisemap(), String.t()) :: :ok | {:error, term()}
  def write_to_file(noisemap, filename) do
    NIF.write_to_file(noisemap, filename)
  end

  @doc """
  Shows the given noise map on the stdout as a 2D terrain.
  """
  @spec show_noisemap(Noise.noisemap()) :: nil
  def show_noisemap(noisemap) do
    Enum.each(noisemap, fn y ->
      Enum.each(y, &IO.write(show(&1) <> IO.ANSI.reset()))
      IO.puts("")
    end)
  end

  @spec show(float()) :: String.t()
  defp show(n) when n < 0.15 and n > 0.1, do: IO.ANSI.yellow() <> "."
  defp show(n) when n < 0.1 and n > 0, do: IO.ANSI.green() <> "o"
  defp show(n) when n < 0, do: IO.ANSI.light_green() <> "O"
  defp show(_n), do: IO.ANSI.blue() <> "~"
end
