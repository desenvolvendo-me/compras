class PurchaseProcessClassificator
  attr_accessor :classification_a, :classification_b, :tolerance

  def initialize(classification_a, classification_b, options = {})
    self.classification_a = classification_a
    self.classification_b = classification_b
    self.tolerance = options.fetch(:tolerance, 10)
  end

  # Public: Verify if classification_a and classification_b draw
  #
  # Returns True or False
  def draw?
    if classify_by_lowest_value?
      draw_by_total_value?
    else
      draw_by_total_value?
    end
  end

  # Public: Show the classification that won
  #
  # Describing the rule:
  #   If classify by the lowest value
  #     Then wins the lowest value
  #   Else (only one classification is benefited)
  #     If a draw by total value happens
  #       If the benefited doesn't submit a new proposal
  #         Then the winner is that who is not the benefited
  #       Else (the benefited will submit a new proposal = draw)
  #     Else (when is not a draw)
  #       Then wins the lowest value
  #
  # Returns nil when draw or the winner classification
  def winner
    if classify_by_lowest_value?
      unless draw_by_total_value?
        classification_with_lowest_total_price
      end
    else
      if draw_by_total_value?
        classification_not_benefited
      else
        classification_with_lowest_total_price
      end
    end
  end

  # Public: Show the classification that lost
  #
  # Is classification that does't won
  #
  # Returns nil when draw or the loser classification
  def loser
    other_classification winner
  end

  private

  def other_classification(classification)
    return if classification.nil?

    classification == classification_a ? classification_b : classification_a
  end

  def draw_by_total_value?
    classification_a_total_value == classification_b_total_value
  end

  def classify_by_lowest_value?
    classification_a.benefited == classification_b.benefited
  end

  def classification_benefited
    classification_a.benefited ? classification_a : classification_b
  end

  def classification_not_benefited
    classification_a.benefited ? classification_b : classification_a
  end

  def classification_with_lowest_total_price
    if classification_a_total_value < classification_b_total_value
      classification_a
    else
      classification_b
    end
  end

  def classification_a_total_value
    @classification_a_total_value ||= PurchaseProcessClassificationValue.new(classification_a, tolerance, classify_by_lowest_value?)
  end

  def classification_b_total_value
    @classification_b_total_value ||= PurchaseProcessClassificationValue.new(classification_b, tolerance, classify_by_lowest_value?)
  end
end
