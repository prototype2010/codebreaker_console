class RestartRequiredError < StandardError
  def message
    'Restart requested by user'
  end
end
