defmodule BehaviourExample.Bird do
  alias BehaviourExample.Animal
  
  @behaviour Animal

  def make_sound, do: "chirp"
  def number_of_legs, do: 2
end
