class Player
  def play_turn(warrior)
    @warrior = warrior

    walk_towards_stairs
  end

  def walk_towards_stairs
    @warrior.walk!(@warrior.direction_of_stairs)
  end
end
