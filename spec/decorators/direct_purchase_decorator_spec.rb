# encoding: utf-8
require 'decorator_helper'
require 'app/decorators/direct_purchase_decorator'

describe DirectPurchaseDecorator do
  context '#total_allocations_item_value' do
    before do
      component.stub(:total_allocations_items_value).and_return(512.34)
      helpers.stub(:number_with_precision).with(512.34).and_return('512,34')
    end

    it 'should applies precision' do
      subject.total_allocations_items_value.should eq '512,34'
    end
  end

  context '#summary' do
    before do
      subject.stub(:budget_structure).and_return('Secretaria de educação')
      subject.stub(:creditor).and_return('Nohup')
    end

    it 'should uses budget_structure and creditor' do
      subject.summary.should eq "Estrutura orçamentaria: Secretaria de educação / Fornecedor: Nohup"
    end
  end
end
