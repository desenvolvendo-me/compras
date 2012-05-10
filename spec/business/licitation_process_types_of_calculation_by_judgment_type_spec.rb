require 'unit_helper'
require 'enumerate_it'
require 'app/business/licitation_process_types_of_calculation_by_judgment_form_kind'
require 'app/enumerations/licitation_process_type_of_calculation'
require 'app/enumerations/judgment_form_kind'

describe LicitationProcessTypesOfCalculationByJudgmentFormKind do
  it 'should verify the content of types_of_calculations by judgment_kind' do
    subject.types_of_calculation_groups[JudgmentFormKind::ITEM].should eq [ LicitationProcessTypeOfCalculation::LOWEST_TOTAL_PRICE_BY_ITEM,
                                                                            LicitationProcessTypeOfCalculation::HIGHEST_BIDDER_BY_ITEM,
                                                                            LicitationProcessTypeOfCalculation::SORT_PARTICIPANTS_BY_ITEM]


    subject.types_of_calculation_groups[JudgmentFormKind::PART].should eq [ LicitationProcessTypeOfCalculation::LOWEST_PRICE_BY_LOT,
                                                                            LicitationProcessTypeOfCalculation::HIGHEST_BIDDER_BY_LOT,
                                                                            LicitationProcessTypeOfCalculation::SORT_PARTICIPANTS_BY_LOT]

    subject.types_of_calculation_groups[JudgmentFormKind::GLOBAL].should eq [ LicitationProcessTypeOfCalculation::LOWEST_GLOBAL_PRICE]
  end

  it 'should verify if type_of_calculation is included in group' do
    subject.correct_type_of_calculation?(JudgmentFormKind::ITEM, LicitationProcessTypeOfCalculation::LOWEST_TOTAL_PRICE_BY_ITEM).should be_true
    subject.correct_type_of_calculation?(JudgmentFormKind::PART, LicitationProcessTypeOfCalculation::LOWEST_TOTAL_PRICE_BY_ITEM).should be_false
  end
end
