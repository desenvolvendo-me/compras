# encoding: utf-8
require 'decorator_helper'
require 'app/decorators/direct_purchase_decorator'

describe DirectPurchaseDecorator do
  it 'should return formatted total_allocations_items_value' do
    component.stub(:total_allocations_items_value).and_return(512.34)
    helpers.stub(:number_with_precision).with(512.34).and_return('512,34')

    subject.total_allocations_items_value.should eq '512,34'
  end

  it 'should return budget_structure and provider on summary' do
    subject.stub(:budget_structure).and_return('Secretaria de educação')
    subject.stub(:provider).and_return('Nohup')
    subject.summary.should eq "Estrutura orçamentária: Secretaria de educação / Fornecedor: Nohup"
  end
end
