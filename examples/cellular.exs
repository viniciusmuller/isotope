seed = :rand.uniform(234_324)

opts = %Noisex.Options{
  seed: seed,
  noise_type: :celullar,
  cellular_options: %Noisex.Options.Cellular{distance_function: :euclidean}
}

{:ok, noise} = Noisex.Noise.new(opts)

noisemap = Noisex.Noise.noise_map(noise, {40, 100})

Noisex.Utils.show_noisemap(noisemap)
