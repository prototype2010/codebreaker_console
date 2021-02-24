module PrintUtils
  def variant_printer(values)
    "( #{values.join(' / ')} )"
  end

  def ask_save_message
    "Would you like to save the game? #{variant_printer([Constants::YES, Constants::NO])} : "
  end

  def ask_restart_message
    "Would you like to play once more ? #{variant_printer([Constants::YES, Constants::NO])} : "
  end

  def ask_difficulty_message
    "Choose difficulty #{variant_printer(Codebreaker::Constants::GAME_DIFFICULTY_CONFIG.keys)} : "
  end

  def print_routes_message
    "There are available routes #{variant_printer(ROUTES.map { |route| route[:command] })}
    Your choice: "
  end
end
