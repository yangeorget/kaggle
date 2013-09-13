require 'test/unit'
require 'tempfile'
require_relative 'datagenerator'

class DataGeneratorTest < Test::Unit::TestCase
  def test_emit
    file = Tempfile.new("foo")
    DataGenerator.emit(file, "key", 123)
    file.rewind
    assert_equal "key:123 ", file.read
    file.close
    file.unlink
  end
end
