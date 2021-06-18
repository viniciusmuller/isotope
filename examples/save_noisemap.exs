seed = :rand.uniform(234_324)

opts = %Noisex.Options{
  seed: seed,
  frequency: 2.0,
  noise_type: :perlin_fractal
}

{:ok, noise} = Noisex.Noise.new(opts)

noise
|> Noisex.Noise.noise_map({1000, 1000})
|> Noisex.Utils.write_to_file("my_noisemap.png")
