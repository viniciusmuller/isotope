# Isotope

![CI Status](https://github.com/Phiriq/isotope/actions/workflows/ci.yml/badge.svg)
![Coverage Status](https://coveralls.io/repos/Phiriq/isotope/badge.svg?branch=master)

Isotope is a library that provides Elixir bindings to the [bracket-noise](https://crates.io/crates/bracket-noise) crate, which is a rust port of [FastNoise Lite](https://github.com/Auburn/FastNoiseLite).

## Installation

The package can be installed by adding `isotope` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [
    # Currently tested with Elixir 1.12.1 and Erlang 24.0
    {:isotope, "~> 0.1.2-rc"}
  ]
end
```
And running `mix deps.get, deps.compile`.

## Usage
Check the documentation [here](https://hexdocs.pm/noisex/0.1.3-rc/Noisex.html)

## Examples
You can check and run the examples in the `examples` folder.
```bash
mix run examples/<example>.exs
```

## Images
![Output of the terrain.exs example script](images/terrain.png)
![Output of the visualization.exs example script](images/visualization.png)

