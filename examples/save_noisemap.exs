seed = :rand.uniform(234_324)
filename = "example_noise.png"

opts = %Noisex.Options{
  seed: seed,
  noise_type: :simplex_fractal,
  fractal_options: %Noisex.Options.Fractal{
    octaves: 4
  }
}

{:ok, noise} = Noisex.Noise.new(opts)

noise
|> Noisex.Noise.noise_map({1000, 1000})
|> Noisex.Utils.write_to_file(filename)

IO.puts "File written to #{filename}"
