import Noisex.Noise
import Noisex.Utils

n1 = %{
  seed:  3459,
  noise_type: :cubic_fractal,
  octaves: 6,
  frequency: 0.8
}

n2 = %{
  seed: 3459,
  noise_type: :cubic_fractal,
  octaves: 7,
  frequency: 0.8
}

# defmodule Foo do
#   def show(noise, path) do
#     {:ok, _}= noise |> noise_map(1000,1000) |> write_to_file(path)
#     spawn(fn -> System.cmd("sxiv", [path]) end)
#   end
# end

{:ok, n1} = new(n1)
# Foo.show(n1, "map.png")
{:ok, _} = n1 |> chunk({0, 0}, {1000, -1000})  |> write_to_file("chunk.png")
{:ok, _} = n1 |> chunk({1000, 0}, { 2000, -1000 })  |> write_to_file("chunk2.png")
spawn(fn -> System.cmd("sxiv", ["chunk.png"]) end)
spawn(fn -> System.cmd("sxiv", ["chunk2.png"]) end)
