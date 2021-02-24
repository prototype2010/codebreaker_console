require_relative '../initializer'

module ScoreManager
  class << self
    HEADER = ['Rating', 'Name', 'Difficulty', 'Attempts Total', 'Attempts Used', 'Hints Total', 'Hints Used'].freeze

    def add_score(score_row)
      prepared_row = prepare_row(score_row)
      FileUtils.write(Constants::SCORE_FILE_PATH, score.push(prepared_row))
    end

    def print
      puts Terminal::Table.new rows: score
        .map { |result| GameResult.new(result) }
        .sort
        .map(&:to_table_row)
        .unshift(HEADER)
    end

    def score
      if File.exist?(Constants::SCORE_FILE_PATH)
        FileUtils.read(Constants::SCORE_FILE_PATH)
      else
        []
      end
    end

    def prepare_row(win_result)
      attempts_info = win_result[:attempts_info]

      {
        game_number: next_game_number,
        player_name: win_result[:player_name],
        difficulty: win_result[:difficulty],
        attempts_total: attempts_info[:attempts_total],
        attempts_used: attempts_info[:attempts_total] - attempts_info[:attempts_left],
        hints_total: attempts_info[:hints_total],
        hints_used: attempts_info[:hints_total] - attempts_info[:hints].length
      }
    end

    def next_game_number
      last_game_number = score
                         .map { |row| row[:game_number] }
                         .max

      last_game_number.nil? ? 1 : (last_game_number + 1)
    end
  end
end
