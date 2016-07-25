defmodule BehaviourExample.Cat do
  alias BehaviourExample.Animal
  
  @behaviour Animal

  def make_sound, do: "meow"
  def number_of_legs, do: 4
end
