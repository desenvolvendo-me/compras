# encoding: utf-8
require 'decorator_helper'
require 'app/decorators/contract_decorator'

describe ContractDecorator do
  context '#all_pledges_total_value' do
    context 'when do not have all_pledges_total_value' do
      before do
        component.stub(:all_pledges_total_value).and_return(nil)
      end

      it 'should be nil' do
        expect(subject.all_pledges_total_value).to be_nil
      end
    end

    context 'when have all_pledges_total_value' do
      before do
        component.stub(:all_pledges_total_value).and_return(100.0)
      end

      it 'should applies currency' do
        expect(subject.all_pledges_total_value).to eq 'R$ 100,00'
      end
    end
  end
end
