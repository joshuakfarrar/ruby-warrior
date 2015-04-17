class Player
  def play_turn(warrior)
    @warrior = warrior

    @state ||= :kill_them_all

    case @state
    when :kill_them_all
      clear_room
    when :flee_and_heal
      flee_and_heal
    end

    @health = @warrior.health
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
end