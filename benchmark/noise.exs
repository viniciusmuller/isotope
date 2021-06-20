defmodule Bench do
  alias Isotope.{Noise, Options}

  @supported_noises [
    :perlin,
    :perlin_fractal,
    :simplex,
    :simplex_fractal,
    :value,
    :value_fractal,
    :cubic,
    :cubic_fractal,
    :white,
    :cellular
  ]

  def go do
    @supported_noises
    |> Enum.map(&noise_case/1)
    |> Enum.reduce(&Map.merge/2)
    |> Benchee.run(
      inputs: %{
        "{1000, 1000}" => {1000, 1000},
        "{500, 500}" => {500, 500},
        "{250, 250}" => {250, 250},
        "{100, 100}" => {100, 100}
      }
    )
  end

  def noise_case(noise) do
    %{
      "#{noise} - generate noise map": fn input ->
        {:ok, n} = Noise.new(%Options{noise_type: noise})
        Noise.noise_map(n, input)
      end
    }
  end
end

Bench.go()
