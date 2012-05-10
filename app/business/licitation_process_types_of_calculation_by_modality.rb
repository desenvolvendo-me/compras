class LicitationProcessTypesOfCalculationByModality
  attr_accessor :type_of_calculation, :modality

  def initialize(type_of_calculation = LicitationProcessTypeOfCalculation, modality = AdministrativeProcessModality)
    self.type_of_calculation = type_of_calculation
    self.modality = modality
  end

  def types_of_calculation_groups
    {
      modality::PRESENCE_TRADING => [
        type_of_calculation::SORT_PARTICIPANTS_BY_ITEM,
        type_of_calculation::SORT_PARTICIPANTS_BY_LOT
      ]
    }
  end

  def correct_type_of_calculation?(modality, type_of_calculation)
    return false unless types_of_calculation_groups[modality]

    types_of_calculation_groups[modality].include?(type_of_calculation)
  end

  def correct_type_of_calculation?(modality, type_of_calculation, modalities = AdministrativeProcessModality)
    return true unless types_of_calculation_groups[modalities::PRESENCE_TRADING].include?(type_of_calculation)

    modality == modalities::PRESENCE_TRADING
  end
end
