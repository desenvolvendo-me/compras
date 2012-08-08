require 'unit_helper'
require 'enumerate_it'
require 'app/business/licitation_process_types_of_calculation_by_judgment_form_kind'
require 'app/enumerations/licitation_process_type_of_calculation'
require 'app/enumerations/judgment_form_kind'

describe LicitationProcessTypesOfCalculationByJudgmentFormKind do
  it 'should verify the content of types_of_calculations by judgment_kind' do
    expect(subject.types_of_calculation_groups[JudgmentFormKind::ITEM]).to eq [ LicitationProcessTypeOfCalculation::LOWEST_TOTAL_PRICE_BY_ITEM,
                                                                            LicitationProcessTypeOfCalculation::HIGHEST_BIDDER_BY_ITEM,
                                                                            LicitationProcessTypeOfCalculation::SORT_PARTICIPANTS_BY_ITEM]


    expect(subject.types_of_calculation_groups[JudgmentFormKind::PART]).to eq [ LicitationProcessTypeOfCalculation::LOWEST_PRICE_BY_LOT,
                                                                            LicitationProcessTypeOfCalculation::HIGHEST_BIDDER_BY_LOT,
                                                                            LicitationProcessTypeOfCalculation::SORT_PARTICIPANTS_BY_LOT]

    expect(subject.types_of_calculation_groups[JudgmentFormKind::GLOBAL]).to eq [ LicitationProcessTypeOfCalculation::LOWEST_GLOBAL_PRICE]
  end

  it 'should verify if type_of_calculation is included in group' do
    expect(subject.correct_type_of_calculation?(JudgmentFormKind::ITEM, LicitationProcessTypeOfCalculation::LOWEST_TOTAL_PRICE_BY_ITEM)).to be_true
    expect(subject.correct_type_of_calculation?(JudgmentFormKind::PART, LicitationProcessTypeOfCalculation::LOWEST_TOTAL_PRICE_BY_ITEM)).to be_false
  end
end
