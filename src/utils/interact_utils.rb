module InteractUtils
  def interact(exceptions: [], message: '')
    print message unless message.empty?
    yield
  rescue StandardError => e
    raise e unless exceptions.include?(e.class)

    puts e.message
    retry
  end

  def split_to_digits_array(valid_value)
    valid_value.split('').map(&:to_i)
  end
end
