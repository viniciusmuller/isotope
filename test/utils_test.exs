defmodule Noisex.UtilsTest do
  use ExUnit.Case, async: true
  doctest Noisex.Utils

  import ExUnit.CaptureIO

  test "show_noisemap/1 outputs visualization to stdout" do
    {:ok, noise} = Noisex.Noise.new()

    output =
      fn ->
        noise
        |> Noisex.Noise.noise_map({10, 10})
        |> Noisex.Utils.show_noisemap()
      end
      |> capture_io

    assert String.contains?(output, "▒")
    # output contains characters used in ansi codes
    assert String.contains?(output, "[")
    assert String.contains?(output, ";")
  end
end
