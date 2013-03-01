class LicitationProcessTypesOfCalculationByObjectType
  attr_accessor :type_of_calculation, :object_type

  def initialize(type_of_calculation = LicitationProcessTypeOfCalculation, object_type = LicitationProcessObjectType)
    self.type_of_calculation = type_of_calculation
    self.object_type = object_type
  end

  def types_of_calculation_groups
    {
      object_type::DISPOSALS_OF_ASSETS => [
        type_of_calculation::HIGHEST_BIDDER_BY_ITEM,
        type_of_calculation::HIGHEST_BIDDER_BY_LOT
      ]
    }
  end

  def correct_type_of_calculation?(object_type, type_of_calculation, object_types = LicitationProcessObjectType)
    return true unless types_of_calculation_groups[object_types::DISPOSALS_OF_ASSETS].include?(type_of_calculation)

    object_type == object_types::DISPOSALS_OF_ASSETS
  end
end
