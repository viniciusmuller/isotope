defmodule Noisex.Utils do
  @moduledoc """

  """

  alias Noisex.NIF

  @doc """

  """
  @spec write_to_file(Noise.noisemap(), String.t()) :: :ok | {:error, term()}
  def write_to_file(noisemap, path) do
    NIF.write_to_file(noisemap, path)
  end
end
