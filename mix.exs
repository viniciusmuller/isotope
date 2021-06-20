defmodule Isotope.MixProject do
  use Mix.Project

  @source_url "https://github.com/Phiriq/isotope"
  @version "0.1.2-rc"

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

      # Docs
      name: "Isotope",
      main: "Isotope",
      source_url: @source_url,

      # Coverage
      test_coverage: [tool: ExCoveralls],
      preferred_cli_env: [
        coveralls: :test,
        "coveralls.detail": :test,
        "coveralls.post": :test,
        "coveralls.html": :test
      ]
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
      exclude_patterns: ["priv/native", "priv/plts", "native/noise/target"],
      files: [
        "lib",
        "native",
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
      {:dialyxir, "~> 1.0", only: [:dev], runtime: false},
      {:credo, "~> 1.5", only: [:dev, :test], runtime: false},
      {:ex_doc, "~> 0.24", only: :dev, runtime: false},
      {:benchee, "~> 1.0.1", only: :dev},
      {:excoveralls, "~> 0.10", only: :test},
      # Other dependencies
      {:rustler, "~> 0.22.0-rc.1"}
    ]
  end
end
