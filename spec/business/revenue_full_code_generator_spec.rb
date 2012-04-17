require 'unit_helper'
require 'active_support/core_ext/module/delegation'
require 'app/business/revenue_nature_full_code_generator'

describe RevenueNatureFullCodeGenerator do
  subject do
    described_class.new(revenue_nature_object)
  end

  context 'when have all codes' do
    let :revenue_nature_object do
      double(
        :revenue_category_code => '1',
        :revenue_subcategory_code => '2',
        :revenue_source_code => '3',
        :revenue_rubric_code => '4',
        :classification => '5678'
      )
    end

    it 'should generate full_code' do
      revenue_nature_object.should_receive(:full_code=).with('1.2.3.4.5678')
      subject.generate!
    end
  end
end
