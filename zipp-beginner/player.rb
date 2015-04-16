class Player

  def rescue_captive
    if @warrior.feel(:backward).captive?
      @warrior.rescue!(:backward)
      @state = :kill_them_all
    else
      @warrior.walk!(:backward)
    end
  end

  def clear_room
    if @warrior.feel.empty?
      if @warrior.health < 10
        @state = :flee_and_heal
      else
        @warrior.walk!
      end
    else
      @warrior.attack!
    end

    @health = @warrior.health
  end

  def flee_and_heal
    if @warrior.health == 20
      @state = :kill_them_all
    end

    if @warrior.health < @health
      @warrior.walk!(:backward)
    else
      @warrior.rest!
    end
  end

  def play_turn(warrior)
    @warrior = warrior
    @health ||= @warrior.health
    @state ||= :rescue_captive

    case @state
    when :rescue_captive
      rescue_captive
    when :kill_them_all
      clear_room
    when :flee_and_heal
      flee_and_heal
    end

    @health = @warrior.health
  end
end
