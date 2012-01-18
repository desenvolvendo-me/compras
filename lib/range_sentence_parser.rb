class RangeSentenceParser
  attr_accessor :sentence

  def initialize(sentence)
    self.sentence = sentence
  end

  # Parse the string and return an array of numbers
  #
  # Usage:
  #
  #   RangeSentenceParser.new('1').parse!           # => [1]
  #   RangeSentenceParser.new('1-10').parse!        # => [1..10]
  #   RangeSentenceParser.new('1; 2; 20-30').parse! # => [1, 2, 20..30]
  def parse!
    raise ArgumentError unless valid?

    sentence.split(';').map do |number|
      if number =~ /(\d+)-(\d+)/
        Range.new($1.to_i, $2.to_i)
      else
        number.to_i
      end
    end
  end

  # Validate sentence format accepting values like:
  #
  #   RangeSentenceParser.new('').valid?            # => true
  #   RangeSentenceParser.new('1').valid?           # => true
  #   RangeSentenceParser.new('1-10').valid?        # => true
  #   RangeSentenceParser.new('1; 2; 20-30').valid? # => true
  #
  # Any other format will be invalid:
  #
  #   RangeSentenceParser.new(nil).valid?           # => false
  #   RangeSentenceParser.new('1..10').valid?       # => false
  #   RangeSentenceParser.new('1, 2, 20-30').valid? # => false
  def valid?
    return true if sentence.empty?

    sentence =~ /^\d+(-\d+)?( *; *\d+(-\d+)?)*;?$/
  end
end
