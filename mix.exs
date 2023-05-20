defmodule Isotope.MixProject do
  use Mix.Project

  @source_url "https://github.com/viniciusmuller/isotope"
  @version "0.2.0"

  def project do
    [
      app: :isotope,
      version: @version,
      elixir: "~> 1.12",
      start_permanent: Mix.env() == :prod,
      rustler_crates: rustler_crates(),
      dialyzer: dialyzer(),
      deps: deps(),
      aliases: aliases(),

      # Hex
      description: "Work with different noise functions using Elixir",
      package: package(),

      test_coverage: [
        ignore_modules: [
          Isotope.Options.Cellular,
          Isotope.Options.Fractal,
          Isotope.NIF
        ]
      ],

      # Docs
      name: "Isotope",
      main: "Isotope",
      source_url: @source_url
    ]
  end

  defp aliases do
    [
      test: ["compile", "test"],
      lint: ["format", "credo", "dialyzer"]
    ]
  end

  defp package do
    [
      licenses: ["MIT"],
      links: %{"GitHub" => @source_url},
      exclude_patterns: [
        "priv/plts",
        "native/noise/target",
        "priv/native/libnoise.so"
      ],
      files: [
        "lib",
        "native",
        "priv/native",
        ".formatter.exs",
        "README.md",
        "LICENSE",
        "mix.exs"
      ]
    ]
  end

  defp dialyzer do
    [
      plt_core_path: "priv/plts",
      plt_file: {:no_warn, "priv/plts/dialyzer.plt"}
    ]
  end

  def application do
    [
      extra_applications: [:eex, :logger]
    ]
  end

  defp rustler_crates() do
    [
      noise: [
        path: "native/noise",
        mode: :release
      ]
    ]
  end

  defp deps do
    [
      # Development dependencies
      {:dialyxir, "~> 1.3", only: [:dev], runtime: false},
      {:credo, "~> 1.7", only: [:dev, :test], runtime: false},
      {:ex_doc, "~> 0.27", only: :dev, runtime: false},
      {:benchee, "~> 1.0", only: :dev},
      # Other dependencies
      {:rustler, "~> 0.28.0"}
    ]
  end
end
