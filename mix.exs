defmodule Noisex.MixProject do
  use Mix.Project

  @source_url "https://github.com/Phiriq/noisex"
  @version "0.1.1"

  def project do
    [
      app: :noisex,
      version: @version,
      elixir: "~> 1.12",
      start_permanent: Mix.env() == :prod,
      rustler_crates: rustler_crates(),
      dialyzer: dialyzer(),
      deps: deps(),

      # Hex
      description: "Work with different noise functions using Elixir",
      package: package(),

      # Docs
      name: "Noisex",
      source_url: @source_url
    ]
  end

  defp package do
    [
      licenses: ["MIT"],
      links: %{"GitHub" => @source_url},
      exclude_patterns: ["priv/native", "priv/plts"]
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
      {:dialyxir, "~> 1.0", only: [:dev], runtime: false},
      {:credo, "~> 1.5", only: [:dev, :test], runtime: false},
      {:ex_doc, "~> 0.24", only: :dev, runtime: false},
      {:benchee, "~> 1.0.1", only: :dev},
      # Other dependencies
      {:rustler, "~> 0.22.0-rc.1"}
    ]
  end
end
