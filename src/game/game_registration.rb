class GameRegistration
  include PrintUtils
  include Codebreaker::Validation
  include InteractUtils
  include Validator

  def start
    difficulty = ask_difficulty
    name = ask_name

    @secret_code = Codebreaker::CodeGenerator.generate_by_defaults
    puts "(TESTING PURPOSES) secret_code: #{@secret_code}"
    @game = Codebreaker::GameProcess.new({ difficulty: difficulty,
                                           player_name: name,
                                           secret_code: @secret_code })
  end

  def ask_difficulty
    interact(message: ask_difficulty_message,
             exceptions: [Codebreaker::Exceptions::WrongDifficultyError]) { proceed_user_input(:difficulty) }
  end

  def ask_name
    interact(message: 'Your name: ',
             exceptions: [Codebreaker::Exceptions::NameValidationError]) { proceed_user_input(:name) }
  end

  def proceed_user_input(type)
    value = gets.chomp.strip
    raise InterruptGameError if value == Constants::EXIT

    case type
    when :name
      validate_name(value)
    when :difficulty
      validate_difficulty(value.to_sym)
    else
      raise UnknownInputType, type
    end
  end
end
