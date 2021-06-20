defmodule Isotope.Options.Cellular do
  @moduledoc """
  Options available for cellular noises.
  """

  @type distance_function() :: :euclidean | :manhattan | :natural

  @type return_type() ::
          :cell_value
          | :distance
          | :distance2
          | :distance2add
          | :distance2sub
          | :distance2mul
          | :distance2div

  @type t() :: %__MODULE__{
          distance_function: distance_function(),
          return_type: return_type(),
          distance_indices: {integer(), integer()},
          jitter: float()
        }

  defstruct distance_function: :euclidean,
            return_type: :cell_value,
            distance_indices: {0, 1},
            jitter: 0.45
end
