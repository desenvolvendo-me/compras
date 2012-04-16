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
        :revenue_rubric_full_code => '1.1.1.3',
        :classification => '1111'
      )
    end

    it 'should generate full_code' do
      revenue_nature_object.should_receive(:full_code=).with('1.1.1.3.1111')
      subject.generate!
    end
  end
end
