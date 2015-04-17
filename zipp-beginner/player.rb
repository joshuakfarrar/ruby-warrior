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
      @warrior.walk!
    when :flee_and_heal
      flee_and_heal
    when :rescue_captive
      rescue_captive
    end

    @health = @warrior.health
  end

  def get_next_objective
    @warrior.look.each_with_index do |space, i|
      if space.to_s == 'Captive' 
        return :rescue_captive
        break
      elsif space.to_s == 'Wizard'
        return :shoot_them_all
        break
      end
    end

    return :step_forward
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

  def flee_and_heal
    if @warrior.health < @health
      @warrior.walk!(:backward)
    else
      @warrior.rest!
    end

    if @warrior.health >= 20
      @state = :kill_them_all
    end
  end

  def rescue_captive
    if @warrior.feel.captive?
      @warrior.rescue!
      @state = :shoot_them_all
    else
      @warrior.walk!
    end
  end
end