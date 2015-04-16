class Player
  def play_turn(warrior)
    @health ||= warrior.health

    if warrior.feel.empty?
      if warrior.health == 20
        warrior.walk!
      elsif warrior.health < @health
        warrior.walk!
      else
        warrior.rest!
      end
    else
      if warrior.feel.captive?
        warrior.rescue!
      else
        warrior.attack!
      end
    end

    @health = warrior.health
  end
end
