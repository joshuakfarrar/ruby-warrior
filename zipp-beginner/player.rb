class Player
  def play_turn(warrior)
    @warrior = warrior

    @state = get_next_objective

    case @state
    when :kill_them_all
      clear_room
    when :shoot_them_all
      shoot_enemy
    when :step_forward
      step_forward
    when :flee
      flee
    when :heal_up
      heal
    when :rescue_captive
      rescue_captive
    end

    @health = @warrior.health
  end

  def get_next_objective
    @warrior.look.each do |space|
      if space.to_s == 'Captive' 
        return :rescue_captive
        break
      elsif space.to_s == 'Wizard'
        return :shoot_them_all
        break
      elsif space.to_s == 'Thick Sludge'
        return :kill_them_all
        break
      elsif space.to_s == 'Archer'
        return :kill_them_all
        break
      end
    end

    if @warrior.health < 20
      return :heal_up
    else
      return :step_forward
    end
  end

  def step_forward
    if warrior_is_facing_a_wall
      turn_around
    else
      @warrior.walk!
    end
  end

  def clear_room
    if warrior_is_facing_a_wall
      turn_around
    else
      fight_forward
    end
  end

  def warrior_is_facing_a_wall
    @warrior.feel.wall?
  end

  def turn_around
    @warrior.pivot!(:backward)
  end

  def fight_forward
    if @warrior.feel.empty?
      @warrior.walk!
    else
      @warrior.attack!
    end

    if @warrior.health < 10
      @state = :flee_and_heal
    end
  end

  def shoot_enemy
    @warrior.shoot!
  end

  def flee
    if @warrior.health < @health
      @warrior.walk!(:backward)
    end
  end

  def heal
    @warrior.rest!

    if @warrior.health >= 20
      @state = :step_forward
    end
  end

  def rescue_captive
    if @warrior.feel.captive?
      @warrior.rescue!
    else
      @warrior.walk!
    end
  end
end