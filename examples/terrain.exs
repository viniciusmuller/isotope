seed = :rand.uniform(234_324)

opts = %Isotope.Options{
  seed: seed,
  noise_type: :simplex_fractal,
  frequency: 3.0,
  fractal_options: %Isotope.Options.Fractal{octaves: 4}
}

{:ok, noise} = Isotope.Noise.new(opts)

noisemap = Isotope.Noise.noise_map(noise, {40, 100})

defmodule Helper do
  @mountains_offset 0.4
  @light_grass_offset 0.1
  @grass_offset -0.1
  @sand_offset -0.2

  @spec show(float()) :: String.t()
  def show(n) when n > @mountains_offset, do: IO.ANSI.color(2,2,2) <> "M"
  def show(n) when n > @light_grass_offset, do: IO.ANSI.green() <> "o"
  def show(n) when n > @grass_offset, do: IO.ANSI.light_green() <> "O"
  def show(n) when n > @sand_offset, do: IO.ANSI.yellow() <> "."
  def show(_n), do: IO.ANSI.blue() <> "~"
end

Enum.each(noisemap, fn x ->
  Enum.each(x, fn y ->
    y |> Helper.show() |> IO.write()
  end)

  IO.puts("")
end)
