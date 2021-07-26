require 'enumeration_helper'
require 'app/enumerations/type_of_removal'

describe TypeOfRemoval do
  describe '.allow_duplicated_items' do
    it {
      expect(described_class.allow_duplicated_items).to eq(
      [described_class::DISPENSATION_JUSTIFIED_ACCREDITATION,
       described_class::UNENFORCEABILITY_ACCREDITATION])
    }
  end
end
