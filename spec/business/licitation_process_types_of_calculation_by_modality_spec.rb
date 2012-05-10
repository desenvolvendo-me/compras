require 'unit_helper'
require 'enumerate_it'
require 'app/business/licitation_process_types_of_calculation_by_modality'
require 'app/enumerations/licitation_process_type_of_calculation'
require 'app/enumerations/administrative_process_modality'

describe LicitationProcessTypesOfCalculationByModality do
  it 'should verify the content of types_of_calculations by judgment_kind' do
    subject.types_of_calculation_groups[AdministrativeProcessModality::PRESENCE_TRADING].should
      eq [ LicitationProcessTypeOfCalculation::SORT_PARTICIPANTS_BY_ITEM, LicitationProcessTypeOfCalculation::SORT_PARTICIPANTS_BY_LOT]
  end

  it 'should verify if type_of_calculation is included in group' do
    subject.correct_type_of_calculation?(AdministrativeProcessModality::PRESENCE_TRADING,
                                         LicitationProcessTypeOfCalculation::SORT_PARTICIPANTS_BY_ITEM).should be_true
    subject.correct_type_of_calculation?(AdministrativeProcessModality::PRESENCE_TRADING,
                                         LicitationProcessTypeOfCalculation::SORT_PARTICIPANTS_BY_LOT).should be_true

    subject.correct_type_of_calculation?(AdministrativeProcessModality::AUCTION,
                                         LicitationProcessTypeOfCalculation::SORT_PARTICIPANTS_BY_ITEM).should be_false
    subject.correct_type_of_calculation?(AdministrativeProcessModality::AUCTION,
                                         LicitationProcessTypeOfCalculation::SORT_PARTICIPANTS_BY_LOT).should be_false
  end
end
