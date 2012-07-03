# encoding: utf-8
require 'importer_helper'
require 'app/importers/expense_element_importer'
require 'active_support/core_ext/object/try'

describe ExpenseElementImporter do
  subject do
    described_class.new(null_storage)
  end

  let :null_storage do
    storage = double.as_null_object

    storage.stub(:transaction) do |&block|
      block.call
    end

    storage
  end

  it 'imports expense elements' do
    null_storage.should_receive(:create!).with('code' => '1', 'description' => 'APOSENTADORIAS')
    null_storage.should_receive(:create!).with('code' => '42', 'description' => 'AUXÍLIOS')
    null_storage.should_receive(:create!).with('code' => '70', 'description' => 'RATEIO PELA PARTICIPAÇÃO EM CONSÓRCIO PÚBLICO')

    subject.import!
  end
end
