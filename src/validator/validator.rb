module Validator
  def validate_binary_response(value)
    raise BinaryResponseExpected unless [Constants::YES, Constants::NO].include?(value)

    value
  end
end
