require 'unit_helper'
require 'enumerate_it'
require 'app/business/licitation_process_types_of_calculation_by_object_type'
require 'app/enumerations/licitation_process_type_of_calculation'
require 'app/enumerations/administrative_process_object_type'

describe LicitationProcessTypesOfCalculationByObjectType do
  it 'should verify the content of types_of_calculations by judgment_kind' do
    subject.types_of_calculation_groups[AdministrativeProcessObjectType::DISPOSALS_OF_ASSETS].should
      eq [ LicitationProcessTypeOfCalculation::HIGHEST_BIDDER_BY_ITEM, LicitationProcessTypeOfCalculation::HIGHEST_BIDDER_BY_LOT]
  end

  it 'should verify if type_of_calculation is included in group' do
    subject.correct_type_of_calculation?(AdministrativeProcessObjectType::DISPOSALS_OF_ASSETS,
                                         LicitationProcessTypeOfCalculation::HIGHEST_BIDDER_BY_ITEM).should be_true
    subject.correct_type_of_calculation?(AdministrativeProcessObjectType::DISPOSALS_OF_ASSETS,
                                         LicitationProcessTypeOfCalculation::HIGHEST_BIDDER_BY_LOT).should be_true

    subject.correct_type_of_calculation?(AdministrativeProcessObjectType::CALL_NOTICE,
                                         LicitationProcessTypeOfCalculation::HIGHEST_BIDDER_BY_ITEM).should be_false
    subject.correct_type_of_calculation?(AdministrativeProcessObjectType::CALL_NOTICE,
                                         LicitationProcessTypeOfCalculation::HIGHEST_BIDDER_BY_LOT).should be_false
  end
end
