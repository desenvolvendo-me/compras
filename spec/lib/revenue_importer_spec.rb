# encoding: utf-8
require 'unit_helper'
require 'lib/importer'
require 'lib/revenue_category_importer'

describe RevenueCategoryImporter do
  subject do
    RevenueCategoryImporter.new(null_storage)
  end

  let :null_storage do
    storage = double.as_null_object

    storage.stub(:transaction) do |&block|
      block.call
    end

    storage
  end

  it 'imports revenue categories' do
    null_storage.should_receive(:create!).with('code' => '1', 'description' => 'RECEITAS CORRENTES')
    null_storage.should_receive(:create!).with('code' => '2', 'description' => 'RECEITAS DE CAPITAL')
    null_storage.should_receive(:create!).with('code' => '8', 'description' => 'RECEITAS DE CAPITAL - INTRA-ORÇAMENTÁRIAS')

    subject.import!
  end
end
