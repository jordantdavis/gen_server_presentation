defmodule BehaviourExample.Animal do
  @callback make_sound :: String.t
  @callback number_of_legs :: integer
end
