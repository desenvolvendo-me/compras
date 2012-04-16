# encoding: utf-8
require 'unit_helper'
require 'lib/importer'
require 'lib/revenue_category_importer'
require 'active_support/core_ext/object/try'

describe RevenueCategoryImporter do
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

  it 'imports revenue categories' do
    null_storage.should_receive(:create!).with('code' => '1', 'description' => 'RECEITAS CORRENTES')
    null_storage.should_receive(:create!).with('code' => '7', 'description' => 'RECEITAS CORRENTES - INTRA-ORÇAMENTÁRIAS')
    null_storage.should_receive(:create!).with('code' => '8', 'description' => 'RECEITAS DE CAPITAL - INTRA-ORÇAMENTÁRIAS')

    subject.import!
  end
end
