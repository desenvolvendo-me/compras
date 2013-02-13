class LicitationProcessTypesOfCalculationByModality
  attr_accessor :type_of_calculation, :modality_enumeration

  def initialize(type_of_calculation = LicitationProcessTypeOfCalculation, modality = Modality)
    self.type_of_calculation = type_of_calculation
    self.modality_enumeration = modality
  end

  def types_of_calculation_groups
    {
      modality_enumeration::TRADING => [
        type_of_calculation::SORT_PARTICIPANTS_BY_ITEM,
        type_of_calculation::SORT_PARTICIPANTS_BY_LOT
      ],
      modality_enumeration::AUCTION => [
        type_of_calculation::LOWEST_GLOBAL_PRICE,
        type_of_calculation::LOWEST_PRICE_BY_LOT
      ]
    }
  end

  def correct_type_of_calculation?(modality, type_of_calculation)
    return true unless types_of_calculation_groups[modality_enumeration::TRADING].include?(type_of_calculation)

    modality == modality_enumeration::TRADING
  end
end
