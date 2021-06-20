seed = :rand.uniform(234_324)

opts = %Isotope.Options{seed: seed}

{:ok, noise} = Isotope.Noise.new(opts)

noisemap = Isotope.Noise.noise_map(noise, {40, 100})

Isotope.Utils.show_noisemap(noisemap)
