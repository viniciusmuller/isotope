defmodule Noisex.MixProject do
  use Mix.Project

  def project do
    [
      app: :noisex,
      version: "0.1.0",
      elixir: "~> 1.12",
      start_permanent: Mix.env() == :prod,
      rustler_crates: rustler_crates(),
      deps: deps()
    ]
  end

  def application do
    [
      extra_applications: [:logger]
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
      {:benchee, "~> 1.0.1", only: :dev}
      {:rustler, "~> 0.22.0-rc.1"},
    ]
  end
end
