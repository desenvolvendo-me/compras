require 'unit_helper'
require 'enumerate_it'
require 'app/business/licitation_process_types_of_calculation_by_modality'
require 'app/enumerations/licitation_process_type_of_calculation'
require 'app/enumerations/modality'

describe LicitationProcessTypesOfCalculationByModality do
  it 'should verify the content of types_of_calculations by modality' do
    expect(subject.types_of_calculation_groups[Modality::TRADING]).to eq (
      [ LicitationProcessTypeOfCalculation::SORT_PARTICIPANTS_BY_ITEM, LicitationProcessTypeOfCalculation::SORT_PARTICIPANTS_BY_LOT]
    )
  end

  it 'should verify if type_of_calculation is included in group' do
    expect(subject.correct_type_of_calculation?(Modality::TRADING,
                                         LicitationProcessTypeOfCalculation::SORT_PARTICIPANTS_BY_ITEM)).to be_true
    expect(subject.correct_type_of_calculation?(Modality::TRADING,
                                         LicitationProcessTypeOfCalculation::SORT_PARTICIPANTS_BY_LOT)).to be_true

    expect(subject.correct_type_of_calculation?(Modality::AUCTION,
                                         LicitationProcessTypeOfCalculation::SORT_PARTICIPANTS_BY_ITEM)).to be_false
    expect(subject.correct_type_of_calculation?(Modality::AUCTION,
                                         LicitationProcessTypeOfCalculation::SORT_PARTICIPANTS_BY_LOT)).to be_false
  end
end
