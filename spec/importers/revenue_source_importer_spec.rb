# encoding: utf-8
require 'importer_helper'
require 'app/importers/revenue_source_importer'
require 'active_support/core_ext/object/try'

describe RevenueSourceImporter do
  subject do
    described_class.new(null_repository, subcategory_repository)
  end

  let :null_repository do
    repository = double.as_null_object

    repository.stub(:transaction) do |&block|
      block.call
    end

    repository
  end

  let :subcategory_repository do
    double(:id => 1)
  end

  it 'imports revenue subcategories' do
    subcategory_repository.stub(:where).and_return([subcategory_repository])
    subcategory_repository.stub(:joins).and_return(subcategory_repository)

    null_repository.should_receive(:create!).with('code' => '1', 'description' => 'IMPOSTOS', 'revenue_subcategory_id' => 1)
    null_repository.should_receive(:create!).with('code' => '2', 'description' => 'CONTRIBUIÇÕES ECONÔMICAS - INTRA-ORÇAMENTÁRIAS', 'revenue_subcategory_id' => 1)
    null_repository.should_receive(:create!).with('code' => '6', 'description' => 'RECEITA DE CESSÃO DE DIREITOS', 'revenue_subcategory_id' => 1)

    subject.import!
  end
end
