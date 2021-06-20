seed = :rand.uniform(234_324)
filename = "example_noise.png"

opts = %Isotope.Options{
  seed: seed,
  noise_type: :simplex_fractal,
  fractal_options: %Isotope.Options.Fractal{
    octaves: 4
  }
}

{:ok, noise} = Isotope.Noise.new(opts)

noise
|> Isotope.Noise.noise_map({1000, 1000})
|> Isotope.Utils.write_to_file(filename)

IO.puts "File written to #{filename}"
