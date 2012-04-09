# encoding: utf-8
require 'unit_helper'
require 'lib/importer'
require 'lib/revenue_source_importer'
require 'active_support/core_ext/object/try'

describe RevenueSourceImporter do
  subject do
    described_class.new(null_storage, subcategory_storage)
  end

  let :null_storage do
    storage = double.as_null_object

    storage.stub(:transaction) do |&block|
      block.call
    end

    storage
  end

  let :subcategory_storage do
    double(:id => 1)
  end

  it 'imports revenue subcategories' do
    subcategory_storage.stub(:where).and_return([subcategory_storage])
    subcategory_storage.stub(:joins).and_return(subcategory_storage)

    null_storage.should_receive(:create!).with('code' => '1', 'description' => 'IMPOSTOS', 'revenue_subcategory_id' => 1)
    null_storage.should_receive(:create!).with('code' => '2', 'description' => 'CONTRIBUIÇÕES ECONÔMICAS - INTRA-ORÇAMENTÁRIAS', 'revenue_subcategory_id' => 1)
    null_storage.should_receive(:create!).with('code' => '6', 'description' => 'RECEITA DE CESSÃO DE DIREITOS', 'revenue_subcategory_id' => 1)

    subject.import!
  end
end
