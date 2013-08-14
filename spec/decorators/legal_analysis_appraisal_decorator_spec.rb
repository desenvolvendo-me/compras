require 'decorator_helper'
require 'app/decorators/legal_analysis_appraisal_decorator'

describe LegalAnalysisAppraisalDecorator   do
  describe 'attr_header' do
    it 'should have header' do
      expect(described_class.headers?).to be_true
    end

    it 'should have process_and_year' do
      expect(described_class.header_attributes).to include :process_and_year
    end

     it 'should have appraisal_type' do
      expect(described_class.header_attributes).to include :appraisal_type
    end

     it 'should have reference' do
      expect(described_class.header_attributes).to include :reference
    end

     it 'should have appraisal_type' do
      expect(described_class.header_attributes).to include :appraisal_expedition_date
    end
  end
end
