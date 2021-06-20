defmodule Isotope.UtilsTest do
  use ExUnit.Case, async: true
  doctest Isotope.Utils

  import ExUnit.CaptureIO

  alias Isotope.Noise
  alias Isotope.Utils

  test "show_noisemap/1 outputs visualization to stdout" do
    {:ok, noise} = Noise.new()

    output =
      fn ->
        noise
        |> Noise.noise_map({10, 10})
        |> Utils.show_noisemap()
      end
      |> capture_io

    assert String.contains?(output, "▒")
    # output contains characters used in ansi codes
    assert String.contains?(output, "[")
    assert String.contains?(output, ";")
  end
end
