class LicitationProcessTypesOfCalculationByJudgmentFormKind
  attr_accessor :type_of_calculation, :judgment_form_kind

  def initialize(type_of_calculation = LicitationProcessTypeOfCalculation, judgment_form_kind = JudgmentFormKind)
    self.type_of_calculation = type_of_calculation
    self.judgment_form_kind = judgment_form_kind
  end

  def types_of_calculation_groups
    {
      judgment_form_kind::ITEM => [
        type_of_calculation::LOWEST_TOTAL_PRICE_BY_ITEM,
        type_of_calculation::HIGHEST_BIDDER_BY_ITEM,
        type_of_calculation::SORT_PARTICIPANTS_BY_ITEM
      ],
      judgment_form_kind::PART => [
        type_of_calculation::LOWEST_PRICE_BY_LOT,
        type_of_calculation::HIGHEST_BIDDER_BY_LOT,
        type_of_calculation::SORT_PARTICIPANTS_BY_LOT
      ],
      judgment_form_kind::GLOBAL => [
        type_of_calculation::LOWEST_GLOBAL_PRICE
      ]
    }
  end

  def correct_type_of_calculation?(judgment_form_kind, type_of_calculation)
    types_of_calculation_groups[judgment_form_kind].include?(type_of_calculation)
  end
end
