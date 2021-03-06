class GameMediator
  include PrintUtils
  include Codebreaker::Validation
  include InteractUtils
  include Validator

  def initialize(game)
    @game = game
  end

  def start
    start_guess_process
    proceed_result
    ask_restart
  end

  def ask_save
    interact(message: ask_save_message, exceptions: [BinaryResponseExpected]) do
      ScoreManager.add_score(@game.to_h) if proceed_user_input(:save) == Constants::YES
    end
  end

  def ask_restart
    interact(message: ask_restart_message, exceptions: [BinaryResponseExpected]) do
      raise RestartRequiredError if proceed_user_input(:restart) == Constants::YES
    end
  end

  def proceed_result
    if @game.win?
      puts "Congratulations! Correct code is: #{@secret_code}"
      ask_save
    else
      puts "You lose, dude! Correct code is: #{@secret_code}"
    end
  end

  def start_guess_process
    interact(exceptions: [Codebreaker::Exceptions::DigitsExpectedError,
                          Codebreaker::Exceptions::NoMoreHintsError,
                          Codebreaker::Exceptions::EmptyArrayError,
                          Codebreaker::Exceptions::UnableToCompareError,
                          Codebreaker::Exceptions::OutOfComparisonRangeError]) do
      until @game.win? || @game.lose?
        print "Please input you code, take `#{Constants::HINT}` or `#{Constants::EXIT}`: "
        proceed_user_input(:code)
      end
    end
  end

  def proceed_user_input(type)
    value = gets.chomp.strip
    raise InterruptGameError if value == Constants::EXIT

    case type
    when :code
      return puts(@game.hint) if value == Constants::HINT

      validate_user_code(value)
      puts @game.guess(split_to_digits_array(value))
    when :save, :restart
      validate_binary_response(value)
    else
      raise UnknownInputType, type
    end
  end
end
