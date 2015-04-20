class Player
  def play_turn(warrior)
    @warrior = warrior

    @action ||= Actions::RescueCaptive.new

    next_action = @action.act(warrior)

    @action = next_action
  end

  def walk(direction)
    @warrior.walk!(direction)
  end
end

module Actions
  class Base
    def act(warrior)
      raise Actions::ActNotImplementedError.new("Actions must have an act method!")
    end
  end

  class RescueCaptive < Actions::Base
    def act(warrior)
      warrior.rescue!(:right)
      Actions::FightToStairs.new
    end
  end

  class FightToStairs < Actions::Base
    def act(warrior)
      @warrior = warrior

      if @warrior.health <= 9
        action = FleeAndHeal.new
        action.act(@warrior)
        return action
      end

      direction_of_stairs = @warrior.direction_of_stairs
      space = @warrior.feel(direction_of_stairs)

      case space.to_s
      when 'Sludge', 'Thick Sludge'
        monster = Monster.from_space(space)
        attack(monster, direction_of_stairs)
      else
        @warrior.walk!(direction_of_stairs)
      end

      self
    end

    def attack(monster, direction)
      @warrior.attack!(direction)
    end
  end

  class FleeAndHeal < Actions::Base
    def act(warrior)
      @warrior = warrior
      @health ||= @warrior.health
      @fled ||= false

      if !@fled
        flee
      else
        if fully_healed?
          action = FightToStairs.new
          return action.act(@warrior)
        else
          heal
        end
      end

      @health = @warrior.health
      self
    end

    def in_danger?
      @warrior.health > @health
    end

    def flee
      @warrior.walk!(:right)
      @fled = true
    end

    def fully_healed?
      @warrior.health == 20
    end

    def heal
      @warrior.rest!
    end
  end
end

module Monster
  def self.from_space(space)
    space_name = space.to_s.delete(' ')
    "Monster::#{space_name}".split('::').reduce(Module, :const_get).new
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