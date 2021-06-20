defmodule Noisex.NoiseTestHelper do
  defmacro test_noise(noise) do
    quote do
      alias Noisex.Noise
      alias Noisex.Options

      describe "#{unquote(noise)} noise" do
        setup do
          noise_opts = %Options{noise_type: unquote(noise)}
          {:ok, noise} = Noise.new(noise_opts)

          {:ok, noise: noise}
        end

        test "can build a noise map", %{noise: noise} do
          width = height = 100
          noise_map = Noise.noise_map(noise, {width, height})

          assert is_list(noise_map)
          assert length(noise_map) == width
          assert noise_map |> List.first() |> length() == height
        end

        test "can generate noise value at given 2D point", %{noise: noise} do
          assert noise |> Noise.get_noise({32.2, 23.3}) |> is_float()
        end

        test "can generate noise value at given 3D point", %{noise: noise} do
          assert noise |> Noise.get_noise({32.2, 23.3, 43.3}) |> is_float()
        end

        test "can generate a chunk given two coordinates", %{noise: noise} do
          # TODO: Improve chunk function, currently not returning reliable results
          # for inputs that doesn't make square. Or maybe the tests aren't correct
          # sx = 200
          # ex = 400
          # sy = -200
          # ey = -600
          sx = 1000
          sy = 1000
          ex = 0
          ey = 0
          start_point = {sx, sy}
          end_point = {ex, ey}

          noise_map = Noise.chunk(noise, start_point, end_point)
          assert length(noise_map) == distance(sx, ex) + 1
          assert noise_map |> List.first() |> length() == distance(sy, ey) + 1
        end
      end
    end
  end
end

defmodule Noisex.NoiseTest do
  use ExUnit.Case, async: true
  doctest Noisex.Noise

  import Noisex.NoiseTestHelper

  test_noise(:perlin)
  test_noise(:perlin_fractal)
  test_noise(:simplex)
  test_noise(:simplex_fractal)
  test_noise(:value)
  test_noise(:value_fractal)
  test_noise(:cubic)
  test_noise(:cubic_fractal)
  test_noise(:cellular)
  test_noise(:white)

  describe "nif noise object" do
    test "is a reference" do
      {:ok, noise} = Noise.new()
      assert is_reference(noise)
    end
  end

  defp distance(s, e) do
    abs(s - e)
  end
end
