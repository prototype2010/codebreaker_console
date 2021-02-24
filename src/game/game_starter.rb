class GameStarter
  def initialize(registration_class, mediator_class)
    @registration_class = registration_class
    @mediator_class = mediator_class
  end

  def start
    game_process = @registration_class.new.start

    @mediator_class.new(game_process).start
  rescue RestartRequiredError
    start
  end
end
