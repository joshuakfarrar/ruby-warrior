class Player
  def play_turn(warrior)
    @warrior = warrior

    direction_of_stairs = @warrior.direction_of_stairs

    space = warrior.feel(direction_of_stairs).to_s

    case space
    when 'Sludge', 'Thick Sludge'
      monster = Monster.from_name(space.delete(' '))
      attack(monster, direction_of_stairs)
    else
      walk(direction_of_stairs)
    end
  end

  def attack(monster, direction)
    @warrior.attack!(direction)
  end

  def walk(direction)
    @warrior.walk!(direction)
  end
end

module Monster
  def self.from_name(name)
    "Monster::#{name}".split('::').reduce(Module, :const_get).new
  end

  class Base
    @@HP = nil

    def HP
      @@HP
    end
  end

  class Sludge < Monster::Base
    @@HP = 12
  end

  class ThickSludge < Monster::Base
    @@HP = 24
  end
end