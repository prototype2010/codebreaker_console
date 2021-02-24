class BinaryResponseExpected < StandardError
  def message
    'Expected `yes` or `no`'
  end
end
