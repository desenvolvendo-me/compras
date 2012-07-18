# encoding: utf-8
require 'importer_helper'
require 'app/importers/expense_element_importer'
require 'active_support/core_ext/object/try'

describe ExpenseElementImporter do
  subject do
    described_class.new(null_repository)
  end

  let :null_repository do
    repository = double.as_null_object

    repository.stub(:transaction) do |&block|
      block.call
    end

    repository
  end

  it 'imports expense elements' do
    null_repository.should_receive(:create!).with('code' => '1', 'description' => 'APOSENTADORIAS')
    null_repository.should_receive(:create!).with('code' => '42', 'description' => 'AUXÍLIOS')
    null_repository.should_receive(:create!).with('code' => '70', 'description' => 'RATEIO PELA PARTICIPAÇÃO EM CONSÓRCIO PÚBLICO')

    subject.import!
  end
end
