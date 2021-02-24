class GameResult
  attr_reader :difficulty_eval,
              :attempts_used,
              :hints_used

  DIFFICULTY_EVALUATION = {
    easy: 3,
    medium: 2,
    hell: 1
  }.freeze

  def initialize(result)
    @result = result
    @game_number = result[:game_number]
    @player_name = result[:player_name]
    @difficulty = result[:difficulty]
    @difficulty_eval = DIFFICULTY_EVALUATION[result.fetch(:difficulty)]
    @attempts_total = result[:attempts_total]
    @hints_total = result[:hints_total]
    @attempts_used = result[:attempts_used]
    @hints_used = result[:hints_used]
  end

  def <=>(other)
    raise Error("Not a #{GameResult.class}") unless other.is_a? GameResult

    [difficulty_eval, attempts_used, hints_used] <=> [other.difficulty_eval, other.attempts_used, other.hints_used]
  end

  def to_table_row
    [@game_number, @player_name, @difficulty, @attempts_total, @attempts_used, @hints_total, @hints_used]
  end
end
