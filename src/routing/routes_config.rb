ROUTES = [
  {
    command: Constants::START,
    action: lambda do
      GameStarter.new(GameRegistration, GameMediator).start
    end
  },
  {
    command: Constants::RULES,
    action: lambda do
      puts Constants::GAME_RULES
    end
  },
  {
    command: Constants::STATS,
    action: lambda do
      ScoreManager.print
    end
  }
].freeze
