class Player
  def play_turn(warrior)
    @warrior = warrior

    @state = get_next_objective

    case @state
    when :clear_room
      clear_room
    when :flee_and_heal
      flee_and_heal
    end
  end

  def get_next_objective
    if @warrior.health <= 8 and @state != :flee_and_heal
      :flee_and_heal
    elsif @warrior.health < 15 and @state == :flee_and_heal
      :flee_and_heal
    else
      :clear_room
    end
  end

  def clear_room
    if @warrior.feel.empty?
      step_forward
    else
      attack_enemy
    end
  end

  def step_forward
    @warrior.walk!
  end

  def attack_enemy
    @warrior.attack!
  end

  def flee_and_heal
    if @warrior.feel.empty?
      heal
    else
      flee
    end
  end

  def heal
    @warrior.rest!
  end

  def flee
    @warrior.walk!(:backward)
  end
end