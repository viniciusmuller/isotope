defmodule Noisex.NIF do
  @moduledoc false
  # TODO: Tests #

  use Rustler, otp_app: :noisex, crate: "noise"
  alias Noisex.Noise

  @spec chunk(Noise.noise_ref(), integer(), integer(), integer(), integer()) ::
          Noise.noisemap()
  @doc false
  def chunk(_noise, _sx, _sy, _ex, _ey),
    do: error()

  @spec write_to_file(Noise.noisemap(), String.t()) :: :ok | {:error, term()}
  @doc false
  def write_to_file(_noisemap, _filename), do: error()

  @spec new(Noise.options()) :: {atom, Noise.noise_ref()}
  @doc false
  def new(_options), do: error()

  @spec get_noise(Noise.noise_ref(), float(), float()) :: float()
  @doc false
  def get_noise(_noise, _f1, _f2), do: error()

  @spec noise_map(Noise.noise_ref(), integer(), integer()) :: Noise.noisemap()
  @doc false
  def noise_map(_noise, _x, _y), do: error()

  defp error, do: :erlang.nif_error(:nif_not_loaded)
end
