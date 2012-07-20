# encoding: utf-8
require 'decorator_helper'
require 'app/decorators/contract_decorator'

describe ContractDecorator do
  context '#all_pledges_total_value' do
    before do
      component.stub(:all_pledges_total_value => 100.0)
    end

    it 'should applies currency' do
      subject.all_pledges_total_value.should eq 'R$ 100,00'
    end
  end
end
