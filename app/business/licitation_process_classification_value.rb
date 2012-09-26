class LicitationProcessClassificationValue
  include Comparable

  attr_accessor :classification, :tolerance, :classify_by_lowest_value

  def initialize(classification, tolerance = 10, classify_by_lowest_value = false)
    self.classification = classification
    self.tolerance = tolerance
    self.classify_by_lowest_value = classify_by_lowest_value
  end

  def <=>(other)
    if classify_by_lowest_value
      total_value <=> other.total_value
    else
      if benefited?
        if total_value < other.total_value
          -1
        elsif value_percentage(other) <= tolerance
          0
        else
          1
        end
      else
        if total_value > other.total_value
          1
        elsif other_value_percentage(other) <= tolerance
          0
        else
          -1
        end
      end
    end
  end

  def total_value
    classification.total_value
  end

  def benefited?
    classification.benefited
  end

  private

  def value_percentage(other)
    (((total_value / other.total_value) - 1) * 100).round(2)
  end

  def other_value_percentage(other)
    (((other.total_value / total_value) - 1) * 100).round(2)
  end
end
