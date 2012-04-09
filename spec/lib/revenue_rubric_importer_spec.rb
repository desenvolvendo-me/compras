# encoding: utf-8
require 'unit_helper'
require 'lib/importer'
require 'lib/revenue_rubric_importer'
require 'active_support/core_ext/object/try'

describe RevenueRubricImporter do
  subject do
    described_class.new(null_storage, source_storage, subcategory_storage, category_storage)
  end

  let :null_storage do
    storage = double.as_null_object

    storage.stub(:transaction) do |&block|
      block.call
    end

    storage
  end

  let :source_storage do
    double
  end

  let :category_storage do
    double
  end

  let :subcategory_storage do
    double
  end

  it 'imports revenue rubric' do
    category_storage.stub(:find_by_code).and_return(double(:id => 1))

    subcategory_storage.stub(:find_by_code_and_revenue_category_id).and_return(double(:id => 1))

    source_storage.stub(:find_by_code_and_revenue_subcategory_id).and_return(double(:id => 1))

    null_storage.should_receive(:create!).with('code' => '2', 'description' => 'IMPOSTOS SOBRE O PATRIMÔNIO E A RENDA', 'revenue_source_id' => 1)
    null_storage.should_receive(:create!).with('code' => '3', 'description' => 'IMPOSTOS SOBRE A PRODUÇÃO E A CIRCULAÇÃO', 'revenue_source_id' => 1)
    null_storage.should_receive(:create!).with('code' => '3', 'description' => 'TRANSFERÊNCIAS DE CONVÊNIOS DOS MUNICÍPIOS E SUAS ENTIDADES', 'revenue_source_id' => 1)
    null_storage.should_receive(:create!).with('code' => '0', 'description' => 'RECEITAS DA INDÚSTRIA DE TRANSFORMAÇÃO', 'revenue_source_id' => 1)

    subject.import!
  end
end
