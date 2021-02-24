class InterruptGameError < StandardError
  def message
    'Interrupted by user'
  end
end
