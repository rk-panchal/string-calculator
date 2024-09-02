def add(numbers)
  return 0 if numbers.empty?

  delimiter = /,|\n/
  if numbers.start_with?("//")
    parts = numbers.split("\n", 2)
    delimiter = Regexp.escape(parts[0][2..])
    numbers = parts[1]
  end

  nums = numbers.split(/#{delimiter}/).map(&:strip).map(&:to_i)
  negatives = nums.select { |n| n < 0 }
  raise "negative numbers not allowed: #{negatives.join(', ')}" unless negatives.empty?

  nums.sum
end


require 'minitest/autorun'

class AddTest < Minitest::Test
  
  def test_empty_string
    assert_equal 0, add("")
  end

  def test_single_number
    assert_equal 1, add("1")
    assert_equal 2, add("2")
  end

  def test_negative_numbers
    exception = assert_raises(RuntimeError) { add("1,-2,3") }
    assert_equal "negative numbers not allowed: -2", exception.message

    exception = assert_raises(RuntimeError) { add("//;\n1;-2;3") }
    assert_equal "negative numbers not allowed: -2", exception.message
  end

  def test_custom_delimiter
    assert_equal 6, add("//;\n1;2;3")
    assert_equal 6, add("//;\n 1 ; 2 ; 3")
  end

  def test_multiple_numbers
    assert_equal 6, add("1,2,3")
    assert_equal 6, add("1\n2,3")
  end
end
